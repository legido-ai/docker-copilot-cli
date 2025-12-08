#!/bin/sh
set -e

# Define path to the config file
CONFIG_FILE="/home/node/.qwen/settings.json"

# Check if the GITHUB_PERSONAL_ACCESS_TOKEN is set
if [ -n "$GITHUB_PERSONAL_ACCESS_TOKEN" ]; then
  # Use jq to modify the config file in-place
  # Create a temporary file to avoid issues with writing to the same file we're reading
  tmp_file=$(mktemp)
  jq --arg token "$GITHUB_PERSONAL_ACCESS_TOKEN" \
     '.mcpServers.github.args[-2] = "GITHUB_PERSONAL_ACCESS_TOKEN=" + $token' \
     "$CONFIG_FILE" > "$tmp_file" && mv "$tmp_file" "$CONFIG_FILE"
fi

# Execute the container's original command (starts Qwen Code)
exec "$@"
