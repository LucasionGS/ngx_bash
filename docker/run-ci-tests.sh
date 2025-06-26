#!/bin/bash

##################################################
# NGX CI Test Runner
# Automated testing for continuous integration
##################################################

set -e

echo "Starting NGX Cross-Platform CI Tests"
echo "========================================="

# Check prerequisites
echo "Checking prerequisites..."
if ! command -v docker &> /dev/null; then
    echo "✗ Docker is not installed"
    exit 1
fi

echo "✓ Prerequisites check passed"

# Change to docker directory
cd "$(dirname "$0")"

# Run syntax check first
echo "Running syntax check..."
if bash -n ../bin/ngx; then
    echo "✓ Syntax check passed"
else
    echo "✗ Syntax check failed"
    exit 1
fi

# Test on Debian
echo "Testing on Debian/Ubuntu..."
if docker compose -f docker-compose.yml up --build --abort-on-container-exit ngx-debian; then
    echo "✓ Debian tests passed"
    DEBIAN_SUCCESS=true
else
    echo "✗ Debian tests failed"
    DEBIAN_SUCCESS=false
fi

# Test on Arch
echo "Testing on Arch Linux..."
if docker compose -f docker-compose.yml up --build --abort-on-container-exit ngx-arch; then
    echo "✓ Arch tests passed"
    ARCH_SUCCESS=true
else
    echo "✗ Arch tests failed"
    ARCH_SUCCESS=false
fi

# Cleanup
echo "Cleaning up..."
docker compose -f docker-compose.yml down --rmi all --volumes > /dev/null 2>&1 || true

# Summary
echo ""
echo "Test Summary"
echo "==============="
echo "Debian/Ubuntu: $([ "$DEBIAN_SUCCESS" = true ] && echo "✓ PASSED" || echo "✗ FAILED")"
echo "Arch Linux:    $([ "$ARCH_SUCCESS" = true ] && echo "✓ PASSED" || echo "✗ FAILED")"

if [ "$DEBIAN_SUCCESS" = true ] && [ "$ARCH_SUCCESS" = true ]; then
    echo ""
    echo "All tests passed! NGX is ready for both supported platforms."
    exit 0
else
    echo ""
    echo "Some tests failed. Please check the output above."
    exit 1
fi
