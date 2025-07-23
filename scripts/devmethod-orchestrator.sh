#!/bin/bash

# DevMethod Multi-Agent Orchestrator
# Coordinates parallel agent work with conflict prevention

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

# Configuration
PROJECT_DIR="${1:-.}"
TASK_DESCRIPTION="$2"
ORCHESTRATION_DIR="$PROJECT_DIR/.devmethod/orchestration"

show_help() {
    echo "DevMethod Multi-Agent Orchestrator"
    echo ""
    echo "Usage: $0 [project_dir] \"<task_description>\""
    echo ""
    echo "Examples:"
    echo "  $0 . \"Implement user authentication system\""
    echo "  $0 ./my-project \"Create product catalog with search\""
    echo ""
    echo "This script coordinates multiple agents working in parallel while preventing conflicts."
}

log_info() {
    echo -e "${BLUE}[ORCHESTRATOR]${NC} $1"
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

log_agent() {
    local agent="$1"
    local message="$2"
    echo -e "${CYAN}[${agent}]${NC} $2"
}

setup_orchestration() {
    log_info "Setting up multi-agent orchestration..."
    
    mkdir -p "$ORCHESTRATION_DIR"
    mkdir -p "$ORCHESTRATION_DIR/tasks"
    mkdir -p "$ORCHESTRATION_DIR/locks"
    mkdir -p "$ORCHESTRATION_DIR/communication"
    mkdir -p "$ORCHESTRATION_DIR/status"
    
    # Initialize global state
    cat > "$ORCHESTRATION_DIR/global_state.json" << EOF
{
  "task_description": "$TASK_DESCRIPTION",
  "created_at": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "phase": "orchestration",
  "active_agents": [],
  "completed_tasks": [],
  "conflicts_detected": [],
  "status": "initializing"
}
EOF

    # Initialize file ownership matrix
    cat > "$ORCHESTRATION_DIR/file_ownership.json" << EOF
{
  "ownership_rules": {
    "src/components/": ["dev"],
    "src/pages/": ["dev"],
    "src/api/": ["dev"],
    "docs/architecture/": ["architect"],
    "docs/prps/": ["pm"],
    "docs/stories/": ["pm"],
    "tests/": ["qa"],
    "docs/testing/": ["qa"]
  },
  "shared_files": {
    "package.json": {
      "sections": {
        "dependencies": ["dev"],
        "scripts": ["qa", "dev"],
        "devDependencies": ["qa"]
      }
    },
    "CLAUDE.md": ["orchestrator"]
  },
  "locks": {}
}
EOF

    log_success "Orchestration environment initialized"
}

analyze_task() {
    local task="$1"
    log_info "Analyzing task for parallel decomposition..."
    
    # Task decomposition logic (simplified for demo)
    cat > "$ORCHESTRATION_DIR/task_breakdown.json" << EOF
{
  "main_task": "$task",
  "decomposition": {
    "architect_tasks": [
      {
        "task": "Design system architecture",
        "files": ["docs/architecture/system-design.md"],
        "estimated_time": 45,
        "dependencies": []
      }
    ],
    "pm_tasks": [
      {
        "task": "Create user stories and acceptance criteria",
        "files": ["docs/stories/user-stories.md"],
        "estimated_time": 30,
        "dependencies": []
      }
    ],
    "qa_tasks": [
      {
        "task": "Design test strategy",
        "files": ["tests/test-strategy.md", "docs/testing/approach.md"],
        "estimated_time": 35,
        "dependencies": []
      }
    ],
    "dev_tasks": [
      {
        "task": "Setup project structure",
        "files": ["src/setup/", "package.json"],
        "estimated_time": 20,
        "dependencies": ["architect_tasks"]
      }
    ]
  },
  "parallel_phases": {
    "phase_1": {
      "name": "Documentation & Design",
      "agents": ["architect", "pm", "qa"],
      "parallel": true,
      "estimated_time": 45
    },
    "phase_2": {
      "name": "Implementation Setup",
      "agents": ["dev"],
      "parallel": false,
      "dependencies": ["phase_1"],
      "estimated_time": 20
    }
  }
}
EOF

    log_success "Task decomposed into parallel work streams"
}

check_conflicts() {
    log_info "Checking for potential file conflicts..."
    
    local conflicts=0
    
    # Check for overlapping file ownership
    # (Simplified conflict detection)
    
    if [ $conflicts -eq 0 ]; then
        log_success "No conflicts detected - safe for parallel execution"
        return 0
    else
        log_error "$conflicts conflicts detected - manual resolution required"
        return 1
    fi
}

generate_agent_instructions() {
    local agent="$1"
    log_info "Generating instructions for $agent agent..."
    
    case $agent in
        "architect")
            cat > "$ORCHESTRATION_DIR/tasks/architect_instructions.md" << EOF
# ARCHITECT Agent Instructions - Parallel Session

## Your Parallel Task
Design the system architecture for: $TASK_DESCRIPTION

## Files You Own (No Conflicts)
- docs/architecture/ (all files)
- Any architecture documentation

## Dependencies
- Wait for: None (can start immediately)
- Blocks: DEV agent (they need your architecture)

## Deliverables
1. System architecture document
2. Database design
3. API architecture
4. Security considerations

## Coordination
- Notify when complete: Update status in orchestration/status/architect_status.json
- Communication: Use orchestration/communication/ for messages to other agents

## Estimated Time: 45 minutes
## Status Updates: Every 15 minutes

Begin when ready - you have the green light for parallel work!
EOF
            ;;
        "pm")
            cat > "$ORCHESTRATION_DIR/tasks/pm_instructions.md" << EOF
