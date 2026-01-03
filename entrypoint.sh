#!/bin/bash
set -e

CONFIG_FILE="/home/node/.copilot/mcp-config.json"
COPILOT_CONFIG_FILE="/home/node/.copilot/config.json"

# Function to escape value for JSON and sed replacement
escape_for_json_and_sed() {
    local input="$1"
    local output=""

    # We need to escape for BOTH JSON and sed replacement string
    # For JSON: \ -> \\, " -> \", newline -> \n
    # For sed replacement: \ -> \\, & -> \&, / -> \/
    # Combined: we need \\\\ for each backslash in the final sed command

    # First escape backslashes for JSON (\ -> \\)
    input="${input//\\/\\\\}"

    # Then escape quotes for JSON (" -> \")
    input="${input//\"/\\\"}"

    # Now convert newlines to \n for JSON, but we need to escape the backslash again for sed
    # So newline becomes \\n (which sed will turn into \n in the file)
    output=$(printf '%s' "$input" | awk '{printf "%s\\\\n", $0} END {if (NR > 0) printf ""}' | sed '$ s/\\\\n$//')

    # Finally escape & and / for sed
    output="${output//&/\\&}"
    output="${output//\//\\/}"

    printf '%s' "$output"
}

# Function to process environment variable replacements
process_env_vars() {
    local config_file="$1"

    # Check if config file exists
    if [ ! -f "$config_file" ]; then
        echo "[ENV-EXPAND] Config file not found at $config_file, skipping"
        return 0
    fi

    # Check if there are any environment variable references (pattern: $VAR_NAME)
    if ! grep -q '\$[A-Za-z_][A-Za-z0-9_]*' "$config_file"; then
        echo "[ENV-EXPAND] No environment variable references found"
        return 0
    fi

    echo "[ENV-EXPAND] Found environment variable references in $config_file"

    # Create backup with timestamp
    timestamp=$(date +%s)
    backup_file="${config_file}.backup.${timestamp}"
    cp "$config_file" "$backup_file"
    echo "[ENV-EXPAND] Created backup: $backup_file"

    # Get all unique variable names from the config file
    var_names=$(grep -o '\$[A-Za-z_][A-Za-z0-9_]*' "$config_file" | sed 's/^\$//' | sort -u)

    # Process replacements
    for var_name in $var_names; do
        # Check if the environment variable exists using indirect expansion
        if [ -n "${!var_name+x}" ]; then
            # Get the value
            var_value="${!var_name}"

            # Escape for both JSON and sed replacement
            escaped_value=$(escape_for_json_and_sed "$var_value")

            # Perform the replacement
            sed -i "s/\$$var_name/$escaped_value/g" "$config_file"

            echo "[ENV-EXPAND] Replaced \$$var_name with actual value"
        else
            echo "[ENV-EXPAND] Warning: \$$var_name not found in environment, keeping as-is"
        fi
    done

    echo "[ENV-EXPAND] Environment variable expansion completed successfully"
}

# Function to configure auto-approval for git clone operations
configure_copilot_auto_approval() {
    local auto_approve="${COPILOT_AUTO_APPROVE_GIT_CLONE:-false}"
    
    # Normalize the value to lowercase for comparison
    auto_approve=$(echo "$auto_approve" | tr '[:upper:]' '[:lower:]')
    
    # Validate the value
    if [ "$auto_approve" != "true" ] && [ "$auto_approve" != "false" ]; then
        echo "[AUTO-APPROVE] Warning: Invalid value for COPILOT_AUTO_APPROVE_GIT_CLONE: '$COPILOT_AUTO_APPROVE_GIT_CLONE'"
        echo "[AUTO-APPROVE] Expected 'true' or 'false', defaulting to 'false'"
        auto_approve="false"
    fi
    
    if [ "$auto_approve" = "true" ]; then
        echo "[AUTO-APPROVE] Configuring git clone auto-approval..."
        
        # Create .copilot directory if it doesn't exist
        mkdir -p /home/node/.copilot
        
        # Create or update the Copilot config file with auto-approval configuration
        # This configuration allows git clone commands to run without interactive prompts
        cat > "$COPILOT_CONFIG_FILE" <<'EOF'
{
  "chat.tools.terminal.autoApprove": {
    "/^git\\s+clone(\\s+.*)?$/": true
  }
}
EOF
        
        # Verify the file was created successfully
        if [ -f "$COPILOT_CONFIG_FILE" ]; then
            echo "[AUTO-APPROVE] Git clone auto-approval enabled successfully"
            echo "[AUTO-APPROVE] All 'git clone' operations will proceed without interactive prompts"
        else
            echo "[AUTO-APPROVE] Error: Failed to create auto-approval configuration"
        fi
    else
        echo "[AUTO-APPROVE] Git clone auto-approval is disabled (default behavior)"
        
        # Remove the auto-approval config file if it exists
        if [ -f "$COPILOT_CONFIG_FILE" ]; then
            rm -f "$COPILOT_CONFIG_FILE"
            echo "[AUTO-APPROVE] Removed existing auto-approval configuration"
        fi
    fi
}

# Process environment variables once at boot time
process_env_vars "$CONFIG_FILE"

# Configure auto-approval for git clone operations
configure_copilot_auto_approval

# Process environment variables or configuration files with jq at startup
# For example, if there are JSON configuration files, we could validate or process them

# Example: Process any JSON configuration in the environment or from a file
# This is functionality for the GitHub issue - validating JSON
if [ -f "/workspace/config.json" ]; then
  echo "Validating config.json with jq..."
  cat /workspace/config.json | jq '.' > /dev/null
  if [ $? -eq 0 ]; then
    echo "config.json is valid JSON"
  else
    echo "config.json has JSON syntax errors"
    exit 1
  fi
fi

# Process environment variables that might be JSON strings
if [ ! -z "$JSON_CONFIG" ]; then
  echo "Processing JSON_CONFIG environment variable..."
  echo "$JSON_CONFIG" | jq '.' > /dev/null
  if [ $? -eq 0 ]; then
    echo "JSON_CONFIG is valid"
    # Optionally save to a file for the main process to use
    echo "$JSON_CONFIG" | jq '.' > /workspace/processed_config.json
  else
    echo "JSON_CONFIG has JSON syntax errors"
    exit 1
  fi
fi

# Execute the container's original command
exec "$@"
