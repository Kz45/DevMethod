#!/bin/bash

# DevMethod 2.0 WIRASM-Enhanced Validation System
# Implements executable validation loops for one-pass success

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

# Configuration
PROJECT_DIR="${1:-.}"
VALIDATION_LEVEL="${2:-all}"
VALIDATION_DIR="$PROJECT_DIR/.devmethod/validation"

show_help() {
    echo "DevMethod 2.0 WIRASM-Enhanced Validation System"
    echo ""
    echo "Usage: $0 [project_dir] [validation_level]"
    echo ""
    echo "Validation Levels:"
    echo "  level1    - Syntax & Style (< 2 minutes)"
    echo "  level2    - Unit Testing (< 10 minutes)"
    echo "  level3    - Integration Testing (< 30 minutes)"
    echo "  level4    - Production Readiness (< 2 hours)"
    echo "  all       - Run all validation levels sequentially"
    echo ""
    echo "Examples:"
    echo "  $0 . level1                 # Quick syntax validation"
    echo "  $0 ./my-project level2      # Unit testing validation"
    echo "  $0 . all                    # Complete validation suite"
    echo ""
    echo "This implements WIRASM validation loops for one-pass implementation success."
}

log_info() {
    echo -e "${BLUE}[VALIDATION]${NC} $1"
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

log_phase() {
    echo -e "${CYAN}[PHASE]${NC} $1"
}

setup_validation() {
    log_info "Setting up WIRASM-enhanced validation environment..."
    
    mkdir -p "$VALIDATION_DIR"
    mkdir -p "$VALIDATION_DIR/results"
    mkdir -p "$VALIDATION_DIR/logs"
    
    # Initialize validation tracking
    cat > "$VALIDATION_DIR/validation_state.json" << EOF
{
  "project_dir": "$PROJECT_DIR",
  "started_at": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "validation_levels": {
    "level1": {"status": "pending", "duration": null, "errors": []},
    "level2": {"status": "pending", "duration": null, "errors": []},
    "level3": {"status": "pending", "duration": null, "errors": []},
    "level4": {"status": "pending", "duration": null, "errors": []}
  },
  "overall_status": "running",
  "wirasm_principles": {
    "context_is_king": false,
    "validation_loops": false,
    "information_dense": false,
    "progressive_success": false
  }
}
EOF

    log_success "Validation environment initialized"
}

validate_level1_syntax_style() {
    log_phase "Level 1: Syntax & Style Validation (WIRASM: Immediate feedback)"
    
    local start_time=$(date +%s)
    local errors=0
    
    cd "$PROJECT_DIR"
    
    # Detect project type and run appropriate validations
    if [ -f "package.json" ]; then
        log_info "Detected Node.js project - running JavaScript/TypeScript validation"
        
        # ESLint + Prettier
        if [ -f ".eslintrc.js" ] || [ -f ".eslintrc.json" ] || [ -f "eslint.config.js" ]; then
            log_info "Running ESLint..."
            if ! npm run lint 2>&1 | tee "$VALIDATION_DIR/logs/eslint.log"; then
                ((errors++))
                log_error "ESLint validation failed"
            fi
        fi
        
        # TypeScript check
        if [ -f "tsconfig.json" ]; then
            log_info "Running TypeScript compilation check..."
            if ! npm run type-check 2>&1 | tee "$VALIDATION_DIR/logs/typescript.log"; then
                ((errors++))
                log_error "TypeScript validation failed"
            fi
        fi
        
        # DevMethod Code Limits Check (NEW)
        log_info "Running DevMethod code limits validation..."
        if ! validate_code_limits_js "$PROJECT_DIR" 2>&1 | tee "$VALIDATION_DIR/logs/code-limits.log"; then
            ((errors++))
            log_error "Code limits validation failed"
        fi
        
        # Build check
        log_info "Running build validation..."
        if ! npm run build 2>&1 | tee "$VALIDATION_DIR/logs/build.log"; then
            ((errors++))
            log_error "Build validation failed"
        fi
        
    elif [ -f "requirements.txt" ] || [ -f "pyproject.toml" ]; then
        log_info "Detected Python project - running Python validation"
        
        # Black formatting
        if command -v black >&2; then
            log_info "Running Black formatter check..."
            if ! black --check . 2>&1 | tee "$VALIDATION_DIR/logs/black.log"; then
                ((errors++))
                log_error "Black formatting validation failed"
            fi
        fi
        
        # Flake8 linting
        if command -v flake8 >&2; then
            log_info "Running Flake8 linting..."
            if ! flake8 . 2>&1 | tee "$VALIDATION_DIR/logs/flake8.log"; then
                ((errors++))
                log_error "Flake8 validation failed"
            fi
        fi
        
        # MyPy type checking
        if command -v mypy >&2; then
            log_info "Running MyPy type checking..."
            if ! mypy . 2>&1 | tee "$VALIDATION_DIR/logs/mypy.log"; then
                ((errors++))
                log_error "MyPy validation failed"
            fi
        fi
        
        # DevMethod Code Limits Check for Python (NEW)
        log_info "Running DevMethod Python code limits validation..."
        if ! validate_code_limits_python "$PROJECT_DIR" 2>&1 | tee "$VALIDATION_DIR/logs/python-limits.log"; then
            ((errors++))
            log_error "Python code limits validation failed"
        fi
        
    else
        log_warning "Project type not detected - running generic validations"
    fi
    
    # Security scanning (generic)
    log_info "Running security scan..."
    if command -v semgrep >&2; then
        if ! semgrep --config=auto . 2>&1 | tee "$VALIDATION_DIR/logs/security.log"; then
            ((errors++))
            log_error "Security scan found issues"
        fi
    else
        log_warning "Semgrep not installed - skipping security scan"
    fi
    
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    
    # Update validation state
    update_validation_state "level1" "$duration" "$errors"
    
    if [ $errors -eq 0 ]; then
        log_success "✅ Level 1 validation passed (${duration}s)"
        return 0
    else
        log_error "❌ Level 1 validation failed with $errors errors (${duration}s)"
        return 1
    fi
}

validate_level2_unit_testing() {
    log_phase "Level 2: Unit Testing Validation (WIRASM: Per Story)"
    
    local start_time=$(date +%s)
    local errors=0
    
    cd "$PROJECT_DIR"
    
    if [ -f "package.json" ]; then
        # Jest/Vitest for JavaScript/TypeScript
        log_info "Running unit tests with coverage..."
        if ! npm run test -- --coverage --threshold=80 2>&1 | tee "$VALIDATION_DIR/logs/unit-tests.log"; then
            ((errors++))
            log_error "Unit tests failed or coverage below 80%"
        fi
        
        # Performance budget validation
        if npm list --depth=0 | grep -q "lighthouse"; then
            log_info "Running performance budget validation..."
            if ! npm run test:performance 2>&1 | tee "$VALIDATION_DIR/logs/performance.log"; then
                ((errors++))
                log_error "Performance budget validation failed"
            fi
        fi
        
    elif [ -f "requirements.txt" ] || [ -f "pyproject.toml" ]; then
        # Pytest for Python
        log_info "Running Python unit tests with coverage..."
        if ! python -m pytest tests/ -v --cov=. --cov-report=term --cov-fail-under=80 2>&1 | tee "$VALIDATION_DIR/logs/pytest.log"; then
            ((errors++))
            log_error "Python unit tests failed or coverage below 80%"
        fi
    fi
    
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    
    update_validation_state "level2" "$duration" "$errors"
    
    if [ $errors -eq 0 ]; then
        log_success "✅ Level 2 validation passed (${duration}s)"
        return 0
    else
        log_error "❌ Level 2 validation failed with $errors errors (${duration}s)"
        return 1
    fi
}

validate_level3_integration() {
    log_phase "Level 3: Integration Testing (WIRASM: Per Epic)"
    
    local start_time=$(date +%s)
    local errors=0
    
    cd "$PROJECT_DIR"
    
    if [ -f "package.json" ]; then
        # Integration tests
        if npm run | grep -q "test:integration"; then
            log_info "Running integration tests..."
            if ! npm run test:integration 2>&1 | tee "$VALIDATION_DIR/logs/integration.log"; then
                ((errors++))
                log_error "Integration tests failed"
            fi
        fi
        
        # End-to-end tests
        if npm run | grep -q "test:e2e"; then
            log_info "Running end-to-end tests..."
            if ! npm run test:e2e 2>&1 | tee "$VALIDATION_DIR/logs/e2e.log"; then
                ((errors++))
                log_error "End-to-end tests failed"
            fi
        fi
        
        # API contract tests
        if npm run | grep -q "test:api"; then
            log_info "Running API contract tests..."
            if ! npm run test:api 2>&1 | tee "$VALIDATION_DIR/logs/api.log"; then
                ((errors++))
                log_error "API contract tests failed"
            fi
        fi
    fi
    
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    
    update_validation_state "level3" "$duration" "$errors"
    
    if [ $errors -eq 0 ]; then
        log_success "✅ Level 3 validation passed (${duration}s)"
        return 0
    else
        log_error "❌ Level 3 validation failed with $errors errors (${duration}s)"
        return 1
    fi
}

validate_level4_production() {
    log_phase "Level 4: Production Readiness (WIRASM: Pre-Deploy)"
    
    local start_time=$(date +%s)
    local errors=0
    
    cd "$PROJECT_DIR"
    
    # Security audit
    log_info "Running comprehensive security audit..."
    if [ -f "package.json" ]; then
        if ! npm audit --audit-level=high 2>&1 | tee "$VALIDATION_DIR/logs/audit.log"; then
            ((errors++))
            log_error "Security audit found high-severity vulnerabilities"
        fi
    fi
    
    # Load testing (if configured)
    if [ -f "load-test.js" ] || [ -f "load-test.py" ]; then
        log_info "Running load tests..."
        if [ -f "package.json" ] && npm run | grep -q "load-test"; then
            if ! npm run load-test 2>&1 | tee "$VALIDATION_DIR/logs/load-test.log"; then
                ((errors++))
                log_error "Load tests failed"
            fi
        fi
    fi
    
    # Staging deployment test
    if [ -f "deploy-staging.sh" ] || ([ -f "package.json" ] && npm run | grep -q "deploy:staging"); then
        log_info "Running staging deployment test..."
        if [ -f "package.json" ]; then
            if ! npm run deploy:staging 2>&1 | tee "$VALIDATION_DIR/logs/deploy-staging.log"; then
                ((errors++))
                log_error "Staging deployment failed"
            fi
        fi
    fi
    
    # Smoke tests on staging
    if [ -f "package.json" ] && npm run | grep -q "smoke-test"; then
        log_info "Running smoke tests on staging..."
        if ! npm run smoke-test 2>&1 | tee "$VALIDATION_DIR/logs/smoke-test.log"; then
            ((errors++))
            log_error "Smoke tests failed"
        fi
    fi
    
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    
    update_validation_state "level4" "$duration" "$errors"
    
    if [ $errors -eq 0 ]; then
        log_success "✅ Level 4 validation passed (${duration}s)"
        return 0
    else
        log_error "❌ Level 4 validation failed with $errors errors (${duration}s)"
        return 1
    fi
}

update_validation_state() {
    local level="$1"
    local duration="$2"
    local errors="$3"
    local status="passed"
    
    if [ "$errors" -gt 0 ]; then
        status="failed"
    fi
    
    # Update JSON state (simplified - in production would use jq)
    log_info "Updating validation state: $level = $status ($duration s, $errors errors)"
}

validate_code_limits_js() {
    local project_dir="$1"
    local validation_errors=0
    
    log_info "Validating JavaScript/TypeScript code limits (DevMethod Standards)..."
    
    # Check if DevMethod ESLint config exists, if not create it
    local eslint_config="$project_dir/.eslintrc.devmethod.json"
    if [ ! -f "$eslint_config" ]; then
        log_info "Creating DevMethod ESLint configuration..."
        cp "$(dirname "$0")/../config/eslint-devmethod.json" "$eslint_config"
    fi
    
    # Run ESLint with DevMethod rules
    log_info "Checking file length limits (<500 lines)..."
    if ! npx eslint --config "$eslint_config" --rule "max-lines: [error, 500]" "$project_dir"/**/*.{js,jsx,ts,tsx} 2>/dev/null; then
        log_error "Found files exceeding 500 lines limit"
        ((validation_errors++))
    fi
    
    # Check function length limits
    log_info "Checking function length limits (<50 lines)..."
    if ! npx eslint --config "$eslint_config" --rule "max-lines-per-function: [error, 50]" "$project_dir"/**/*.{js,jsx,ts,tsx} 2>/dev/null; then
        log_error "Found functions exceeding 50 lines limit"
        ((validation_errors++))
    fi
    
    # Check cyclomatic complexity
    log_info "Checking cyclomatic complexity (<10)..."
    if ! npx eslint --config "$eslint_config" --rule "complexity: [error, 10]" "$project_dir"/**/*.{js,jsx,ts,tsx} 2>/dev/null; then
        log_error "Found functions exceeding complexity limit of 10"
        ((validation_errors++))
    fi
    
    # Alternative: Use cloc for file length check
    if command -v cloc >&2; then
        log_info "Running CLOC analysis for detailed file statistics..."
        cloc "$project_dir" --csv --quiet --exclude-dir=node_modules,build,dist > "$VALIDATION_DIR/logs/cloc-analysis.csv"
        
        # Check for files > 500 lines using awk
        if awk -F, 'NR>1 && $5 > 500 { print "WARNING: " $2 " has " $5 " lines (>500)"; found=1 } END { exit found }' "$VALIDATION_DIR/logs/cloc-analysis.csv"; then
            log_error "CLOC detected files exceeding 500 lines"
            ((validation_errors++))
        fi
    fi
    
    return $validation_errors
}

validate_code_limits_python() {
    local project_dir="$1"
    local validation_errors=0
    
    log_info "Validating Python code limits (DevMethod Standards)..."
    
    # Use flake8 with DevMethod configuration
    local flake8_config="$project_dir/.flake8"
    if [ ! -f "$flake8_config" ]; then
        log_info "Creating DevMethod Flake8 configuration..."
        cp "$(dirname "$0")/../config/flake8-devmethod.ini" "$flake8_config"
    fi
    
    # Enhanced flake8 check with complexity
    if command -v flake8 >&2; then
        log_info "Running enhanced Flake8 with complexity checks..."
        if ! flake8 --config="$flake8_config" "$project_dir" 2>/dev/null; then
            log_error "Python code quality checks failed"
            ((validation_errors++))
        fi
    fi
    
    # Manual file length check for Python files
    log_info "Checking Python file lengths (<500 lines)..."
    while IFS= read -r -d '' file; do
        local line_count=$(wc -l < "$file")
        if [ "$line_count" -gt 500 ]; then
            log_error "File $file has $line_count lines (exceeds 500 line limit)"
            ((validation_errors++))
        fi
    done < <(find "$project_dir" -name "*.py" -not -path "*/.*" -not -path "*/node_modules/*" -not -path "*/venv/*" -not -path "*/__pycache__/*" -print0)
    
    # Function length check using basic grep/awk
    log_info "Checking Python function lengths (<50 lines)..."
    find "$project_dir" -name "*.py" -not -path "*/.*" -not -path "*/venv/*" -exec awk '
        /^def / || /^async def / { 
            if (func_start > 0) {
                func_length = NR - func_start
                if (func_length > 50) {
                    print FILENAME ":" func_start ": Function " func_name " has " func_length " lines (>50)"
                    errors++
                }
            }
            func_start = NR
            func_name = $2
        }
        /^class / || /^$/ || /^#/ { 
            if (func_start > 0 && !/^    /) {
                func_length = NR - func_start
                if (func_length > 50) {
                    print FILENAME ":" func_start ": Function " func_name " has " func_length " lines (>50)"
                    errors++
                }
                func_start = 0
            }
        }
        END { if (errors > 0) exit 1 }
    ' {} \; || ((validation_errors++))
    
    return $validation_errors
}

