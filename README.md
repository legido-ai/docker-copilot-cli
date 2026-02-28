# 🐳 Docker Copilot CLI

Professional Docker container for  [Copilot CLI](https://github.com/github/copilot-cli) - The AI coding assistant that revolutionizes development productivity.

## 🎯 Why Use This Container?

- **🔒 Security First**: Non-root user execution with minimal attack surface
- **🔄 CI/CD Integration**: Automated builds and GitHub Actions support
- **🐋 Docker-in-Docker**: Full containerization capabilities included
- **🤖 Fully Autonomous Mode**: Run Copilot CLI without any interactive prompts

## 🚀 Quick Start

### Prerequisites

| Requirement | Version | Purpose |
|-------------|---------|---------|
| 🐳 **Docker** | 20.10+ | Container runtime |
| 🔧 **Docker Compose** | 2.0+ | Multi-container orchestration |
| 🔑 **GitHub Access** | App/PAT | Repository operations |
| 💾 **Free Disk Space** | 2GB+ | Image and container storage |

### ⚡ One-Command Setup with Docker Compose

This container uses **Docker-in-Docker (DinD)** for complete container isolation. To start:

```bash
# Clone and setup the repository
git clone https://github.com/legido-ai/docker-copilot-cli.git
cd docker-copilot-cli

# Create environment configuration (optional)
cp .env.example .env

# Start the services (DinD + Copilot CLI)
docker-compose up -d

# Access the Copilot CLI container
docker-compose exec copilot-cli bash
```

### Docker Run Alternative

For standalone Docker runs without Docker Compose, use Docker-in-Docker with a separate DinD container:

```bash
# Start the DinD service first
docker run -d \
  --name dind-copilot \
  --privileged \
  -v dind-socket:/dind \
  -v dind-storage:/var/lib/docker \
  docker:dind --host=unix:///dind/docker.sock

# Wait for DinD to be healthy (about 10 seconds)
sleep 10

# Run the Copilot CLI container connected to DinD
docker run -it --rm \
  --volumes-from dind-copilot:ro \
  -v ./workspace:/workspace \
  -v ./config:/home/node \
  -v dind-socket:/dind \
  -e DOCKER_HOST=unix:///dind/docker.sock \
  --link dind-copilot \
  ghcr.io/legido-ai-workspace/copilot-cli:latest
```

## 🤖 Fully Autonomous Mode

For CI/CD pipelines, automated workflows, and non-interactive environments, enable autonomous mode to make Copilot CLI fully autonomous - **ALL operations proceed without any interactive prompts**.

### What Gets Auto-Approved

When `COPILOT_ALLOW_ALL=true`, the following operations proceed automatically:
- ✅ `git clone`, `git push`, `git pull` and all git operations
- ✅ File creation, editing, and deletion
- ✅ Shell command execution
- ✅ Package installations (npm, pip, apt, etc.)
- ✅ Docker operations
- ✅ API calls and network operations
- ✅ **ALL tool operations** - no exceptions

### Enable via Environment Variable

```bash
# Using docker run - fully autonomous
docker run -it --rm \
  -e COPILOT_ALLOW_ALL=true \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v ./config:/home/node \
  -v ./workspace:/workspace \
  ghcr.io/legido-ai-workspace/copilot-cli:latest
```

### Enable via Docker Compose

Set the variable in your `.env` file:

```bash
COPILOT_ALLOW_ALL=true
```

Or directly in `docker-compose.yml`:

```yaml
environment:
  COPILOT_ALLOW_ALL: "true"
```

### Configuration Options

| Value | Behavior |
|-------|----------|
| `true`, `1`, `yes`, `on` | **Fully autonomous** - all operations proceed without any prompts |
| `false`, `0`, `no`, `off` | Interactive mode - prompts for confirmations (default) |
| Not set | Interactive mode (default behavior) |

**Note**: Set COPILOT_ALLOW_ALL (official Copilot CLI environment variable) to enable auto-approval. See [docs/ENVIRONMENT_VARIABLES.md](docs/ENVIRONMENT_VARIABLES.md) for details on all environment variables.

### Startup Logs

When autonomous mode is enabled, you'll see these log messages at container startup:

```
[AUTO-APPROVE] Checking auto-approval configuration...
[AUTO-APPROVE] Configuring auto-approval for all operations...
[AUTO-APPROVE] Auto-approval enabled successfully
[AUTO-APPROVE] All tool operations will proceed without interactive prompts
[AUTO-APPROVE] Copilot CLI is now fully autonomous
```

### Use Cases

- **CI/CD Pipelines**: Run Copilot CLI in GitHub Actions, Jenkins, or other CI systems
- **Kubernetes Deployments**: Automated container orchestration without TTY
- **Batch Operations**: Scripted workflows that execute multiple commands
- **Unattended Containers**: Background processes that don't have user interaction
- **Automated Code Reviews**: Let Copilot analyze and fix code autonomously
- **Infrastructure Automation**: Automated deployments and system management

### Security Considerations

⚠️ **Important**: Autonomous mode grants permission for **ALL tool operations** without confirmation. This means Copilot CLI can:
- Execute any shell command
- Modify or delete any file in the workspace
- Make network requests
- Install packages
- Push changes to git repositories

**Only enable this in trusted, controlled environments** where you understand and accept these implications. The container runs as non-root user `node` which provides some isolation.

## 🔐 Authentication Persistence

By default, authentication credentials are stored inside the container and will be lost when the container is removed. To persist authentication across container restarts:

```bash
docker run -it --rm \
  -v copilot-data:/home/node/.copilot \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v ./workspace:/workspace \
  -e COPILOT_ALLOW_ALL=true \
  ghcr.io/legido-ai-workspace/copilot-cli:latest
```

This mounts a Docker volume to `/home/node/.copilot` which stores:
- Authentication tokens
- User preferences  
- Session history
- Package cache

**📖 For detailed authentication setup and troubleshooting, see [docs/AUTHENTICATION.md](docs/AUTHENTICATION.md)**

## 📝 Copilot Instructions

Custom Copilot instructions can be added to enhance the AI's behavior, for more information, see the [official documentation](https://copilot-instructions.md).

Place your instructions in:

`/workspace/.github/copilot-instructions.md`.
