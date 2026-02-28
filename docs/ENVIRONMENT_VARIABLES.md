# Environment Variables

This document explains the environment variables used by the Docker Copilot CLI container.

## Auto-Approval Variables

### `COPILOT_ALLOW_ALL` (Recommended)

**Official GitHub Copilot CLI environment variable to enable auto-approval.**

- **Purpose**: Enable fully autonomous Copilot CLI operation (no interactive prompts)
- **Set by**: User (in docker-compose.yml or with docker run -e) or CI environments
- **Values**:
  - `true`, `1`, `yes`, `on` — Enable auto-approval
  - `false`, `0`, `no`, `off` — Disable auto-approval
  - Not set — Disabled (default)
- **Usage**:
  ```bash
  docker run -e COPILOT_ALLOW_ALL=true legidoai/copilot-cli
  ```

Note: Set COPILOT_ALLOW_ALL directly; there is no separate wrapper variable.

This abstraction provides:
- ✅ More intuitive variable name for users
- ✅ Flexibility to add additional auto-approval logic in the future
- ✅ Compatibility with GitHub's official Copilot CLI environment variables

## How Auto-Approval Persists

When `COPILOT_ALLOW_ALL=true`, the entrypoint script:

1. Exports `COPILOT_ALLOW_ALL=true` for the current process
2. Writes `export COPILOT_ALLOW_ALL=true` to `/home/node/.copilot_env`
3. Adds `source ~/.copilot_env` to `/home/node/.bashrc`

This ensures that `docker exec` sessions also have auto-approval enabled.

## Other Copilot CLI Environment Variables

These are official GitHub Copilot CLI variables you can also use:

### `COPILOT_MODEL`

Set the default AI model.

```bash
docker run -e COPILOT_MODEL=gpt-5-mini legidoai/copilot-cli
```

**Valid values**: `claude-sonnet-4.5`, `gpt-5-mini`, `gpt-5`, etc.

### `COPILOT_AUTO_UPDATE`

Control automatic CLI updates.

```bash
docker run -e COPILOT_AUTO_UPDATE=false legidoai/copilot-cli
```

**Values**: `true` (default) or `false`

### `COPILOT_GITHUB_TOKEN`

Override GitHub authentication token.

```bash
docker run -e COPILOT_GITHUB_TOKEN=ghp_xxx legidoai/copilot-cli
```

Takes precedence over `GH_TOKEN` and `GITHUB_TOKEN`.

### `XDG_CONFIG_HOME` / `XDG_STATE_HOME`

Override configuration and state directories (defaults to `$HOME/.copilot`).

```bash
docker run -e XDG_CONFIG_HOME=/custom/config legidoai/copilot-cli
```

## Container-Specific Variables

These are specific to our Docker container configuration:

### `DIND_DOCKER_GID`

Docker group GID exposed by the `docker:dind` sidecar socket.

- **Purpose**: Grants `copilot-cli` access to the DinD Unix socket via `group_add`
- **Default**: `2375` (default `docker` group in `docker:dind`)
- **Set in**: `.env` / shell env used by `docker compose`
- **Usage**:
  ```bash
  DIND_DOCKER_GID=2375
  ```

### AWS Credentials

For AWS operations via Docker-based AWS CLI:

```yaml
environment:
  AWS_ACCESS_KEY_ID: ${AWS_ACCESS_KEY_ID}
  AWS_SECRET_ACCESS_KEY: ${AWS_SECRET_ACCESS_KEY}
  AWS_DEFAULT_REGION: ${AWS_DEFAULT_REGION}
```

### GitHub App Authentication (MCP)

For GitHub MCP server authentication:

```yaml
environment:
  GITHUB_APP_ID: ${GITHUB_APP_ID}
  GITHUB_INSTALLATION_ID: ${GITHUB_INSTALLATION_ID}
  GITHUB_PRIVATE_KEY: ${GITHUB_PRIVATE_KEY}
```

### Phoenix MCP Server

For Phoenix observability:

```yaml
environment:
  PHOENIX_API_KEY: ${PHOENIX_API_KEY}
  PHOENIX_ENDPOINT: ${PHOENIX_ENDPOINT}
```

### SSH Private Key

For SSH operations (e.g., connecting to test servers):

```yaml
environment:
  SSH_PRIVATE_KEY: ${SSH_PRIVATE_KEY}
```

## Docker Compose Example

Complete example with all common variables:

```yaml
version: '3.8'

services:
  copilot-cli:
    image: legidoai/copilot-cli:latest
    stdin_open: true
    tty: true
    environment:
      # Auto-approval (fully autonomous mode)
      COPILOT_ALLOW_ALL: "true"
      
      # Copilot CLI settings
      COPILOT_MODEL: "gpt-5-mini"
      COPILOT_AUTO_UPDATE: "false"
      
      # AWS credentials
      AWS_ACCESS_KEY_ID: ${AWS_ACCESS_KEY_ID}
      AWS_SECRET_ACCESS_KEY: ${AWS_SECRET_ACCESS_KEY}
      AWS_DEFAULT_REGION: ${AWS_DEFAULT_REGION}
      
      # GitHub App (MCP)
      GITHUB_APP_ID: ${GITHUB_APP_ID}
      GITHUB_INSTALLATION_ID: ${GITHUB_INSTALLATION_ID}
      GITHUB_PRIVATE_KEY: ${GITHUB_PRIVATE_KEY}
      
      # Phoenix MCP
      PHOENIX_API_KEY: ${PHOENIX_API_KEY}
      PHOENIX_ENDPOINT: ${PHOENIX_ENDPOINT}
      
      # SSH
      SSH_PRIVATE_KEY: ${SSH_PRIVATE_KEY}
      
      # Timezone
      TZ: "UTC"
    volumes:
      - copilot-data:/home/node/.copilot
      - /var/run/docker.sock:/var/run/docker.sock
      - ./workspace:/workspace

volumes:
  copilot-data:
```

## Security Best Practices

1. **Never commit secrets** to git repositories
2. **Use `.env` files** for local development (add to `.gitignore`)
3. **Use secret managers** in production (AWS Secrets Manager, GitHub Secrets, etc.)
4. **Limit `COPILOT_ALLOW_ALL=true`** to trusted, controlled environments
5. **Rotate credentials regularly**, especially GitHub tokens
6. **Use volume mounts** (not bind mounts) for `/home/node/.copilot` for better security

## Troubleshooting

### Auto-approval not working

**Symptom**: Still getting interactive prompts despite `COPILOT_ALLOW_ALL=true`

**Solutions**:
1. Verify the variable is set:
   ```bash
   docker exec <container> env | grep COPILOT
   ```

2. Check if `.copilot_env` exists:
   ```bash
   docker exec <container> cat /home/node/.copilot_env
   ```

3. Recreate container with updated image:
   ```bash
   docker-compose down
   docker-compose up -d
   ```

### Environment variable not persisting

**Symptom**: Variable set in Dockerfile but not available in `docker exec`

**Solution**: Environment variables must be set in the running container, not just in the entrypoint. Use docker-compose.yml or `docker run -e` to set them.

## Reference

- [Official Copilot CLI Environment Variables](https://github.com/github/copilot-cli) - Run `copilot help environment` for the complete list
- [Docker Environment Variables](https://docs.docker.com/compose/environment-variables/)
