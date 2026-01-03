# 🐳 Docker Copilot CLI

Professional Docker container for  [Copilot CLI](https://github.com/github/copilot-cli) - The AI coding assistant that revolutionizes development productivity.

## 🎯 Why Use This Container?

- **🔒 Security First**: Non-root user execution with minimal attack surface
- **🔄 CI/CD Integration**: Automated builds and GitHub Actions support
- **🐋 Docker-in-Docker**: Full containerization capabilities included
- **⚡ Auto-Approval**: Optional automatic approval for git clone operations

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

### Auto-Approval for Git Clone Operations

By default, Copilot CLI presents an interactive prompt when executing `git clone` commands:
```
Do you want to run this command?

> git clone <repository-url>

1. Yes
2. Yes, and approve git clone for the rest of the running session
3. No
```

For automated workflows, CI/CD pipelines, and non-interactive environments, you can enable automatic approval:

#### Using Docker Compose

1. Create a `.env` file (or copy from `.env.example`):
```bash
cp .env.example .env
```

2. Set the auto-approval environment variable:
```bash
COPILOT_AUTO_APPROVE_GIT_CLONE=true
```

3. Start the container:
```bash
docker-compose up
```

#### Using Docker Run

```bash
docker run -it --rm \
  -e COPILOT_AUTO_APPROVE_GIT_CLONE=true \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v ./config:/home/node \
  -v ./workspace:/workspace \
  --name copilot-cli \
  ghcr.io/legido-ai-workspace/copilot-cli:latest
```

#### Behavior

- **When enabled** (`true`): All `git clone` operations proceed automatically without interactive prompts
- **When disabled** (`false` or unset): Default interactive behavior (requires manual approval)
- **Session persistence**: Auto-approval applies to all git clone commands during the container session
- **Security**: Only `git clone` commands are auto-approved; all other commands require standard approval

#### Use Cases

This feature is particularly useful for:
- ✅ Automated CI/CD pipelines
- ✅ Unattended container deployments
- ✅ Scripted batch operations
- ✅ Kubernetes-based orchestration
- ✅ GitHub Actions workflows

#### Verification

When auto-approval is enabled, you'll see the following in the container startup logs:
```
[AUTO-APPROVE] Configuring git clone auto-approval...
[AUTO-APPROVE] Git clone auto-approval enabled successfully
[AUTO-APPROVE] All 'git clone' operations will proceed without interactive prompts
```

When disabled (default):
```
[AUTO-APPROVE] Git clone auto-approval is disabled (default behavior)
```

## 📝 Copilot Instructions

Custom Copilot instructions can be added to enhance the AI's behavior, for more information, see the [official documentation](https://copilot-instructions.md).

Place your instructions in:

`/workspace/.github/copilot-instructions.md`.
