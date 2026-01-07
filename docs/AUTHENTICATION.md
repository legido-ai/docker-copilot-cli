# Authentication Persistence in Copilot CLI Docker

## Overview

The Copilot CLI stores authentication credentials in `/home/node/.copilot/config.json`. To persist authentication across container restarts, you need to mount this directory as a volume.

## Authentication Storage Location

Authentication data is stored in:
- **Config file**: `/home/node/.copilot/config.json` - Contains user info and tokens
- **Session state**: `/home/node/.copilot/session-state/` - Contains session history
- **Package cache**: `/home/node/.copilot/pkg/` - Contains CLI binaries (optional to persist)

## How to Persist Authentication

### Option 1: Mount the entire `.copilot` directory (Recommended)

```bash
docker run -it \
  -v copilot-data:/home/node/.copilot \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $(pwd):/workspace \
  -e COPILOT_ALLOW_ALL=true \
  legidoai/copilot-cli:latest
```

This approach persists:
- ✅ Authentication tokens
- ✅ Session history
- ✅ User preferences
- ✅ Package cache (faster startup)

### Option 2: Mount only the config file

```bash
docker run -it \
  -v copilot-config:/home/node/.copilot/config.json \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $(pwd):/workspace \
  -e COPILOT_ALLOW_ALL=true \
  legidoai/copilot-cli:latest
```

This approach persists only authentication, session data will be lost on restart.

### Option 3: Bind mount to host directory

```bash
mkdir -p ~/.copilot-docker

docker run -it \
  -v ~/.copilot-docker:/home/node/.copilot \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $(pwd):/workspace \
  -e COPILOT_ALLOW_ALL=true \
  legidoai/copilot-cli:latest
```

This stores authentication data on your host machine at `~/.copilot-docker`.

## Using with Auto-Approval

The `COPILOT_ALLOW_ALL` environment variable enables fully autonomous mode. Combine it with authentication persistence:

```bash
docker run -it \
  -v copilot-data:/home/node/.copilot \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $(pwd):/workspace \
  -e COPILOT_ALLOW_ALL=true \
  legidoai/copilot-cli:latest
```

### Auto-Approval Values

- `true`, `1`, `yes`, `on` - Enable auto-approval (fully autonomous)
- `false`, `0`, `no`, `off` - Disable auto-approval (manual confirmation required)
- Not set - Default behavior (manual confirmation required)

## Docker Compose Example

```yaml
version: '3.8'

services:
  copilot-cli:
    image: legidoai/copilot-cli:latest
    stdin_open: true
    tty: true
    volumes:
      - copilot-data:/home/node/.copilot
      - /var/run/docker.sock:/var/run/docker.sock
      - ./workspace:/workspace
    environment:
      - COPILOT_ALLOW_ALL=true
    working_dir: /workspace

volumes:
  copilot-data:
```

## Verifying Authentication Persistence

1. Start the container and authenticate:
   ```bash
   docker run -it --name copilot-test \
     -v copilot-data:/home/node/.copilot \
     legidoai/copilot-cli:latest
   
   # Inside container, authenticate if needed
   ```

2. Stop and remove the container:
   ```bash
   docker stop copilot-test
   docker rm copilot-test
   ```

3. Start a new container with the same volume:
   ```bash
   docker run -it --name copilot-test2 \
     -v copilot-data:/home/node/.copilot \
     legidoai/copilot-cli:latest
   
   # Authentication should be preserved
   ```

## Troubleshooting

### Authentication lost after restart

**Symptom**: Need to re-authenticate every time container restarts.

**Solution**: Ensure you're mounting `/home/node/.copilot` as a volume:
```bash
docker run -v copilot-data:/home/node/.copilot ...
```

### Permission denied errors

**Symptom**: Cannot write to `/home/node/.copilot`.

**Solution**: The container runs as the `node` user (UID 1000). Ensure volume ownership is correct:
```bash
# If using bind mount
chown -R 1000:1000 ~/.copilot-docker
```

### Token expired

**Symptom**: Authentication token no longer works.

**Solution**: Re-authenticate inside the container. Tokens are managed by GitHub and may expire.

## Security Considerations

1. **Token Storage**: Authentication tokens are stored in plain text in `config.json`. Protect this file.
2. **Volume Permissions**: Use Docker named volumes (not bind mounts) for better security.
3. **Token Rotation**: GitHub tokens may expire; be prepared to re-authenticate.
4. **Auto-Approval**: Only use `COPILOT_ALLOW_ALL=true` in trusted environments.

## Config File Format

Example `/home/node/.copilot/config.json`:
```json
{
  "banner": "never",
  "last_logged_in_user": {
    "host": "https://github.com",
    "login": "username"
  },
  "logged_in_users": [
    {
      "host": "https://github.com",
      "login": "username"
    }
  ],
  "copilot_tokens": {
    "https://github.com:username": "gho_..."
  }
}
```

## Migration from Old Setup

If you had authentication working before but it's now lost:

1. Find your old container:
   ```bash
   docker ps -a
   ```

2. Copy authentication data:
   ```bash
   docker cp <old-container>:/home/node/.copilot/config.json ./copilot-backup.json
   ```

3. Create new container with volume and restore:
   ```bash
   docker run -d --name copilot \
     -v copilot-data:/home/node/.copilot \
     legidoai/copilot-cli:latest
   
   docker cp ./copilot-backup.json copilot:/home/node/.copilot/config.json
   ```
