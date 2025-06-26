# NGX Docker Testing Makefile

.PHONY: help test test-debian test-arch clean build interactive-debian interactive-arch logs

# Default target
help:
	@echo "NGX Docker Testing Commands:"
	@echo ""
	@echo "  make test           - Run tests on both Debian and Arch Linux"
	@echo "  make test-debian    - Run tests on Debian only"
	@echo "  make test-arch      - Run tests on Arch Linux only"
	@echo "  make build          - Build all Docker images"
	@echo "  make interactive-debian - Start interactive Debian container"
	@echo "  make interactive-arch   - Start interactive Arch container"
	@echo "  make logs           - Show logs from test containers"
	@echo "  make clean          - Remove all containers and images"
	@echo ""

# Run tests on both systems
test:
	@echo "Running NGX tests on all supported systems..."
	docker compose up --build --abort-on-container-exit
	@echo "✓ Tests completed!"

# Test individual systems
test-debian:
	@echo "Running NGX tests on Debian/Ubuntu..."
	docker compose up --build ngx-debian
	@echo "✓ Debian tests completed!"

test-arch:
	@echo "Running NGX tests on Arch Linux..."
	docker compose up --build ngx-arch
	@echo "✓ Arch tests completed!"

# Build images
build:
	@echo "Building Docker images..."
	docker compose build
	@echo "✓ Build completed!"

# Interactive containers
interactive-debian:
	@echo "Starting interactive Debian container..."
	@echo "Run 'exit' to stop the container"
	docker compose --profile interactive run --rm ngx-interactive-debian

interactive-arch:
	@echo "Starting interactive Arch container..."
	@echo "Run 'exit' to stop the container"
	docker compose --profile interactive run --rm ngx-interactive-arch

# Show logs
logs:
	docker compose logs

# Clean up
clean:
	@echo "Cleaning up containers and images..."
	docker compose down --rmi all --volumes --remove-orphans
	docker compose --profile interactive down --rmi all --volumes --remove-orphans
	@echo "✓ Cleanup completed!"

# Debug: Check if script has correct permissions
check-permissions:
	@echo "Checking script permissions..."
	@ls -la ../bin/ngx

# Quick syntax check
syntax-check:
	@echo "Checking script syntax..."
	@bash -n ../bin/ngx && echo "✓ Syntax check passed!" || echo "✗ Syntax errors found!"
