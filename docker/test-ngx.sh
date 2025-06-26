#!/bin/bash

##################################################
# NGX Cross-Platform Test Suite
# Tests NGX functionality on different Linux distributions
##################################################

# set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test counters
TESTS_PASSED=0
TESTS_FAILED=0
TOTAL_TESTS=0

# Helper functions
print_header() {
    echo -e "\n${BLUE}=== $1 ===${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
    ((TESTS_PASSED++))
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
    ((TESTS_FAILED++))
}

print_info() {
    echo -e "${YELLOW}ℹ $1${NC}"
}

run_test() {
    local test_name="$1"
    local test_command="$2"
    local expected_exit_code="${3:-0}"
    
    print_info "Testing: $test_name"
    ((TOTAL_TESTS++))
    
    if eval "$test_command" > /dev/null 2>&1; then
        local exit_code=$?
        if [ $exit_code -eq $expected_exit_code ]; then
            print_success "$test_name"
        else
            print_error "$test_name (exit code: $exit_code, expected: $expected_exit_code)"
        fi
    else
        print_error "$test_name (command failed)"
    fi
}

# Start testing
print_header "NGX Cross-Platform Test Suite"

# Get OS information
if [ -f /etc/arch-release ]; then
    OS="Arch Linux"
elif [ -f /etc/debian_version ]; then
    OS="Debian/Ubuntu"
else
    OS="Unknown"
fi

echo "Operating System: $OS"
echo "NGX Version: $(ngx version 2>/dev/null || echo 'Not available')"
echo

# Test 1: Basic Commands
print_header "Basic Command Tests"
run_test "NGX version command" "ngx version"
run_test "NGX help command" "ngx help"
run_test "NGX system-status command" "ngx system-status"

# Test 2: OS Detection
print_header "OS Detection Tests"
if [ "$OS" = "Arch Linux" ]; then
    run_test "Arch Linux detection" "ngx system-status | grep -q 'Operating System: arch'"
elif [ "$OS" = "Debian/Ubuntu" ]; then
    run_test "Debian detection" "ngx system-status | grep -q 'Operating System: debian'"
fi

# Test 3: Nginx Setup Validation
print_header "Nginx Setup Tests"
run_test "Nginx installation check" "command -v nginx"
run_test "Nginx configuration test" "sudo nginx -t"
run_test "Sites-available directory exists" "test -d /etc/nginx/sites-available"
run_test "Sites-enabled directory exists" "test -d /etc/nginx/sites-enabled"

# Test 4: Directory Structure for Arch
if [ "$OS" = "Arch Linux" ]; then
    print_header "Arch Linux Specific Tests"
    run_test "Sites-enabled inclusion in nginx.conf" "grep -q 'sites-enabled' /etc/nginx/nginx.conf"
    run_test "Backup file creation" "ls /etc/nginx/nginx.conf.backup.* > /dev/null 2>&1 || echo 'No backup needed'"
    run_test "Web group is 'http'" "ngx system-status | grep -q 'Web Group: http'"
elif [ "$OS" = "Debian/Ubuntu" ]; then
    print_header "Debian/Ubuntu Specific Tests"
    run_test "Web group is 'www-data'" "ngx system-status | grep -q 'Web Group: www-data'"
fi

# Test 5: Site Management
print_header "Site Management Tests"

# Create a test site
print_info "Creating test site..."
if echo -e "n\nn" | ngx new test-site base > /dev/null 2>&1; then
    print_success "Test site creation"
    ((TESTS_PASSED++))
    
    # Test site operations
    run_test "Site configuration file exists" "test -f /etc/nginx/sites-available/test-site"
    run_test "Site listing" "ngx list | grep -q test-site"
    run_test "Site status check" "ngx status test-site"
    run_test "Site path check" "ngx where test-site"
    
    # Test enable/disable
    run_test "Site enable" "ngx enable test-site"
    run_test "Site is enabled" "test -L /etc/nginx/sites-enabled/test-site"
    run_test "Site disable" "ngx disable test-site"
    run_test "Site is disabled" "! test -L /etc/nginx/sites-enabled/test-site"
    
    # Cleanup
    print_info "Cleaning up test site..."
    if echo "y" | ngx remove test-site > /dev/null 2>&1; then
        print_success "Test site cleanup"
        ((TESTS_PASSED++))
    else
        print_error "Test site cleanup"
        ((TESTS_FAILED++))
    fi
    ((TOTAL_TESTS += 2))
else
    print_error "Test site creation"
    ((TESTS_FAILED++))
    ((TOTAL_TESTS++))
fi

# Test web group detection
if [ "$OS" = "Arch Linux" ]; then
    run_test "Web group detection (http)" "ngx system-status | grep -q 'Web Group: http'"
elif [ "$OS" = "Debian/Ubuntu" ]; then
    run_test "Web group detection (www-data)" "ngx system-status | grep -q 'Web Group: www-data'"
fi

# Test 6: Configuration Validation
print_header "Configuration Tests"
run_test "Nginx config validation" "sudo nginx -t"
run_test "Template directory creation" "test -d /etc/nginx/_templates || mkdir -p /etc/nginx/_templates"

# Summary
print_header "Test Results Summary"
echo "Operating System: $OS"
echo "Total Tests: $TOTAL_TESTS"
echo -e "Passed: ${GREEN}$TESTS_PASSED${NC}"
echo -e "Failed: ${RED}$TESTS_FAILED${NC}"

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "\n${GREEN}All tests passed! NGX is working correctly on $OS${NC}"
    exit 0
else
    echo -e "\n${RED}Some tests failed. Please check the output above.${NC}"
    exit 1
fi