run_wirasm_compliance_check() {
    log_phase "WIRASM Compliance Check"
    
    local score=0
    local max_score=4
    
    # Check for "Context is King" compliance
    if [ -f "$PROJECT_DIR/docs/context/context-complete.json" ] || [ -f "$PROJECT_DIR/CLAUDE.md" ]; then
        ((score++))
        log_success "✅ Context is King: Comprehensive context documentation found"
    else
        log_warning "⚠️ Context is King: Missing comprehensive context documentation"
    fi
    
    # Check for validation loops
    if [ -f "$PROJECT_DIR/package.json" ] && (npm run | grep -q "lint\|test\|build"); then
        ((score++))
        log_success "✅ Validation Loops: Executable validation commands found"
    else
        log_warning "⚠️ Validation Loops: Missing executable validation commands"
    fi
    
    # Check for information density (CLAUDE.md with examples)
    if [ -f "$PROJECT_DIR/CLAUDE.md" ] && grep -q "example\|pattern\|keyword" "$PROJECT_DIR/CLAUDE.md"; then
        ((score++))
        log_success "✅ Information Dense: Codebase patterns and examples documented"
    else
        log_warning "⚠️ Information Dense: Missing codebase patterns and examples"
    fi
    
    # Check for progressive success (MVP/phases documentation)
    if find "$PROJECT_DIR" -name "*.md" -exec grep -l "MVP\|Phase.*1\|progressive" {} \; | head -1; then
        ((score++))
        log_success "✅ Progressive Success: Phased development approach documented"
    else
        log_warning "⚠️ Progressive Success: Missing phased development documentation"
    fi
    
    log_info "WIRASM Compliance Score: $score/$max_score"
    
    if [ "$score" -ge 3 ]; then
        log_success "✅ WIRASM compliance level: GOOD (ready for one-pass success)"
        return 0
    else
        log_warning "⚠️ WIRASM compliance level: NEEDS IMPROVEMENT"
        return 1
    fi
}

