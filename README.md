# 🐳 Docker Copilot CLI

Professional Docker container for  [Copilot CLI](https://github.com/github/copilot-cli) - The AI coding assistant that revolutionizes development productivity.

## 🎯 Why Use This Container?

- **🔒 Security First**: Non-root user execution with minimal attack surface
- **🔄 CI/CD Integration**: Automated builds and GitHub Actions support
- **🐋 Docker-in-Docker**: Full containerization capabilities included
- **⚡ Auto-Approval Mode**: Bypass interactive prompts for automated workflows

## 🚀 Quick Start

### Prerequisites

| Requirement | Version | Purpose |
|-------------|---------|---------|
| 🐳 **Docker** | 20.10+ | Container runtime |
| 🔧 **Docker Compose** | 2.0+ | Multi-container orchestration |
| 🔑 **GitHub Access** | App/PAT | Repository operations |
| 💾 **Free Disk Space** | 2GB+ | Image and container storage |

### ⚡ One-Command Setup

```bash
# Pull and run the latest image
docker run -it --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v ./config/home/node \
  -v ./workspace/workspace \
  --name copilot-cli \
  ghcr.io/legido-ai-workspace/copilot-cli:latest
```

## ⚙️ Auto-Approval Mode

For CI/CD pipelines, automated workflows, and non-interactive environments, you can enable auto-approval to bypass interactive confirmation prompts for `git clone` and other tool operations.

### Enable via Environment Variable

```bash
# Using docker run
docker run -it --rm \
  -e COPILOT_AUTO_APPROVE_GIT_CLONE=true \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v ./config:/home/node \
  -v ./workspace:/workspace \
  ghcr.io/legido-ai-workspace/copilot-cli:latest
```

### Enable via Docker Compose

Set the variable in your `.env` file:

```bash
COPILOT_AUTO_APPROVE_GIT_CLONE=true
```

Or directly in `docker-compose.yml`:

```yaml
environment:
  COPILOT_AUTO_APPROVE_GIT_CLONE: "true"
```

### Configuration Options

| Value | Behavior |
|-------|----------|
| `true`, `1`, `yes`, `on` | Auto-approval enabled - all tool operations proceed without prompts |
| `false`, `0`, `no`, `off` | Auto-approval disabled - interactive prompts appear (default) |
| Not set | Interactive mode (default behavior) |

### Startup Logs

When auto-approval is configured, you'll see these log messages at container startup:

```
[AUTO-APPROVE] Checking auto-approval configuration...
[AUTO-APPROVE] Configuring git clone auto-approval...
[AUTO-APPROVE] Git clone auto-approval enabled successfully
[AUTO-APPROVE] All tool operations will proceed without interactive prompts
```

### Use Cases

- **CI/CD Pipelines**: Run Copilot CLI in GitHub Actions, Jenkins, or other CI systems
- **Kubernetes Deployments**: Automated container orchestration without TTY
- **Batch Operations**: Scripted workflows that execute multiple commands
- **Unattended Containers**: Background processes that don't have user interaction

### Security Considerations

⚠️ **Important**: Auto-approval mode grants permission for all tool operations without confirmation. Only enable this in trusted, controlled environments where you understand the implications.

## 📝 Copilot Instructions

Custom Copilot instructions can be added to enhance the AI's behavior, for more information, see the [official documentation](https://copilot-instructions.md).

Place your instructions in:

`/workspace/.github/copilot-instructions.md`.
