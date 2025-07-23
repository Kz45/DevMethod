#!/bin/bash

# DevMethod Context Validator
# Validates context completeness and provides real-time feedback

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
DEVMETHOD_DIR="$HOME/.devmethod"
CONFIG_FILE="$DEVMETHOD_DIR/config.yaml"
MIN_SCORE=190
MAX_SCORE=200

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

show_help() {
    echo "DevMethod Context Validator"
    echo ""
    echo "Usage: $0 [OPTIONS] <context_file>"
    echo ""
    echo "Options:"
    echo "  -h, --help           Show this help message"
    echo "  -v, --verbose        Verbose output"
    echo "  -s, --score-only     Show score only (for scripting)"
    echo "  -r, --recommendations Show improvement recommendations"
    echo "  --min-score N        Set minimum required score (default: 190)"
    echo ""
    echo "Examples:"
    echo "  $0 context.json"
    echo "  $0 --verbose --recommendations context.json"
    echo "  $0 --score-only context.json"
}

validate_file() {
    local file="$1"
    
    if [ ! -f "$file" ]; then
        log_error "File not found: $file"
        exit 1
    fi
    
    # Check if file is valid JSON
    if ! jq empty "$file" 2>/dev/null; then
        log_error "Invalid JSON format in $file"
        exit 1
    fi
}

calculate_dimension_score() {
    local dimension="$1"
    local data="$2"
    local max_weight="$3"
    
    # Count non-empty fields
    local total_fields=$(echo "$data" | jq 'length // 0')
    local filled_fields=$(echo "$data" | jq '[.[] | select(. != null and . != "")] | length')
    
    if [ "$total_fields" -eq 0 ]; then
        echo "0"
        return
    fi
    
    # Calculate completeness ratio
    local completeness=$(echo "scale=2; $filled_fields / $total_fields" | bc -l)
    
    # Calculate quality based on content length and specificity
    local quality_score=0
    
    # Check for substantial content (>50 chars per field on average)
    local avg_length=$(echo "$data" | jq -r '[.[] | select(. != null and . != "") | length] | add // 0' | head -1)
    if [ "$filled_fields" -gt 0 ]; then
        avg_length=$(echo "scale=0; $avg_length / $filled_fields" | bc -l)
        if [ "${avg_length%.*}" -gt 50 ]; then
            quality_score=$(echo "$quality_score + 0.3" | bc -l)
        fi
    fi
    
    # Check for specific indicators (URLs, versions, examples)
    local specific_content=$(echo "$data" | jq -r '.[] | select(. != null and . != "")' | grep -E "(http|version|example|specific)" | wc -l)
    if [ "$specific_content" -gt 0 ]; then
        quality_score=$(echo "$quality_score + 0.4" | bc -l)
    fi
    
    # Check for placeholder content
    local placeholder_content=$(echo "$data" | jq -r '.[] | select(. != null and . != "")' | grep -iE "(tbd|todo|placeholder)" | wc -l)
    if [ "$placeholder_content" -eq 0 ]; then
        quality_score=$(echo "$quality_score + 0.3" | bc -l)
    fi
    
    # Ensure quality score doesn't exceed 1.0
    if (( $(echo "$quality_score > 1.0" | bc -l) )); then
        quality_score=1.0
    fi
    
    # Calculate final score: completeness (60%) + quality (40%)
    local final_score=$(echo "scale=0; $max_weight * ($completeness * 0.6 + $quality_score * 0.4)" | bc -l)
    echo "${final_score%.*}"
}