generate_validation_report() {
    log_info "Generating comprehensive validation report..."
    
    local report_file="$VALIDATION_DIR/results/validation_report_$(date +%Y%m%d_%H%M%S).md"
    
    cat > "$report_file" << EOF
# DevMethod 2.0 WIRASM-Enhanced Validation Report

**Generated**: $(date)  
**Project**: $PROJECT_DIR  
**Validation Level**: $VALIDATION_LEVEL

## Executive Summary

This report summarizes the WIRASM-enhanced validation results for one-pass implementation success.

## Validation Results

### Level 1: Syntax & Style
- **Status**: $(if [ -f "$VALIDATION_DIR/logs/eslint.log" ]; then echo "Executed"; else echo "Skipped"; fi)
- **Duration**: [See logs for timing]
- **Key Focus**: Immediate feedback for basic code quality

### Level 2: Unit Testing  
- **Status**: $(if [ -f "$VALIDATION_DIR/logs/unit-tests.log" ]; then echo "Executed"; else echo "Skipped"; fi)
- **Duration**: [See logs for timing]
- **Key Focus**: Per-story validation with coverage requirements

### Level 3: Integration Testing
- **Status**: $(if [ -f "$VALIDATION_DIR/logs/integration.log" ]; then echo "Executed"; else echo "Skipped"; fi)
- **Duration**: [See logs for timing]  
- **Key Focus**: Per-epic validation with end-to-end workflows

### Level 4: Production Readiness
- **Status**: $(if [ -f "$VALIDATION_DIR/logs/audit.log" ]; then echo "Executed"; else echo "Skipped"; fi)
- **Duration**: [See logs for timing]
- **Key Focus**: Pre-deploy validation with security and performance

## WIRASM Principle Compliance

The validation checked compliance with core WIRASM principles for one-pass success:

1. **Context is King**: Comprehensive documentation and context
2. **Validation Loops**: Executable validation commands
3. **Information Dense**: Codebase patterns and examples
4. **Progressive Success**: Phased development approach

## Recommendations

Based on validation results:

- **Immediate Actions**: Fix any Level 1-2 validation failures
- **Short-term**: Improve WIRASM compliance score
- **Long-term**: Implement comprehensive validation automation

## Detailed Logs

All detailed validation logs are available in:
- \`$VALIDATION_DIR/logs/\`

## Next Steps

1. Address any validation failures identified
2. Improve WIRASM compliance where needed
3. Re-run validation to confirm fixes
4. Proceed with confidence for one-pass implementation success

---
*Generated by DevMethod 2.0 WIRASM-Enhanced Validation System*
EOF
    
    log_success "Validation report generated: $report_file"
    echo "$report_file"
}

# Main execution
main() {
    if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
        show_help
        exit 0
    fi
    
    echo "🔍 DevMethod 2.0 WIRASM-Enhanced Validation System"
    echo "=================================================="
    echo "Project: $PROJECT_DIR"
    echo "Validation Level: $VALIDATION_LEVEL"
    echo ""
    
    setup_validation
    
    local overall_success=true
    
    case $VALIDATION_LEVEL in
        "level1")
            if ! validate_level1_syntax_style; then
                overall_success=false
            fi
            ;;
        "level2")
            if ! validate_level1_syntax_style || ! validate_level2_unit_testing; then
                overall_success=false
            fi
            ;;
        "level3")
            if ! validate_level1_syntax_style || ! validate_level2_unit_testing || ! validate_level3_integration; then
                overall_success=false
            fi
            ;;
        "level4")
            if ! validate_level1_syntax_style || ! validate_level2_unit_testing || ! validate_level3_integration || ! validate_level4_production; then
                overall_success=false
            fi
            ;;
        "all")
            if ! validate_level1_syntax_style; then overall_success=false; fi
            if ! validate_level2_unit_testing; then overall_success=false; fi
            if ! validate_level3_integration; then overall_success=false; fi
            if ! validate_level4_production; then overall_success=false; fi
            ;;
        *)
            log_error "Invalid validation level: $VALIDATION_LEVEL"
            show_help
            exit 1
            ;;
    esac
    
    echo ""
    log_phase "WIRASM Compliance Assessment"
    run_wirasm_compliance_check
    
    echo ""
    log_phase "Final Report Generation"
    report_file=$(generate_validation_report)
    
    echo ""
    if $overall_success; then
        log_success "🎉 VALIDATION COMPLETE - Ready for One-Pass Implementation Success!"
        log_info "All validation levels passed - proceed with confidence"
        echo ""
        echo "📋 Next Steps:"
        echo "1. Review validation report: $report_file"
        echo "2. Proceed with development using validated foundation"
        echo "3. Continue WIRASM methodology for ongoing success"
        exit 0
    else
        log_error "❌ VALIDATION FAILED - Address Issues Before Proceeding"
        log_info "Review logs and fix validation failures"
        echo ""
        echo "📋 Required Actions:"
        echo "1. Review validation report: $report_file"
        echo "2. Fix all validation failures identified"
        echo "3. Re-run validation until all levels pass"
        echo "4. Only proceed with development after full validation success"
        exit 1
    fi
}

main "$@"