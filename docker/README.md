# NGX Docker Testing

This directory contains Docker configurations for testing the NGX script on different Linux distributions.

## Supported Systems

- **Debian/Ubuntu** - Uses `debian:bookworm-slim` base image
- **Arch Linux** - Uses `archlinux:latest` base image

## Quick Test

Run automated tests on both systems:

```bash
cd docker
docker-compose up --build
```

## Interactive Testing

For manual testing and debugging:

### Debian/Ubuntu
```bash
cd docker
docker-compose --profile interactive up -d ngx-interactive-debian
docker exec -it ngx-interactive-debian /bin/bash
```

### Arch Linux
```bash
cd docker
docker-compose --profile interactive up -d ngx-interactive-arch
docker exec -it ngx-interactive-arch /bin/bash
```

## Test Commands

Once inside a container, you can test various NGX commands:

```bash
# Check system status
ngx system-status

# List sites
ngx list

# Create a test site
ngx new test-site base

# Enable the site
ngx enable test-site

# View configuration
ngx where test-site

# Remove test site
ngx remove test-site y
```

## What Gets Tested

1. **OS Detection** - Verifies the script correctly identifies the operating system
2. **Nginx Installation** - Confirms nginx is available and working
3. **Directory Structure** - Tests sites-available/sites-enabled setup (especially important for Arch)
4. **Basic Commands** - Validates core functionality works on both systems
5. **Service Management** - Tests systemctl vs service command detection

## Cleanup

Remove all test containers and images:

```bash
cd docker
docker-compose down --rmi all --volumes
```

## Expected Behavior

### Debian/Ubuntu
- Should work immediately with existing directory structure
- Uses `systemctl` for service management
- No modifications to nginx.conf needed

### Arch Linux
- Should automatically create sites-available/sites-enabled directories
- Modifies nginx.conf to include sites-enabled
- Creates backup of original nginx.conf
- Uses `systemctl` for service management
- Uses `http` group instead of `www-data`

## Troubleshooting

If tests fail, check:

1. Docker daemon is running
2. Sufficient disk space for images
3. Network connectivity for package downloads
4. Script permissions are correct

## Files

- `Dockerfile.debian` - Debian/Ubuntu test environment
- `Dockerfile.arch` - Arch Linux test environment  
- `docker-compose.yml` - Orchestration for both environments
- `README.md` - This documentation
