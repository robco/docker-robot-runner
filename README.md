[!["Buy Me A Coffee"](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://www.buymeacoffee.com/robco)
# Robot Framework Multi-Platform Docker Image

[![Docker Pulls](https://img.shields.io/docker/pulls/malovec/robot-runner)](https://hub.docker.com/r/malovec/robot-runner)
[![Multi-Platform Support](https://img.shields.io/badge/platform-x64%20%7C%20ARM%20%7C%20Apple%20Silicon-blue)](https://hub.docker.com/r/malovec/docker-robot-runner)
[![Python Version](https://img.shields.io/badge/python-3.12-blue)](https://www.python.org/)
[![Robot Framework](https://img.shields.io/badge/Robot%20Framework-7.x-red)](https://robotframework.org/)

A hardened, multi-platform Docker image for running Robot Framework test automation across x64 and ARM architectures (including Apple Silicon). This image provides a secure, portable environment for test execution with built-in support for performance testing tools.

## 🌟 Features

- **Multi-Architecture Support**: Runs seamlessly on x64, ARM, and Apple Silicon
- **Hardened Security**: Built on Docker's official hardened Python base image
- **Pre-installed Tools**:
  - Robot Framework 7.x
  - Modern Python 3.12 environment
  - Alpine Linux-based for minimal footprint
- **Flexible Execution**: Run Robot tests or any custom command
- **Optimized Dependencies**: Pre-cached package installation for faster builds

## 🚀 Quick Start

### Basic Robot Framework Execution

```bash
docker run --rm -v $(pwd):/robot malovec/robot-runner:latest tests/suite.robot
```

### Interactive Shell Access

```bash
docker run --rm -ti -e CMD=bash malovec/robot-runner:latest
```

## 📦 Image Contents

### Pre-installed Packages

**Python Libraries:**
- Robot Framework 7.x
- Browser and SeleniumLibrary for web testing
- Appium Library for mobile testing
- Requests library for API testing
- All major Robot Framework ecosystem packages

**System Tools:**
- Node.js/npm packages for modern web testing
- Alpine Linux system dependencies

## 🛠️ Usage Examples

### 1. Run Robot Tests with Output Directory

```bash
docker run --rm                             \
  -v $(pwd):/robot                          \
  malovec/robot-runner:latest               \
  --outputdir results tests/
```

### 2. Run Specific Robot Suite with Variables

```bash
docker run --rm                                                   \
  -v $(pwd):/robot                                                \
  malovec/robot-runner:latest                                     \
  --variable BROWSER:chrome                                       \
  --suite smoke_tests tests/suite.robot
```

### 3. Run Custom Python Scripts

```bash
docker run --rm                                                  \
  -v $(pwd):/robot                                               \
  -e CMD=python                                                  \
  malovec/robot-runner:latest                                    \
  my_script.py
```

## 🔧 Advanced Configuration

### Volume Mounts for Data Persistence

```bash
# Mount current directory and specific output directory
docker run --rm                                                  \
  -v $(pwd)/tests:/robot/tests                                   \
  -v $(pwd)/results:/robot/results                               \
  malovec/robot-runner:latest                                    \
  --outputdir /robot/results /robot/tests
```

### Environment Variable Configuration

```bash
docker run --rm                                                  \
  -v $(pwd):/robot                                               \
  -e PYTHONPATH=/robot/lib                                       \
  -e ROBOT_OPTIONS="--loglevel DEBUG"                            \
  malovec/robot-runner:latest
```

### Docker Compose Integration

```yaml
version: '3.8'
services:
  robot-tests:
    image: malovec/robot-runner:latest
    volumes:
      - ./tests:/robot/tests
      - ./results:/robot/results
    command: --outputdir /robot/results /robot/tests/smoke.robot
```

## 🏗️ Building from Source

### Build for Multiple Architectures

```bash
# Build for both x64 and ARM
docker buildx build --platform linux/amd64,linux/arm64           \
  -t malovec/robot-runner:latest                                 \
  --push .
```

### Custom Python Version

```bash
# Build with specific Python version
docker build --build-arg DHI_PYTHON_BUILD_TAG=3.11-alpine3.22-dev \
  -t my-robot-runner:custom .
```

## 🔒 Security Features

- Built on Docker's hardened Python base image
- Non-root user execution support
- Minimal Alpine Linux base for reduced attack surface
- Regular security updates from upstream bases
- Python bytecode writing disabled (`PYTHONDONTWRITEBYTECODE=1`)

## 📋 Requirements File Structure

The image uses a structured approach for dependencies:

```
requirements/
├── apk.in      # Alpine Linux packages
├── npm.in      # Node.js packages  
└── python.in   # Python packages
```

## 📄 License

This project is open source. Please check the respective licenses for included tools:
- Robot Framework: Apache License 2.0
- Python: Python Software Foundation License

## 🔗 Links

- **Docker Hub**: [malovec/robot-runner](https://hub.docker.com/r/malovec/robot-runner)
- **Robot Framework**: [robotframework.org](https://robotframework.org/)

---
*Built with ❤️ for the Robot Framework community*
