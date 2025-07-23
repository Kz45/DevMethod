#!/bin/bash

# Claude Code MCP Bridge Startup Script (Generic Version)
# Connects Claude Code (WSL) with Claude Desktop MCPs (Windows)

set -e

echo "🌉 Starting Claude Code MCP Bridge"
echo "=================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Auto-detect username
detect_username() {
    if [ -n "$USER" ]; then
        echo "$USER"
    elif [ -n "$USERNAME" ]; then
        echo "$USERNAME"
    else
        echo "user"
    fi
}

USERNAME=$(detect_username)
log_info "Detected username: $USERNAME"

# Check prerequisites
check_requirements() {
    log_info "Checking requirements..."
    
    # Check Node.js
    if ! command -v node >/dev/null 2>&1; then
        log_error "Node.js not found. Please install Node.js first."
        exit 1
    fi
    
    local node_version=$(node --version)
    log_success "Node.js found: $node_version"
    
    # Check npm
    if ! command -v npm >/dev/null 2>&1; then
        log_error "npm not found. Please install npm first."
        exit 1
    fi
    
    local npm_version=$(npm --version)
    log_success "npm found: v$npm_version"
    
    # Check if Claude Desktop config exists (try multiple locations)
    local config_paths=(
        "/mnt/c/Users/$USERNAME/AppData/Roaming/Claude/claude_desktop_config.json"
        "$HOME/AppData/Roaming/Claude/claude_desktop_config.json"
        "$HOME/Library/Application Support/Claude/claude_desktop_config.json"
        "$HOME/.config/claude/claude_desktop_config.json"
        "$HOME/.claude/claude_desktop_config.json"
    )
    
    local config_found=false
    for config_path in "${config_paths[@]}"; do
        if [ -f "$config_path" ]; then
            log_success "Claude Desktop configuration found at: $config_path"
            config_found=true
            break
        fi
    done
    
    if [ "$config_found" = false ]; then
        log_error "Claude Desktop configuration not found"
        log_info "Searched in the following locations:"
        for config_path in "${config_paths[@]}"; do
            log_info "  - $config_path"
        done
        log_info "Please make sure Claude Desktop is installed and configured with MCPs"
        exit 1
    fi
}

# Install dependencies
install_dependencies() {
    log_info "Installing MCP dependencies..."
    
    # Install common MCP servers that might be needed
    local packages=(
        "@modelcontextprotocol/server-filesystem"
        "@modelcontextprotocol/server-github"
        "@modelcontextprotocol/server-sequential-thinking"
        "@playwright/mcp"
        "n8n-mcp"
    )
    
    for package in "${packages[@]}"; do
        log_info "Installing $package..."
        if npm install -g "$package" 2>/dev/null; then
            log_success "✅ $package installed"
        else
            log_warning "⚠️  Failed to install $package (may not be needed)"
        fi
    done
}

# Start the bridge
start_bridge() {
    log_info "Starting MCP Bridge..."
    
    local bridge_dir="$(dirname "$0")"
    local bridge_script="$bridge_dir/claude-code-bridge-generic.js"
    
    # Fallback to original bridge if generic doesn't exist
    if [ ! -f "$bridge_script" ]; then
        bridge_script="$bridge_dir/claude-code-bridge.js"
    fi
    
    if [ ! -f "$bridge_script" ]; then
        log_error "Bridge script not found: $bridge_script"
        exit 1
    fi
    
    # Make sure it's executable
    chmod +x "$bridge_script"
    
    log_info "Launching Claude Code MCP Bridge..."
    log_info "Press Ctrl+C to stop the bridge"
    echo ""
    
    # Start the bridge with error handling
    node "$bridge_script" || {
        log_error "Bridge failed to start"
        exit 1
    }
}

# Trap for clean shutdown
cleanup() {
    echo ""
    log_info "Shutting down MCP Bridge..."
    exit 0
}

trap cleanup SIGINT SIGTERM

# Main execution
main() {
    echo "Claude Code to Claude Desktop MCP Bridge (Generic Version)"
    echo "========================================================="
    echo "This bridge allows Claude Code running in WSL to access"
    echo "MCPs configured in Claude Desktop on Windows host."
    echo ""
    echo "Detected username: $USERNAME"
    echo ""
    
    check_requirements
    
    # Ask if user wants to install dependencies
    echo ""
    read -p "Install/update MCP dependencies? (y/N): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        install_dependencies
    fi
    
    echo ""
    start_bridge
}

# Run main function
main "$@"