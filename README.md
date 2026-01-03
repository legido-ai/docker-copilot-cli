# 🐳 Docker Copilot CLI

Professional Docker container for  [Copilot CLI](https://github.com/github/copilot-cli) - The AI coding assistant that revolutionizes development productivity.

## 🎯 Why Use This Container?

- **🔒 Security First**: Non-root user execution with minimal attack surface
- **🔄 CI/CD Integration**: Automated builds and GitHub Actions support
- **🐋 Docker-in-Docker**: Full containerization capabilities included

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

## 📝 Copilot Instructions

Custom Copilot instructions can be added to enhance the AI's behavior. For more information, see the [official documentation](https://copilot-instructions.md). Place your instructions in `/workspace/.github/copilot-instructions.md`.
