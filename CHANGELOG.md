# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed
- **BREAKING**: Migrated from host Docker socket mounting to full Docker-in-Docker (DinD) architecture
  - Old single-container approach with `-v /var/run/docker.sock` is no longer supported
  - Now uses separate DinD container for complete container isolation
  - Requires Docker Compose setup with two services: `dind` and `copilot-cli`
  - All Docker operations now isolated from host system
- Updated README with new Docker Compose setup instructions
- Updated one-command setup to use `docker-compose up -d`

### Added
- Docker-in-Docker (DinD) support via separate `dind` service in docker-compose.yml
- Docker socket sharing between DinD and Copilot CLI via Unix socket volume
- Health checks for both DinD and Copilot CLI services
- Comprehensive Docker-in-Docker architecture documentation

### Fixed
- Authentication persistence bug caused by running container as root instead of node user
- Auto-approval not working in `docker exec` sessions due to environment variable not persisting
- Container now runs as node user from startup, ensuring proper /home/node volume mount behavior

### Deprecated
- Direct host Docker socket mounting (old approach with `-v /var/run/docker.sock`)
- Single-container setup without DinD support

## [0.1.0] - 2026-01-07

### Added
- Initial release of Docker Copilot CLI
- Dockerfile with Node.js base and GitHub Copilot CLI
- Docker-in-Docker support via docker.sock mount
- Entrypoint script with environment variable processing
- Auto-approval feature via COPILOT_ALLOW_ALL environment variable
- MCP config environment variable expansion
- Docker Compose configuration with health checks

### Fixed
- Permission denied error when creating Copilot package directory
- Fixed /home/node directory ownership for node user
- Improved entrypoint to handle volume-mounted /home/node correctly

### Documentation
- Added comprehensive README with usage instructions
- Added VALIDATION_SUMMARY.md with testing guide
- Added validate.sh automated testing script
- Added step-by-step testing instructions in PR comments

[Unreleased]: https://github.com/legido-ai/docker-copilot-cli/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/legido-ai/docker-copilot-cli/releases/tag/v0.1.0
