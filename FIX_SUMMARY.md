# Authentication Persistence Bug Fix

## Problem

After commit `e8e7cbc` (PR #3), authentication credentials were lost when the Docker container was restarted or recreated. Users had to re-authenticate every time.

## Root Cause

**Commit e8e7cbc** changed the container execution model:
- **Before**: Container ran as `node` user (UID 1000)
- **After**: Container ran as `root`, then switched to `node` using `runuser`

This broke authentication persistence because:

1. The entrypoint script running as root tried to manage `/home/node/.copilot` permissions
2. When users mounted volumes to `/home/node` (for persistence), the root-based permission logic interfered
3. Authentication tokens stored in `/home/node/.copilot/config.json` were not properly persisted

## Solution

Reverted to the original working approach while keeping the auto-approval feature:

### Changes Made

1. **Dockerfile** - Reverted to run as `node` user:
   ```dockerfile
   USER node
   COPY --chown=node:node entrypoint.sh /usr/local/bin/entrypoint.sh
   ```

2. **entrypoint.sh** - Removed root-based permission fixing:
   - Removed `/home/node` directory creation/chown logic
   - Removed `runuser -u node` wrapper
   - Kept `configure_copilot_auto_approval()` function (auto-approval still works)
   - Changed from `exec runuser -u node -- "$@"` to `exec "$@"`

3. **Documentation** - Added comprehensive authentication guide:
   - Created `docs/AUTHENTICATION.md` with detailed persistence instructions
   - Updated README.md with authentication section and link to docs

## How Authentication Persistence Works Now

Authentication is stored in `/home/node/.copilot/` and persists when mounted as a volume:

```bash
docker run -it \
  -v copilot-data:/home/node/.copilot \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $(pwd):/workspace \
  -e COPILOT_ALLOW_ALL=true \
  legidoai/copilot-cli:latest
```

### Files Persisted

- `/home/node/.copilot/config.json` - Authentication tokens and user preferences
- `/home/node/.copilot/session-state/` - Session history
- `/home/node/.copilot/pkg/` - Package cache (optional)

## Testing

To test the fix:

1. Start a container with volume mount:
   ```bash
   docker run -it --name test1 -v copilot-data:/home/node/.copilot legidoai/copilot-cli:latest
   # Authenticate if needed
   ```

2. Stop and remove the container:
   ```bash
   docker stop test1 && docker rm test1
   ```

3. Start a new container with the same volume:
   ```bash
   docker run -it --name test2 -v copilot-data:/home/node/.copilot legidoai/copilot-cli:latest
   # Authentication should be preserved - no re-authentication needed
   ```

## Auto-Approval Feature

The auto-approval feature (introduced in PR #3) **still works correctly** after this fix:

```bash
docker run -it \
  -v copilot-data:/home/node/.copilot \
  -e COPILOT_ALLOW_ALL=true \
  legidoai/copilot-cli:latest
```

Both features now work together as intended.

## Commit Details

- **Fix commit**: `0e6e9b3`
- **Broken by**: `e8e7cbc` (PR #3)
- **Working before**: `fb59f9b` (before PR #3)

## Files Changed

- `Dockerfile` - Reverted to `USER node`
- `entrypoint.sh` - Removed root-based logic, kept auto-approval
- `docs/AUTHENTICATION.md` - New comprehensive documentation
- `README.md` - Added authentication persistence section
