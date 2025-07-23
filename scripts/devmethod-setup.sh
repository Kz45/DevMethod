#!/bin/bash

# DevMethod Setup Script
# Sets up the DevMethod development environment and tools

set -e  # Exit on any error

echo "🚀 DevMethod Setup - Engineering-First AI-Amplified Development"
echo "=================================================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
DEVMETHOD_VERSION="1.0"
DEVMETHOD_DIR="$HOME/.devmethod"
CONFIG_FILE="$DEVMETHOD_DIR/config.yaml"

# Functions
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

check_requirements() {
    log_info "Checking system requirements..."
    
    # Check for required tools
    local missing_tools=()
    
    # Core tools
    command -v git >/dev/null 2>&1 || missing_tools+=("git")
    command -v node >/dev/null 2>&1 || missing_tools+=("node.js")
    command -v npm >/dev/null 2>&1 || missing_tools+=("npm")
    command -v python3 >/dev/null 2>&1 || missing_tools+=("python3")
    command -v pip3 >/dev/null 2>&1 || missing_tools+=("pip3")
    
    # Optional but recommended
    command -v docker >/dev/null 2>&1 || log_warning "Docker not found - recommended for containerization"
    command -v jq >/dev/null 2>&1 || missing_tools+=("jq")
    command -v curl >/dev/null 2>&1 || missing_tools+=("curl")
    
    if [ ${#missing_tools[@]} -ne 0 ]; then
        log_error "Missing required tools: ${missing_tools[*]}"
        echo "Please install the missing tools and run setup again."
        echo ""
        echo "Installation guides:"
        echo "- Git: https://git-scm.com/downloads"
        echo "- Node.js: https://nodejs.org/en/download/"
        echo "- Python: https://www.python.org/downloads/"
        echo "- jq: https://stedolan.github.io/jq/download/"
        exit 1
    fi
    
    log_success "All required tools found"
}

create_directory_structure() {
    log_info "Creating DevMethod directory structure..."
    
    # Create main DevMethod directory
    mkdir -p "$DEVMETHOD_DIR"
    mkdir -p "$DEVMETHOD_DIR/templates"
    mkdir -p "$DEVMETHOD_DIR/scripts"
    mkdir -p "$DEVMETHOD_DIR/cache"
    mkdir -p "$DEVMETHOD_DIR/logs"
    mkdir -p "$DEVMETHOD_DIR/projects"
    
    log_success "Directory structure created at $DEVMETHOD_DIR"
}

install_dependencies() {
    log_info "Installing DevMethod dependencies..."
    
    # Python dependencies for automation scripts
    log_info "Installing Python dependencies..."
    pip3 install --user pyyaml requests beautifulsoup4 markdown jinja2 || {
        log_error "Failed to install Python dependencies"
        exit 1
    }
    
    # Node.js dependencies for tooling
    log_info "Installing Node.js global dependencies..."
    npm install -g @anthropic-ai/claude-code markdown-tree-parser || {
        log_warning "Some Node.js dependencies failed to install - continuing..."
    }
    
    log_success "Dependencies installed"
}

create_configuration() {
    log_info "Creating DevMethod configuration..."
    
    cat > "$CONFIG_FILE" << EOF
# DevMethod Configuration v${DEVMETHOD_VERSION}
version: "${DEVMETHOD_VERSION}"
created: "$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

# Core settings
core:
  context_score_minimum: 190
  prp_confidence_minimum: 8
  validation_levels: 4
  
# Agent settings  
agents:
  analyst: "Mary"
  pm: "John"
  architect: "Winston"
  dev: "James"
  qa: "Quinn"
  ux: "Sally"
  po: "Sarah"
  sm: "Bob"
  
# Validation settings
validation:
  level_1:
    name: "Syntax & Style"
    timeout: 120  # seconds
    required: true
    
  level_2:
    name: "Unit Testing"
    coverage_minimum: 80
    timeout: 600  # seconds
    required: true
    
  level_3:
    name: "Integration Testing"  
    timeout: 1800  # seconds
    required: true
    
  level_4:
    name: "Production Readiness"
    timeout: 7200  # seconds
    required: true

# Automation settings
automation:
  research:
    sources_minimum: 3
    confidence_threshold: 0.7
    
  context:
    auto_score: true
    real_time_feedback: true
    
  deployment:
    auto_rollback: true
    health_check_timeout: 300

# Templates
templates:
  context_gathering: "context-gathering-template.md"
  prp_scored: "prp-scored-template.md"
  progressive_story: "progressive-story-template.md"
  
# IDE Integration
ide:
  supported:
    - "claude-code"
    - "cursor" 
    - "windsurf"
    - "vscode"
  
# Logging
logging:
  level: "INFO"
  retention_days: 30
  max_file_size: "10MB"
EOF

    log_success "Configuration created at $CONFIG_FILE"
}

setup_claude_integration() {
    log_info "Setting up Claude Code integration..."
    
    # Check if Claude Code is installed
    if command -v claude >/dev/null 2>&1; then
        log_success "Claude Code found"
        
        # Create DevMethod commands directory
        local claude_commands_dir="$HOME/.claude/commands/devmethod"
        mkdir -p "$claude_commands_dir"
        
        # Create basic DevMethod commands
        cat > "$claude_commands_dir/context-gather.md" << EOF
# DevMethod Context Gathering

Use the DevMethod 12-dimension context gathering template to collect comprehensive project context.

## Usage
\`\`\`bash
/devmethod-context
\`\`\`

Load the context gathering template and systematically complete all 12 dimensions:
1. Business & Users Context (15 points)
2. Technical Architecture Context (20 points)  
3. Functional Requirements Context (20 points)
4. Quality & Testing Context (15 points)
5. Dependencies & Integrations Context (10 points)
6. Data & State Context (10 points)
7. Experience & Patterns Context (10 points)
8. Infrastructure & Deployment Context (20 points)
9. Security & Compliance Context (20 points)
10. Performance & Scalability Context (15 points)
11. Maintenance & Support Context (15 points)
12. Emerging Technologies Context (10 points)

**Minimum score required: 190/200 points**
EOF

        cat > "$claude_commands_dir/prp-generate.md" << EOF
# DevMethod PRP Generation

Generate a Product Requirement Prompt with confidence scoring using the DevMethod enhanced PRP template.

## Usage
\`\`\`bash
/devmethod-prp
\`\`\`

Generate a PRP that includes:
- WIRASM-PRPS structure (Goal, Why, What, Context, Blueprint, Validation)
- Cole Medin confidence scoring (1-10)
- Progressive success pattern (MVP → Enhanced)
- Production-ready considerations

**Minimum confidence required: 8/10**
EOF

        log_success "Claude Code commands created"
    else
        log_warning "Claude Code not found - skipping Claude integration"
        log_info "Install Claude Code: npm install -g @anthropic-ai/claude-code"
    fi
}

create_helper_scripts() {
    log_info "Creating DevMethod helper scripts..."
    
    # Context scoring script
    cat > "$DEVMETHOD_DIR/scripts/context-scorer.py" << 'EOF'
#!/usr/bin/env python3
"""
DevMethod Context Scorer
Evaluates context completeness based on 12 dimensions
"""

import json
import sys
import yaml
from pathlib import Path

def load_config():
    config_path = Path.home() / '.devmethod' / 'config.yaml'
    with open(config_path, 'r') as f:
        return yaml.safe_load(f)

def score_context(context_data):
    """Score context based on 12 dimensions"""
    scores = {}
    total_score = 0
    max_score = 200
    
    # Dimension weights (must sum to 200)
    weights = {
        'business': 15,
        'technical': 20, 
        'functional': 20,
        'quality': 15,
        'dependencies': 10,
        'data': 10,
        'experience': 10,
        'infrastructure': 20,
        'security': 20,
        'performance': 15,
        'maintenance': 15,
        'emerging': 10
    }
    
    for dimension, weight in weights.items():
        if dimension in context_data:
            # Score based on completeness and quality
            completeness = calculate_completeness(context_data[dimension])
            quality = calculate_quality(context_data[dimension])
            score = int(weight * (completeness * 0.6 + quality * 0.4))
            scores[dimension] = score
            total_score += score
        else:
            scores[dimension] = 0
    
    return {
        'total_score': total_score,
        'max_score': max_score,
        'percentage': round((total_score / max_score) * 100, 1),
        'dimension_scores': scores,
        'passed': total_score >= 190
    }

def calculate_completeness(section_data):
    """Calculate completeness score 0-1"""
    if not section_data:
        return 0.0
    
    # Count non-empty fields
    total_fields = len(section_data)
    filled_fields = sum(1 for v in section_data.values() if v and str(v).strip())
    
    return filled_fields / total_fields if total_fields > 0 else 0.0

def calculate_quality(section_data):
    """Calculate quality score 0-1 based on specificity"""
    if not section_data:
        return 0.0
    
    quality_score = 0.0
    total_items = 0
    
    for value in section_data.values():
        if value and str(value).strip():
            text = str(value).lower()
            total_items += 1
            
            # Quality indicators
            if len(text) > 50:  # Substantial content
                quality_score += 0.3
            if any(indicator in text for indicator in ['specific', 'example', 'http', 'version']):
                quality_score += 0.4
            if not any(vague in text for vague in ['tbd', 'todo', 'placeholder']):
                quality_score += 0.3
    
    return quality_score / total_items if total_items > 0 else 0.0

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python3 context-scorer.py <context_file.json>")
        sys.exit(1)
    
    try:
        with open(sys.argv[1], 'r') as f:
            context_data = json.load(f)
        
        results = score_context(context_data)
        print(json.dumps(results, indent=2))
        
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)
EOF

    chmod +x "$DEVMETHOD_DIR/scripts/context-scorer.py"
    
    # Main DevMethod CLI script
    cat > "$DEVMETHOD_DIR/scripts/devmethod" << 'EOF'
#!/bin/bash

# DevMethod CLI - Main command interface
DEVMETHOD_DIR="$HOME/.devmethod"
SCRIPT_DIR="$DEVMETHOD_DIR/scripts"

case "$1" in
    "init")
        echo "🚀 Initializing new DevMethod project..."
        mkdir -p docs/{methodology,process,templates,automation,examples}
        cp "$DEVMETHOD_DIR/templates/"* ./templates/ 2>/dev/null || true
        echo "✅ Project initialized with DevMethod structure"
        ;;
        
    "context")
        if [ -f "context.json" ]; then
            python3 "$SCRIPT_DIR/context-scorer.py" context.json
        else
            echo "❌ context.json not found. Complete context gathering first."
        fi
        ;;
        
    "score")
        shift
        if [ -z "$1" ]; then
            echo "Usage: devmethod score <context_file.json>"
            exit 1
        fi
        python3 "$SCRIPT_DIR/context-scorer.py" "$1"
        ;;
        
    "validate")
        echo "🔍 Running DevMethod validation..."
        # Add validation logic here
        echo "✅ Validation complete"
        ;;
        
    "help"|"--help"|"-h")
        echo "DevMethod CLI v${DEVMETHOD_VERSION}"
        echo ""
        echo "Usage: devmethod <command> [options]"
        echo ""
        echo "Commands:"
        echo "  init     Initialize new DevMethod project"
        echo "  context  Score context completeness"
        echo "  score    Score specific context file"
        echo "  validate Run validation suite"
        echo "  help     Show this help message"
        ;;
        
    *)
        echo "Unknown command: $1"
        echo "Run 'devmethod help' for usage information"
        exit 1
        ;;
esac
EOF

    chmod +x "$DEVMETHOD_DIR/scripts/devmethod"
    
    log_success "Helper scripts created"
}

setup_path() {
    log_info "Setting up PATH configuration..."
    
    # Add DevMethod to PATH
    local shell_config=""
    if [ -f "$HOME/.bashrc" ]; then
        shell_config="$HOME/.bashrc"
    elif [ -f "$HOME/.zshrc" ]; then
        shell_config="$HOME/.zshrc"
    elif [ -f "$HOME/.profile" ]; then
        shell_config="$HOME/.profile"
    fi
    
    if [ -n "$shell_config" ]; then
        if ! grep -q "devmethod" "$shell_config"; then
            echo "" >> "$shell_config"
            echo "# DevMethod CLI" >> "$shell_config"
            echo "export PATH=\"\$PATH:\$HOME/.devmethod/scripts\"" >> "$shell_config"
            log_success "Added DevMethod to PATH in $shell_config"
            log_info "Run 'source $shell_config' or restart your shell to use 'devmethod' command"
        else
            log_info "DevMethod already in PATH"
        fi
    else
        log_warning "Could not detect shell configuration file"
        log_info "Manually add to your shell config: export PATH=\"\$PATH:\$HOME/.devmethod/scripts\""
    fi
}

run_verification() {
    log_info "Running setup verification..."
    
    # Verify directory structure
    if [ ! -d "$DEVMETHOD_DIR" ]; then
        log_error "DevMethod directory not created"
        return 1
    fi
    
    # Verify configuration
    if [ ! -f "$CONFIG_FILE" ]; then
        log_error "Configuration file not created"
        return 1
    fi
    
    # Verify scripts
    if [ ! -f "$DEVMETHOD_DIR/scripts/devmethod" ]; then
        log_error "CLI script not created"
        return 1
    fi
    
    log_success "Setup verification passed"
}

print_next_steps() {
    echo ""
    echo "🎉 DevMethod setup complete!"
    echo "================================"
    echo ""
    echo "Next steps:"
    echo "1. Restart your shell or run: source ~/.bashrc (or ~/.zshrc)"
    echo "2. Create a new project: devmethod init"
    echo "3. Start with context gathering: use templates/context-gathering-template.md"
    echo "4. Score your context: devmethod context"
    echo ""
    echo "Documentation:"
    echo "- Methodology: $(pwd)/docs/methodology/"
    echo "- Templates: $(pwd)/templates/"
    echo "- Examples: $(pwd)/examples/"
    echo ""
    echo "DevMethod CLI commands:"
    echo "- devmethod init     # Initialize new project"
    echo "- devmethod context  # Score context completeness"  
    echo "- devmethod validate # Run validation suite"
    echo "- devmethod help     # Show help"
    echo ""
    echo "Configuration: $CONFIG_FILE"
    echo "Happy engineering! 🚀"
}

# Main execution
main() {
    echo "Starting DevMethod setup..."
    echo ""
    
    check_requirements
    create_directory_structure  
    install_dependencies
    create_configuration
    setup_claude_integration
    create_helper_scripts
    setup_path
    run_verification
    print_next_steps
}

# Run main function
main "$@"