# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Fixed
- Authentication persistence bug caused by running container as root instead of node user
- Auto-approval not working in `docker exec` sessions due to environment variable not persisting
- Container now runs as node user from startup, ensuring proper /home/node volume mount behavior

### Added
- Comprehensive authentication persistence documentation in docs/AUTHENTICATION.md
- Auto-approval environment variable now persists across docker exec sessions via ~/.copilot_env
- Documentation clarifying COPILOT_AUTO_APPROVE vs COPILOT_ALLOW_ALL usage

### Changed
- Reverted Dockerfile to run as node user (USER node) instead of root with runuser
- Auto-approval configuration now persists to /home/node/.copilot_env and ~/.bashrc
- Improved entrypoint logging for auto-approval status

## [0.1.0] - 2026-01-07

### Added
- Initial release of Docker Copilot CLI
- Dockerfile with Node.js base and GitHub Copilot CLI
- Docker-in-Docker support via docker.sock mount
- Entrypoint script with environment variable processing
- Auto-approval feature via COPILOT_AUTO_APPROVE environment variable
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
