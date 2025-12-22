[!["Buy Me A Coffee"](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://www.buymeacoffee.com/robco)
# Robot Framework Docker Runner

A multi-platform Docker image for running Robot Framework tests seamlessly across **x64** and **Apple Silicon/ARM** architectures. Built on Alpine Linux for minimal footprint and maximum performance.

## Features ✨

- **Multi-Architecture Support**: Pre-built images for both `linux/amd64` and `linux/arm64`
- **Batteries Included**: Pre-installed with Robot Framework, browser automation tools, and testing utilities
- **Lightweight**: Based on Alpine Linux for fast downloads and minimal resource usage
- **Production Ready**: Industry-standard security practices and optimized layers
- **Flexible**: Easy to extend with your own test suites and dependencies

## What's Included 🧰

### Core Components
- **Robot Framework** - Test automation framework
- **Python 3.12** - Modern Python version with full Robot Framework ecosystem
- **JMeter 5.6.3** - Performance testing integration
- **Node.js/NPM** - JavaScript testing capabilities

### Pre-installed Dependencies
- Browser automation libraries
- API testing tools
- Database connectors
- XML/JSON processing utilities
- And much more!

## Quick Start 🏃‍♂️

### Run Basic Tests
```bash
docker run --rm -v $(pwd)/tests:/tests malovec/robot-runner:latest -d results /tests/test.robot
```

### Use as Base Image
```dockerfile
FROM malovec/robot-runner:latest

COPY your-tests /robot/tests
COPY requirements /robot/requirements

# Add additional dependencies if needed
RUN pip install -r /robot/requirements/python.in
```

### Custom Command Execution
```bash
# Run specific Robot Framework command
docker run --rm -v $(pwd):/robot malovec/robot-runner:latest -v VARIABLE:value your_test.robot

# Execute custom commands
docker run --rm malovec/robot-runner:latest CMD="python -c \"print('Hello from Robot!')\""
```

## Advanced Usage 🛠️

### Multi-stage Build Integration
```dockerfile
# Development stage
FROM malovec/robot-runner:latest as dev
RUN pip install additional-dev-packages

# Production stage  
FROM malovec/robot-runner:latest
COPY --from=dev /opt/venv /opt/venv
```

### CI/CD Pipeline Integration
The image works seamlessly with GitHub Actions, GitLab CI, Jenkins, and other CI/CD platforms. See our [GitHub Actions workflow](#github-actions) example below.

## Architecture Support 🖥️

This image supports both modern architectures:
- **linux/amd64**: Traditional 64-bit Intel/AMD processors
- **linux/arm64**: Apple Silicon (M1/M2/M3) and ARM64 servers

## Image Tags 🏷️

| Tag | Description | Python Version | Alpine Version |
|-----|-------------|----------------|----------------|
| `latest` | Latest stable release | 3.12 | 3.22 |
| `3.0` | Version 3.0 series | 3.12 | 3.22 |

## Environment Variables 🔧

| Variable | Default | Description |
|----------|---------|-------------|
| `CMD` | `robot` | Override default command execution |
| `VENV_PATH` | `/opt/venv` | Python virtual environment path |
| `JMETER_HOME` | `/opt/jmeter` | JMeter installation directory |
| `PYTHONUNBUFFERED` | `1` | Unbuffered Python output |

## GitHub Actions 🤖

This repository includes a ready-to-use GitHub Actions workflow for building and testing multi-architecture images:

```yaml
# See publish.yml for complete workflow
- name: Build multi-arch image
  uses: docker/build-push-action@v6
  with:
    platforms: linux/amd64,linux/arm64
    tags: malovec/robot-runner:latest,malovec/robot-runner:3.0
```

---
*Built with ❤️ for the Robot Framework community*