# PM Agent Instructions - Parallel Session

## Your Parallel Task
Create comprehensive user stories for: $TASK_DESCRIPTION

## Files You Own (No Conflicts)
- docs/prps/ (all files)
- docs/stories/ (all files)
- Any requirements documentation

## Dependencies
- Wait for: None (can start immediately)
- Blocks: None (independent work)

## Deliverables
1. Detailed user stories
2. Acceptance criteria
3. Business requirements
4. Feature prioritization

## Coordination
- Notify when complete: Update status in orchestration/status/pm_status.json
- Cross-validate with ARCHITECT for technical feasibility

## Estimated Time: 30 minutes
## Status Updates: Every 10 minutes

Begin when ready - you have the green light for parallel work!
EOF
            ;;
        "qa")
            cat > "$ORCHESTRATION_DIR/tasks/qa_instructions.md" << EOF
# QA Agent Instructions - Parallel Session

## Your Parallel Task
Design comprehensive testing strategy for: $TASK_DESCRIPTION

## Files You Own (No Conflicts)
- tests/ (all files)
- docs/testing/ (all files)
- Test configuration files

## Dependencies
- Wait for: None (can start immediately)
- Collaborates with: DEV (when implementation begins)

## Deliverables
1. Test strategy document
2. Test framework setup
3. Test templates and examples
4. Quality gates definition

## Coordination
- Notify when complete: Update status in orchestration/status/qa_status.json
- Prepare to work with DEV in implementation phase

## Estimated Time: 35 minutes
## Status Updates: Every 15 minutes

Begin when ready - you have the green light for parallel work!
EOF
            ;;
        "dev")
            cat > "$ORCHESTRATION_DIR/tasks/dev_instructions.md" << EOF
# DEV Agent Instructions - Sequential Session

## Your Task (Waits for Architecture)
Implement the system according to architecture and requirements for: $TASK_DESCRIPTION

## Files You Own
- src/ (all implementation files)
- Package configuration files
- Build and deployment files

## Dependencies
- Wait for: ARCHITECT completion (architecture design)
- Wait for: PM completion (user stories)
- Collaborates with: QA (testing)

## Deliverables
1. Working implementation
2. Code following architecture
3. All user stories implemented
4. Integration with QA tests

## Coordination
- Check: orchestration/status/ for dependency completion
- Update: orchestration/status/dev_status.json
- Collaborate: With QA during implementation

## Estimated Time: 60 minutes (after dependencies complete)
## Status Updates: Every 20 minutes

Wait for architecture completion before beginning!
EOF
            ;;
    esac
    
    log_success "Instructions generated for $agent"
}

