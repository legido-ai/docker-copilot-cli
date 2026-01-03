# 🐳 Docker Copilot CLI

Professional Docker container for  [Copilot CLI](https://github.com/github/copilot-cli) - The AI coding assistant that revolutionizes development productivity.

## 🎯 Why Use This Container?

- **🔒 Security First**: Non-root user execution with minimal attack surface
- **🔄 CI/CD Integration**: Automated builds and GitHub Actions support
- **🐋 Docker-in-Docker**: Full containerization capabilities included
- **⚡ YOLO Mode**: Optional automatic approval for all commands in trusted environments

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

## 🔧 Configuration

### Auto-Approval for All Commands (YOLO Mode)

By default, Copilot CLI presents an interactive prompt when executing commands:
```
Do you want to run this command?

> <command>

1. Yes
2. Yes, and approve <command> for the rest of the running session
3. No
```

For automated workflows, CI/CD pipelines, and non-interactive environments, you can enable automatic approval for **all commands**:

⚠️ **WARNING**: YOLO mode bypasses all command approval dialogs. Only enable in **trusted, sandboxed, disposable environments**. Never use in production or with sensitive data.

#### Using Docker Compose

1. Create a `.env` file (or copy from `.env.example`):
```bash
cp .env.example .env
```

2. Set the auto-approval environment variable:
```bash
COPILOT_AUTO_APPROVE_COMMANDS=true
```

3. Start the container:
```bash
docker-compose up
```

#### Using Docker Run

```bash
docker run -it --rm \
  -e COPILOT_AUTO_APPROVE_COMMANDS=true \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v ./config:/home/node \
  -v ./workspace:/workspace \
  --name copilot-cli \
  ghcr.io/legido-ai-workspace/copilot-cli:latest
```

#### Behavior

- **When enabled** (`true`): ALL commands execute automatically without interactive prompts
- **When disabled** (`false` or unset): Default interactive behavior (requires manual approval)
- **Session persistence**: Auto-approval applies to all commands during the container session
- **Security**: This is "YOLO mode" - use only in trusted environments

#### Use Cases

This feature is particularly useful for:
- ✅ Automated CI/CD pipelines in isolated environments
- ✅ Ephemeral test containers
- ✅ Scripted batch operations in sandboxed environments
- ✅ Development workflows in trusted local environments

❌ **DO NOT USE** in:
- Production environments
- Shared development systems
- Environments with sensitive data
- Remote servers or production codespaces

#### Verification

When auto-approval is enabled, you'll see the following in the container startup logs:
```
[AUTO-APPROVE] Configuring YOLO mode (auto-approve ALL commands)...
[AUTO-APPROVE] WARNING: All commands will execute without approval prompts
[AUTO-APPROVE] YOLO mode enabled successfully
[AUTO-APPROVE] ALL commands will proceed without interactive prompts
```

When disabled (default):
```
[AUTO-APPROVE] YOLO mode is disabled (default behavior)
```

## 📝 Copilot Instructions

Custom Copilot instructions can be added to enhance the AI's behavior, for more information, see the [official documentation](https://copilot-instructions.md).

Place your instructions in:

`/workspace/.github/copilot-instructions.md`.