score_context() {
    local file="$1"
    
    # Dimension weights (must sum to 200)
    declare -A weights
    weights[business]=15
    weights[technical]=20
    weights[functional]=20
    weights[quality]=15
    weights[dependencies]=10
    weights[data]=10
    weights[experience]=10
    weights[infrastructure]=20
    weights[security]=20
    weights[performance]=15
    weights[maintenance]=15
    weights[emerging]=10
    
    local total_score=0
    declare -A dimension_scores
    declare -A dimension_status
    
    echo "📊 DevMethod Context Validation Results"
    echo "========================================"
    echo ""
    
    # Score each dimension
    for dimension in business technical functional quality dependencies data experience infrastructure security performance maintenance emerging; do
        local data=$(jq ".$dimension // {}" "$file")
        local weight=${weights[$dimension]}
        local score=$(calculate_dimension_score "$dimension" "$data" "$weight")
        
        dimension_scores[$dimension]=$score
        total_score=$((total_score + score))
        
        # Determine status
        local percentage=$((score * 100 / weight))
        if [ "$percentage" -ge 90 ]; then
            dimension_status[$dimension]="✅"
        elif [ "$percentage" -ge 70 ]; then
            dimension_status[$dimension]="⚠️"
        else
            dimension_status[$dimension]="❌"
        fi
        
        if [ "$VERBOSE" = true ]; then
            printf "%-20s %s %3d/%-3d (%3d%%)\n" \
                "$(echo $dimension | sed 's/.*/\u&/'):" \
                "${dimension_status[$dimension]}" \
                "$score" "$weight" "$percentage"
        fi
    done
    
    # Calculate overall percentage
    local percentage=$((total_score * 100 / MAX_SCORE))
    local status="❌"
    
    if [ "$total_score" -ge "$MIN_SCORE" ]; then
        status="✅"
    elif [ "$total_score" -ge 180 ]; then
        status="⚠️"
    fi
    
    echo ""
    echo "📈 Overall Score: $status $total_score/$MAX_SCORE ($percentage%)"
    echo ""
    
    # Status interpretation
    if [ "$total_score" -ge 195 ]; then
        log_success "EXCELLENT - Ready for immediate development"
    elif [ "$total_score" -ge "$MIN_SCORE" ]; then
        log_success "GOOD - Minor context gaps to address"
    elif [ "$total_score" -ge 180 ]; then
        log_warning "FAIR - Significant context work needed"
    else
        log_error "POOR - Major context development required"
    fi
    
    echo ""
    
    # Show detailed breakdown if verbose
    if [ "$VERBOSE" = true ]; then
        echo "📋 Detailed Breakdown:"
        echo "======================"
        for dimension in business technical functional quality dependencies data experience infrastructure security performance maintenance emerging; do
            local score=${dimension_scores[$dimension]}
            local weight=${weights[$dimension]}
            local percentage=$((score * 100 / weight))
            
            echo "$(printf "%-20s" "$(echo $dimension | sed 's/.*/\u&/'):")" \
                 "${dimension_status[$dimension]} $score/$weight ($percentage%)"
        done
        echo ""
    fi
    
    # Show recommendations
    if [ "$SHOW_RECOMMENDATIONS" = true ]; then
        echo "💡 Recommendations:"
        echo "==================="
        
        local recommendations_shown=false
        
        for dimension in business technical functional quality dependencies data experience infrastructure security performance maintenance emerging; do
            local score=${dimension_scores[$dimension]}
            local weight=${weights[$dimension]}
            local percentage=$((score * 100 / weight))
            
            if [ "$percentage" -lt 70 ]; then
                recommendations_shown=true
                case $dimension in
                    business)
                        echo "• Business Context: Add specific user personas, quantify ROI, analyze 3+ competitors"
                        ;;
                    technical)
                        echo "• Technical Architecture: Document exact versions, patterns, integration points"
                        ;;
                    functional)
                        echo "• Functional Requirements: Detail 5+ core features with acceptance criteria"
                        ;;
                    quality)
                        echo "• Quality & Testing: Define testing strategy for unit/integration/e2e levels"
                        ;;
                    dependencies)
                        echo "• Dependencies: Document all external APIs, rate limits, authentication methods"
                        ;;
                    data)
                        echo "• Data & State: Create data models, define state management strategy"
                        ;;
                    experience)
                        echo "• Experience & Patterns: Analyze existing code, document team skills and lessons"
                        ;;
                    infrastructure)
                        echo "• Infrastructure: Plan containerization, CI/CD pipeline, monitoring strategy"
                        ;;
                    security)
                        echo "• Security: Implement OWASP compliance, auth strategy, compliance requirements"
                        ;;
                    performance)
                        echo "• Performance: Define performance budgets, load testing, caching strategy"
                        ;;
                    maintenance)
                        echo "• Maintenance: Plan logging, error handling, backup/DR procedures"
                        ;;
                    emerging)
                        echo "• Emerging Tech: Consider AI/ML integration, edge computing, future roadmap"
                        ;;
                esac
            fi
        done
        
        if [ "$recommendations_shown" = false ]; then
            echo "✅ All dimensions meet quality thresholds - no specific recommendations"
        fi
        echo ""
    fi
    
    # Gap analysis
    if [ "$total_score" -lt "$MIN_SCORE" ]; then
        local gap=$((MIN_SCORE - total_score))
        echo "📉 Gap Analysis:"
        echo "================"
        echo "• Points needed to pass: $gap"
        echo "• Focus on dimensions scoring <70%"
        echo "• Prioritize infrastructure, security, and technical dimensions (higher weights)"
        echo ""
    fi
    
    # Return appropriate exit code
    if [ "$total_score" -ge "$MIN_SCORE" ]; then
        return 0
    else
        return 1
    fi
}

# Parse command line arguments
VERBOSE=false
SCORE_ONLY=false
SHOW_RECOMMENDATIONS=false
CONTEXT_FILE=""

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -s|--score-only)
            SCORE_ONLY=true
            shift
            ;;
        -r|--recommendations)
            SHOW_RECOMMENDATIONS=true
            shift
            ;;
        --min-score)
            MIN_SCORE="$2"
            shift 2
            ;;
        -*)
            log_error "Unknown option: $1"
            show_help
            exit 1
            ;;
        *)
            if [ -z "$CONTEXT_FILE" ]; then
                CONTEXT_FILE="$1"
            else
                log_error "Multiple files specified. Only one file supported."
                exit 1
            fi
            shift
            ;;
    esac
done

# Validate arguments
if [ -z "$CONTEXT_FILE" ]; then
    log_error "No context file specified"
    show_help
    exit 1
fi

# Check for required tools
if ! command -v jq >/dev/null 2>&1; then
    log_error "jq is required but not installed"
    exit 1
fi

if ! command -v bc >/dev/null 2>&1; then
    log_error "bc is required but not installed"
    exit 1
fi

# Main execution
validate_file "$CONTEXT_FILE"

if [ "$SCORE_ONLY" = true ]; then
    # Simple score output for scripting
    total_score=$(jq -r '[(.business//{}|length), (.technical//{}|length)] | add // 0' "$CONTEXT_FILE")
    echo "$total_score/$MAX_SCORE"
else
    score_context "$CONTEXT_FILE"
fi