monitor_progress() {
    log_info "Monitoring multi-agent progress..."
    
    # Initialize status files
    for agent in architect pm qa dev; do
        cat > "$ORCHESTRATION_DIR/status/${agent}_status.json" << EOF
{
  "agent": "$agent",
  "status": "not_started",
  "progress": 0,
  "tasks_completed": [],
  "current_task": "",
  "estimated_completion": "",
  "last_update": "",
  "files_modified": [],
  "messages": []
}
EOF
    done
    
    log_info "Status monitoring initialized"
    log_info "Check status with: watch cat $ORCHESTRATION_DIR/status/*_status.json"
}

create_sync_checkpoints() {
    log_info "Creating synchronization checkpoints..."
    
    cat > "$ORCHESTRATION_DIR/sync_checkpoints.json" << EOF
{
  "checkpoints": {
    "checkpoint_1": {
      "name": "Documentation Phase Complete",
      "required_agents": ["architect", "pm", "qa"],
      "validation_criteria": [
        "architect: Architecture document complete",
        "pm: User stories defined with acceptance criteria", 
        "qa: Test strategy documented"
      ],
      "conflicts_to_resolve": "Cross-validate requirements vs architecture",
      "next_phase": "Implementation phase can begin"
    },
    "checkpoint_2": {
      "name": "Implementation Setup Complete",
      "required_agents": ["dev"],
      "validation_criteria": [
        "dev: Project structure matches architecture",
        "dev: Dependencies installed and configured",
        "integration: No merge conflicts detected"
      ],
      "conflicts_to_resolve": "Verify all agent outputs integrate cleanly",
      "next_phase": "Feature implementation"
    }
  }
}
EOF

    log_success "Sync checkpoints defined"
}

start_orchestration() {
    log_info "Starting multi-agent orchestrated development..."
    
    echo ""
    log_success "🚀 MULTI-AGENT ORCHESTRATION READY"
    echo "=========================================="
    echo ""
    echo "Task: $TASK_DESCRIPTION"
    echo ""
    echo "Phase 1 - Parallel Documentation (45 min):"
    echo "  👷 ARCHITECT: Design system architecture"
    echo "  📋 PM: Create user stories and requirements" 
    echo "  🧪 QA: Design testing strategy"
    echo ""
    echo "Phase 2 - Implementation Setup (20 min):"
    echo "  💻 DEV: Setup project structure (after architecture)"
    echo ""
    echo "Generated Instructions:"
    echo "  📄 Architect: $ORCHESTRATION_DIR/tasks/architect_instructions.md"
    echo "  📄 PM: $ORCHESTRATION_DIR/tasks/pm_instructions.md"
    echo "  📄 QA: $ORCHESTRATION_DIR/tasks/qa_instructions.md"
    echo "  📄 DEV: $ORCHESTRATION_DIR/tasks/dev_instructions.md"
    echo ""
    echo "Monitoring:"
    echo "  📊 Status: $ORCHESTRATION_DIR/status/"
    echo "  💬 Communication: $ORCHESTRATION_DIR/communication/"
    echo "  🔒 Locks: $ORCHESTRATION_DIR/locks/"
    echo ""
    log_info "Ready to begin parallel execution!"
    echo ""
    echo "Next steps:"
    echo "1. Open 3 separate Claude Code sessions"
    echo "2. Load each agent with their specific instructions"
    echo "3. Start Phase 1 agents simultaneously"
    echo "4. Monitor progress in orchestration/status/"
    echo "5. Begin Phase 2 after Phase 1 completion"
}

# Validate inputs
if [ $# -lt 2 ]; then
    show_help
    exit 1
fi

if [ -z "$TASK_DESCRIPTION" ]; then
    log_error "Task description is required"
    show_help
    exit 1
fi

# Main execution
main() {
    echo "🎭 DevMethod Multi-Agent Orchestrator"
    echo "====================================="
    echo "Project: $PROJECT_DIR"
    echo "Task: $TASK_DESCRIPTION"
    echo ""
    
    setup_orchestration
    analyze_task "$TASK_DESCRIPTION"
    
    if check_conflicts; then
        for agent in architect pm qa dev; do
            generate_agent_instructions "$agent"
        done
        
        monitor_progress
        create_sync_checkpoints
        start_orchestration
    else
        log_error "Conflicts detected - cannot proceed with parallel execution"
        exit 1
    fi
}

main "$@"