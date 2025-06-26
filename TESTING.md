# NGX Cross-Platform Testing Setup

## 🎯 Overview

This Docker testing environment validates that the NGX script works correctly on both supported Linux distributions:

- **Debian/Ubuntu** - Traditional sites-available/enabled structure
- **Arch Linux** - Requires automatic setup of directory structure

## 📁 Files Created

### Docker Images
- `docker/Dockerfile.debian` - Debian/Ubuntu test environment
- `docker/Dockerfile.arch` - Arch Linux test environment

### Orchestration
- `docker/docker-compose.yml` - Comprehensive testing with custom test suite

### Testing Scripts
- `docker/test-ngx.sh` - Comprehensive test suite with detailed validation
- `docker/run-ci-tests.sh` - CI-style automated test runner

### Automation
- `docker/Makefile` - Easy-to-use commands for testing
- `docker/README.md` - Documentation for the testing environment

## 🚀 Quick Start

### Run All Tests
```bash
cd docker
make test
```

### Test Individual Systems
```bash
# Test only Debian/Ubuntu
make test-debian

# Test only Arch Linux  
make test-arch
```

### Interactive Testing
```bash
# Interactive Debian container
make interactive-debian

# Interactive Arch container
make interactive-arch
```

### Comprehensive Testing
```bash
# Run detailed test suite
make test-comprehensive

# Run CI-style tests
./run-ci-tests.sh
```

## 🧪 What Gets Tested

### Core Functionality
- ✅ OS detection accuracy
- ✅ Nginx installation verification
- ✅ Directory structure creation
- ✅ Service management compatibility
- ✅ Configuration file validation

### Arch Linux Specific
- ✅ Automatic sites-available/enabled setup
- ✅ nginx.conf modification and backup
- ✅ systemctl service management
- ✅ http group usage (instead of www-data)

### Site Management
- ✅ Site creation and configuration
- ✅ Enable/disable functionality  
- ✅ Site listing and status
- ✅ Configuration file location
- ✅ Cleanup and removal

### Error Handling
- ✅ Invalid commands
- ✅ Missing dependencies
- ✅ Configuration syntax errors
- ✅ Permission issues

## 🎨 Features

### Automated Testing
- Color-coded test results
- Detailed pass/fail reporting
- Exit code handling for CI integration
- Comprehensive error messages

### Interactive Mode
- Full shell access for manual testing
- Pre-configured environment
- Volume mounting for live script updates

### CI Integration
- Automated test runner script
- Summary reporting
- Clean environment setup/teardown

## 📊 Expected Results

### Debian/Ubuntu
```
Operating System: debian
✅ All directory structures exist
✅ No nginx.conf modifications needed
✅ systemctl service management
✅ All tests should pass
```

### Arch Linux
```
Operating System: arch
✅ Auto-created sites-available/enabled
✅ Modified nginx.conf with backup
✅ systemctl service management
✅ http web group usage
✅ All tests should pass
```

## 🛠️ Troubleshooting

### Common Issues
1. **Docker not running**: Start Docker daemon
2. **Permission errors**: Ensure script is executable
3. **Network issues**: Check internet connectivity for package downloads
4. **Space issues**: Clean up old containers with `make clean`

### Debug Commands
```bash
# Check script syntax
make syntax-check

# View container logs
make logs

# Clean everything
make clean

# Check permissions
make check-permissions
```

## 🔄 Development Workflow

1. **Make changes** to the NGX script
2. **Run syntax check**: `make syntax-check`
3. **Test on specific OS**: `make test-debian` or `make test-arch`
4. **Run full test suite**: `make test-comprehensive`
5. **Clean up**: `make clean`

This testing setup ensures that NGX works reliably across different Linux distributions and provides confidence when deploying to production environments.
