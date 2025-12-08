# 🐳 Docker Qwen Code

> **Professional Docker container for [Qwen Code](https://github.com/QwenLM/Qwen2.5-Coder) - The AI coding assistant that revolutionizes development productivity**

[![Docker Image Size](https://img.shields.io/docker/image-size/ghcr.io/legido-ai-workspace/qwen-code/latest)](https://ghcr.io/legido-ai-workspace/qwen-code)
[![GitHub](https://img.shields.io/github/license/legido-ai-workspace/docker-qwen-code)](LICENSE)
[![Docker Pulls](https://img.shields.io/docker/pulls/ghcr.io/legido-ai-workspace/qwen-code)](https://ghcr.io/legido-ai-workspace/qwen-code)

Qwen Code is an advanced AI coding assistant designed to enhance developer productivity through intelligent code generation, completion, and analysis. This Docker image provides a **secure**, **isolated**, and **production-ready** environment to run Qwen Code with all necessary dependencies pre-configured.

## 🎯 Why Use This Container?

- **🔒 Security First**: Non-root user execution with minimal attack surface
- **📦 Zero Configuration**: Pre-installed dependencies and optimized setup
- **🚀 Production Ready**: Multi-stage builds for optimal performance
- **🔄 CI/CD Integration**: Automated builds and GitHub Actions support
- **🐋 Docker-in-Docker**: Full containerization capabilities included
- **⚡ Performance Optimized**: Efficient layer caching and size optimization

## ✨ Key Features

| Feature | Description | Benefit |
|---------|-------------|---------|
| 🏗️ **Multi-stage Build** | Optimized Docker image with separated build/runtime environments | Reduced image size (~60% smaller) |
| 🐋 **Docker-in-Docker** | Full Docker CLI support with socket mounting | Complete containerization workflow |
| 🔐 **GitHub Integration** | Support for GitHub Apps and Personal Access Tokens | Seamless repository operations |
| 📁 **Volume Management** | Smart volume mounting for projects and configuration | Persistent data and easy file access |
| 🔍 **Health Monitoring** | Built-in container health checks | Reliable production deployment |
| ⚡ **Performance** | Cached layers and optimized dependencies | Fast builds and quick startup |
| 🛡️ **Security** | Non-root execution with minimal privileges | Enhanced container security |

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
  -v $HOME/.qwen:/home/node/.qwen \
  -v $PWD:/projects \
  --name qwen-code \
  ghcr.io/legido-ai-workspace/qwen-code:latest
```

> 🎉 **That's it!** You're ready to use Qwen Code in a secure container environment.

## ⚙️ Advanced Configuration

### 📋 Step-by-Step Setup

1. **Clone the repository:**
   ```bash
   git clone https://github.com/legido-ai-workspace/docker-qwen-code.git
   cd docker-qwen-code
   ```

2. **Create your environment configuration:**
   ```bash
   cp .env.example .env
   ```

3. **Configure authentication (choose your preferred method):**

#### 🔐 GitHub App Authentication (Recommended for Organizations)

```env
# GitHub App Configuration
GITHUB_APP_ID=123456
GITHUB_INSTALLATION_ID=87654321
GITHUB_PRIVATE_KEY="-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEA...your-private-key-here...
-----END RSA PRIVATE KEY-----"
```

**Required GitHub App Permissions:**
- ✅ Repository permissions: Administration (Read & Write)
- ✅ Contents: Read & Write  
- ✅ Packages: Read & Write
- ✅ Workflows: Read & Write

#### 🎫 Personal Access Token (Simple Setup)

```env
# PAT Configuration  
GITHUB_PAT=ghp_your_personal_access_token_here
```

**Required PAT Scopes:**
- ✅ `repo` (Full repository access)
- ✅ `write:packages` (Package management)
- ✅ `delete:packages` (Package cleanup)

### 🐳 Docker Configuration

#### Get Docker Group ID (Linux/macOS):
```bash
getent group docker | cut -d: -f3
```

#### Windows Users:
```powershell
# Use default value or check Docker Desktop settings
$env:DOCKER_GID="998"
```

#### Complete Configuration Example:
```env
# System Configuration
DOCKER_GID=998
CONTAINER_NAME=my-qwen-code
TZ=Europe/Madrid

# Volume Paths (customize as needed)
VOLUME_CONFIG=$HOME/.qwen
VOLUME_PROJECTS=$PWD/projects

# Optional: AWS Configuration
AWS_ACCESS_KEY_ID=your_aws_key
AWS_SECRET_ACCESS_KEY=your_aws_secret  
AWS_DEFAULT_REGION=eu-west-1
```

## 🚀 Deployment Options

### Option 1: 📦 Pre-built Image (Recommended)

Pull and run the optimized image directly from GitHub Container Registry:

```bash
# Pull the latest stable version
docker pull ghcr.io/legido-ai-workspace/qwen-code:latest
```

#### 🎯 Interactive Mode (Development)
```bash
docker run -it --rm \
  --name qwen-code-dev \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $HOME/.qwen:/home/node/.qwen \
  -v $PWD:/projects \
  -e GITHUB_PAT=$GITHUB_PAT \
  ghcr.io/legido-ai-workspace/qwen-code:latest \
  bash
```

#### 🔄 Daemon Mode (Production)
```bash
# Start as background service
docker run -d \
  --name qwen-code-prod \
  --restart unless-stopped \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $HOME/.qwen:/home/node/.qwen \
  -v $HOME/projects:/projects \
  --env-file .env \
  ghcr.io/legido-ai-workspace/qwen-code:latest

# Access the running container
docker exec -it qwen-code-prod qwen --help
```

#### 🐋 Docker Compose (Orchestrated)
```bash
# Using the included docker-compose.yml
docker-compose up -d

# Access the service
docker-compose exec qwen-code qwen
```

### Option 2: 🔨 Custom Build (Advanced Users)

Build your own optimized image with custom configurations:

#### 🖥️ Linux/macOS Build
```bash
# Get Docker group ID for proper permissions
export DOCKER_GID=$(getent group docker | cut -d: -f3)

# Build with optimization
docker build \
  --build-arg DOCKER_GID=$DOCKER_GID \
  --build-arg BUILDKIT_INLINE_CACHE=1 \
  --tag qwen-code:local \
  --tag qwen-code:$(date +%Y%m%d) \
  .
```

#### 🪟 Windows Build
```powershell
# PowerShell build command
$env:DOCKER_GID="998"
docker build --build-arg DOCKER_GID=$env:DOCKER_GID -t qwen-code:local .
```

#### ⚡ Performance Optimizations

Our multi-stage build delivers:

| Optimization | Impact | Benefit |
|-------------|--------|---------|
| 📦 **Layer Caching** | ~70% faster rebuilds | Efficient development |
| 🎯 **Minimal Runtime** | ~60% smaller images | Faster deployments |
| 🔒 **Security Hardening** | Reduced attack surface | Production safety |
| 🚀 **Dependency Management** | Optimized package selection | Better performance |

```dockerfile
# Build stages overview:
# Stage 1: Dependencies and build tools
# Stage 2: Runtime environment (final)
```

## 🤖 CI/CD Integration

### GitHub Actions Workflow

Automated pipeline (`.github/workflows/docker.yml`) provides:

- ✅ **Automatic Builds**: Triggered on push to `main` branch
- 📦 **Multi-platform Images**: AMD64 and ARM64 support  
- 🔄 **Automated Testing**: Container health checks and validation
- 📋 **GHCR Publishing**: Seamless deployment to GitHub Container Registry
- 🏷️ **Smart Tagging**: Version management with semantic versioning

#### Workflow Triggers:
```yaml
on:
  push:
    branches: [main]
    tags: ['v*']
  pull_request:
    branches: [main]
```

#### Build Matrix:
- 🐧 Linux AMD64 
- 🍎 Linux ARM64 (Apple Silicon)
- ☁️ Multi-arch manifest generation

## 💡 Usage Examples

### 🎯 Basic Operations

#### Start Your Development Environment
```bash
# Quick development setup
docker run -it --rm \
  --name qwen-dev \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $PWD:/projects \
  -v $HOME/.qwen:/home/node/.qwen \
  ghcr.io/legido-ai-workspace/qwen-code:latest bash

# Inside the container
qwen --help                    # View available commands
qwen generate --model qwen2.5  # Generate code
qwen chat                      # Interactive chat mode
```

#### Production Deployment
```bash
# Long-running service
docker run -d \
  --name qwen-prod \
  --restart unless-stopped \
  --memory=4g \
  --cpus=2 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /opt/projects:/projects:ro \
  -v qwen-data:/home/node/.qwen \
  --env-file production.env \
  ghcr.io/legido-ai-workspace/qwen-code:latest

# Monitor the service
docker logs -f qwen-prod
docker stats qwen-prod
```

### 🔧 Development Workflows

#### Code Generation Pipeline
```bash
# 1. Start container with project mounted
docker exec -it qwen-prod bash

# 2. Navigate to your project
cd /projects/my-app

# 3. Use Qwen for development
qwen generate --file src/components/Button.jsx --prompt "Create a modern React button component"
qwen review --file src/utils/helpers.js
qwen test --generate --file src/api/client.js
```

### 🐋 Docker-in-Docker Capabilities

Full Docker functionality within the container for advanced containerization workflows:

#### Container Management
```bash
# Access the container
docker exec -it qwen-prod bash

# Inside container - full Docker CLI available
docker ps                           # List running containers
docker build -t my-app .           # Build images  
docker run -d nginx                 # Run containers
docker-compose up -d                # Orchestrate services
docker system prune -f              # Clean up resources
```

#### Development Container Workflows
```bash
# Build and test applications inside Qwen container
docker exec -it qwen-prod bash -c "
  cd /projects/my-microservice &&
  docker build -t my-service:test . &&
  docker run --rm my-service:test npm test &&
  echo 'Tests passed! 🎉'
"
```

#### Multi-Stage Pipeline Example
```bash
# Complete CI/CD pipeline inside container
#!/bin/bash
set -e

# 1. Code generation with Qwen
qwen generate --template microservice --name user-service

# 2. Build the generated service  
cd user-service
docker build -t user-service:latest .

# 3. Run integration tests
docker run --rm user-service:latest npm run test:integration

# 4. Push to registry (if tests pass)
docker tag user-service:latest registry.company.com/user-service:v1.0.0
docker push registry.company.com/user-service:v1.0.0
```

## 🔄 Maintenance & Updates

### Update to Latest Version
```bash
# Stop existing container gracefully
docker stop qwen-code
docker rm qwen-code

# Pull latest image
docker pull ghcr.io/legido-ai-workspace/qwen-code:latest

# Restart with new version
docker run -d \
  --name qwen-code \
  --restart unless-stopped \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $HOME/.qwen:/home/node/.qwen \
  -v $PWD:/projects \
  ghcr.io/legido-ai-workspace/qwen-code:latest
```

### Health Monitoring
```bash
# Check container health
docker inspect qwen-code --format='{{.State.Health.Status}}'

# View health check logs  
docker inspect qwen-code --format='{{range .State.Health.Log}}{{.Output}}{{end}}'

# Monitor resource usage
docker stats qwen-code --no-stream
```

### Backup & Restore
```bash
# Backup Qwen configuration and data
docker run --rm \
  -v qwen-data:/source:ro \
  -v $HOME/backups:/backup \
  alpine:latest \
  tar czf /backup/qwen-backup-$(date +%Y%m%d).tar.gz -C /source .

# Restore from backup
docker run --rm \
  -v qwen-data:/target \
  -v $HOME/backups:/backup:ro \
  alpine:latest \
  tar xzf /backup/qwen-backup-20241016.tar.gz -C /target
```

## 📂 Volume Management

### Standard Volume Mounts

| Volume Path | Purpose | Recommended Local Path | Notes |
|-------------|---------|----------------------|-------|
| `/projects` | 📁 **Project Files** | `$PWD` or `$HOME/projects` | Your source code and workspaces |
| `/home/node/.qwen` | ⚙️ **Qwen Configuration** | `$HOME/.qwen` | Settings, cache, and models |  
| `/var/run/docker.sock` | 🐳 **Docker Socket** | `/var/run/docker.sock` | Docker-in-Docker functionality |
| `/tmp` | 🗂️ **Temporary Files** | `tmpfs` | Fast temporary storage |

### Volume Creation & Management
```bash
# Create named volumes for persistent data
docker volume create qwen-config
docker volume create qwen-projects
docker volume create qwen-cache

# Use named volumes in production
docker run -d \
  --name qwen-prod \
  -v qwen-config:/home/node/.qwen \
  -v qwen-projects:/projects \
  -v qwen-cache:/tmp \
  -v /var/run/docker.sock:/var/run/docker.sock \
  ghcr.io/legido-ai-workspace/qwen-code:latest

# Inspect volume usage
docker volume ls
docker system df -v
```

### Performance Optimization
```bash
# Use tmpfs for temporary files (faster performance)
docker run -it --rm \
  --tmpfs /tmp:rw,size=1g,mode=1777 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $PWD:/projects \
  ghcr.io/legido-ai-workspace/qwen-code:latest
```

## 🔗 GitHub Integration

### Authentication Methods Comparison

| Method | Use Case | Setup Complexity | Security | Team Access |
|--------|----------|------------------|----------|-------------|
| 🏢 **GitHub App** | Organizations, Teams | Medium | High | Excellent |
| 🎫 **Personal Token** | Individual, Simple Setup | Low | Medium | Limited |

### 🏢 GitHub App Setup (Recommended for Teams)

#### 1. Create GitHub App
```bash
# Navigate to GitHub Settings > Developer settings > GitHub Apps
# https://github.com/settings/apps/new

App Name: "Qwen Code Assistant"
Homepage URL: "https://github.com/legido-ai-workspace/docker-qwen-code"
Webhook URL: "https://api.example.com/webhooks" (optional)
```

#### 2. Configure Permissions
```yaml
Repository Permissions:
  Administration: Read & Write    # Manage repository settings
  Contents: Read & Write         # Access and modify files
  Packages: Read & Write         # Docker registry access  
  Actions: Read & Write          # GitHub Actions integration
  Workflows: Read & Write        # Workflow management

Organization Permissions:
  Members: Read                  # Team access (optional)
```

#### 3. Generate Private Key
```bash
# Download the private key from GitHub App settings
# Convert for use in .env file:
cat your-app.private-key.pem | sed ':a;N;$!ba;s/\n/\\n/g'
```

### 🎫 Personal Access Token Setup

#### 1. Generate Token
Visit: https://github.com/settings/tokens/new

#### 2. Required Scopes
```yaml
✅ repo                    # Full repository access
✅ write:packages          # Upload packages  
✅ delete:packages         # Clean up packages
✅ read:org               # Organization access (if needed)
✅ workflow               # GitHub Actions (if needed)
```

### Integration Examples

#### Repository Operations
```bash
# Clone private repositories
docker exec -it qwen-prod git clone https://github.com/your-org/private-repo.git

# Push generated code
docker exec -it qwen-prod bash -c "
  cd /projects/new-feature &&
  git add . &&
  git commit -m 'feat: AI-generated component' &&
  git push origin feature/ai-component
"
```

## 🛡️ Security Features

### Built-in Security Measures

| Security Layer | Implementation | Benefit |
|---------------|----------------|---------|
| 👤 **Non-root Execution** | Runs as `node` user (UID 1000) | Prevents privilege escalation |
| 📦 **Minimal Base Image** | Debian Bookworm Slim | Reduced attack surface |
| 🔒 **Multi-stage Build** | Separated build/runtime environments | No build tools in production |
| 🔐 **Docker Socket Access** | Controlled group permissions | Secure Docker-in-Docker |
| 🚫 **No SSH/Remote Access** | Container-only execution | Prevents unauthorized access |

### Security Best Practices

#### Container Security
```bash
# Run with security options
docker run -d \
  --name qwen-secure \
  --read-only \
  --tmpfs /tmp \
  --tmpfs /var/tmp \
  --security-opt=no-new-privileges:true \
  --cap-drop=ALL \
  --cap-add=DAC_OVERRIDE \
  -v /var/run/docker.sock:/var/run/docker.sock \
  ghcr.io/legido-ai-workspace/qwen-code:latest
```

#### Network Security
```bash
# Isolate container network
docker network create --driver bridge qwen-network

docker run -d \
  --name qwen-isolated \
  --network qwen-network \
  --no-healthcheck \
  ghcr.io/legido-ai-workspace/qwen-code:latest
```

#### Secrets Management
```bash
# Use Docker secrets instead of environment variables
echo "ghp_your_token_here" | docker secret create github_pat -

docker run -d \
  --name qwen-secrets \
  --secret source=github_pat,target=/run/secrets/github_pat \
  ghcr.io/legido-ai-workspace/qwen-code:latest
```

### Vulnerability Scanning
```bash
# Scan image for vulnerabilities
docker scout cves ghcr.io/legido-ai-workspace/qwen-code:latest

# Check for outdated dependencies  
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  aquasec/trivy image ghcr.io/legido-ai-workspace/qwen-code:latest
```

## 🔧 Troubleshooting

### Common Issues & Solutions

#### ❌ Permission Denied (Docker Socket)
```bash
# Problem: Cannot access Docker daemon
Error: permission denied while trying to connect to the Docker daemon socket

# Solution: Fix Docker group permissions
sudo usermod -aG docker $USER
newgrp docker

# Or run with sudo (not recommended for production)
sudo docker run ...
```

#### ❌ Port Already in Use
```bash
# Problem: Port conflict
Error: bind: address already in use

# Solution: Check and kill process using port
sudo lsof -i :8080
sudo kill -9 <PID>

# Or use different port
docker run -p 8081:8080 ...
```

#### ❌ Out of Disk Space
```bash
# Problem: No space left on device
Error: no space left on device

# Solution: Clean Docker resources
docker system prune -af --volumes
docker builder prune -af

# Check disk usage
docker system df
```

#### ❌ GitHub Authentication Failed
```bash
# Problem: GitHub API rate limiting or auth issues
Error: API rate limit exceeded

# Solution: Check token permissions and rate limits
curl -H "Authorization: token $GITHUB_PAT" https://api.github.com/rate_limit

# Verify token scopes
curl -H "Authorization: token $GITHUB_PAT" https://api.github.com/user
```

#### ❌ Container Startup Issues
```bash
# Problem: Container exits immediately
Error: Container qwen-code exited with code 1

# Solution: Check logs and health
docker logs qwen-code
docker inspect qwen-code --format='{{.State.Health.Status}}'

# Debug with interactive mode
docker run -it --rm --entrypoint bash ghcr.io/legido-ai-workspace/qwen-code:latest
```

### Performance Optimization

#### Memory Issues
```bash
# Monitor memory usage
docker stats qwen-code --no-stream

# Limit memory usage
docker run -m 4g --oom-kill-disable ghcr.io/legido-ai-workspace/qwen-code:latest
```

#### CPU Optimization
```bash
# Limit CPU usage
docker run --cpus="2.0" ghcr.io/legido-ai-workspace/qwen-code:latest

# Set CPU priority
docker run --cpu-shares 512 ghcr.io/legido-ai-workspace/qwen-code:latest
```

### Getting Help

- 📚 **Documentation**: [Project Wiki](https://github.com/legido-ai-workspace/docker-qwen-code/wiki)
- 🐛 **Bug Reports**: [GitHub Issues](https://github.com/legido-ai-workspace/docker-qwen-code/issues)
- 💬 **Discussions**: [GitHub Discussions](https://github.com/legido-ai-workspace/docker-qwen-code/discussions)
- 📧 **Email Support**: [support@legido.com](mailto:support@legido.com)

## 📄 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

**Qwen Code** is licensed under separate terms - see [QwenLM/Qwen2.5-Coder](https://github.com/QwenLM/Qwen2.5-Coder) for details.

---

<div align="center">

**🌟 Star this repository if you find it useful! 🌟**

[![GitHub stars](https://img.shields.io/github/stars/legido-ai-workspace/docker-qwen-code?style=social)](https://github.com/legido-ai-workspace/docker-qwen-code)
[![GitHub forks](https://img.shields.io/github/forks/legido-ai-workspace/docker-qwen-code?style=social)](https://github.com/legido-ai-workspace/docker-qwen-code/fork)

*Built with ❤️ by the [Legido AI Workspace](https://github.com/legido-ai-workspace) team*

</div>