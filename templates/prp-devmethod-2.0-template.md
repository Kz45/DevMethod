# DevMethod 2.0: Enhanced Product Requirement Prompt (PRP) Template

**Version**: 2.0 (WIRASM-Enhanced)  
**Project**: [PROJECT_NAME]  
**Feature**: [FEATURE_NAME]  
**Created**: [DATE]  
**Author**: [AUTHOR]  

---

## 🎯 CONFIDENCE SCORE

```yaml
PRP_Confidence_Score: __/10

Scoring_Breakdown:
  Context_Completeness: __/10 (40% weight)
    # Based on 12-dimension context score (190+ = 10/10)
  Research_Depth: __/10 (30% weight)  
    # Multi-source research quality and comprehensiveness
  Technical_Clarity: __/10 (30% weight)
    # Technical decisions and implementation clarity

Overall_Confidence: __/10
Status: [DRAFT | APPROVED | NEEDS_REVISION]

# MINIMUM CONFIDENCE REQUIRED: 8/10 for development
```

---

## 🎯 GOAL (Specific end state and desires)

### Primary Objective
<!-- Specific, measurable end state with clear success criteria -->

### Success Metrics
```yaml
Business_Metrics:
  - metric: [Specific KPI]
    target: [Quantified target]
    timeframe: [When to measure]

Technical_Metrics:
  - metric: [Performance/quality measure]
    target: [Specific threshold]
    measurement: [How to measure]

User_Experience_Metrics:
  - metric: [User satisfaction measure]
    target: [Target score/rating]
    validation: [How to validate]
```

### Definition of Done
- [ ] [Specific completion criteria 1]
- [ ] [Specific completion criteria 2]
- [ ] [Specific completion criteria 3]

---

## 💼 WHY (Business value and user impact)

### Business Case
<!-- Clear articulation of business value and user impact -->

### User Impact
```yaml
Primary_Users: [User personas affected]
Pain_Points_Solved:
  - problem: [Specific user problem]
    current_solution: [How they solve it now]
    our_improvement: [How we make it better]

Value_Proposition:
  time_saved: [Hours/minutes saved per user per day]
  efficiency_gain: [% improvement in efficiency]
  cost_reduction: [$ saved or revenue generated]
```

### Strategic Alignment
<!-- How this aligns with company goals and market positioning -->

---

## 🔧 WHAT (User-visible behavior and technical requirements)

### User-Visible Behavior
<!-- Detailed description of what users will see and experience -->

### Core Features
```yaml
Feature_1:
  name: [Feature name]
  description: [What it does]
  user_story: "As a [user], I want [capability], so that [benefit]"
  acceptance_criteria:
    - [Measurable criteria 1]
    - [Measurable criteria 2]
    - [Measurable criteria 3]
  priority: [High | Medium | Low]

Feature_2:
  name: [Feature name]
  description: [What it does]
  user_story: "As a [user], I want [capability], so that [benefit]"
  acceptance_criteria:
    - [Measurable criteria 1]
    - [Measurable criteria 2]
    - [Measurable criteria 3]
  priority: [High | Medium | Low]
```

### Technical Requirements
```yaml
Performance_Requirements:
  response_time: [< X ms for Y% of requests]
  throughput: [X requests per second]
  availability: [99.X% uptime]
  scalability: [Support for X concurrent users]

Security_Requirements:
  authentication: [Required method]
  authorization: [Access control model]
  data_protection: [Encryption requirements]
  compliance: [Regulatory requirements]

Integration_Requirements:
  external_apis: [List of required integrations]
  data_sources: [Required data connections]
  third_party_services: [Service dependencies]
```

---

## 📚 ALL NEEDED CONTEXT (Context is King)

### 🔍 Context Validation Score
```yaml
Total_Context_Score: __/200 points (Required: 190+)

12_Dimension_Breakdown:
  Business_Users_Context: __/15 pts
  Technical_Architecture_Context: __/20 pts
  Functional_Requirements_Context: __/20 pts
  Quality_Testing_Context: __/15 pts
  Dependencies_Integrations_Context: __/10 pts
  Data_State_Context: __/10 pts
  Experience_Patterns_Context: __/10 pts
  Infrastructure_Deployment_Context: __/20 pts
  Security_Compliance_Context: __/20 pts
  Performance_Scalability_Context: __/15 pts
  Maintenance_Support_Context: __/15 pts
  Emerging_Technologies_Context: __/10 pts
```

### 🔍 Research Findings

#### Competitive Analysis
```yaml
Competitor_1:
  name: [Competitor name]
  approach: [How they solve this problem]
  strengths: [What they do well]
  weaknesses: [Where they fall short]
  our_advantage: [How we differentiate]

Competitor_2:
  name: [Competitor name]
  approach: [How they solve this problem]
  strengths: [What they do well]  
  weaknesses: [Where they fall short]
  our_advantage: [How we differentiate]
```

#### User Research
```yaml
Research_Method: [Surveys, interviews, analytics, etc.]
Sample_Size: [Number of users/data points]
Key_Insights:
  - insight: [User behavior or preference]
    evidence: [Supporting data]
    implication: [What this means for our solution]

User_Quotes: # Actual user feedback
  - "[Specific user quote about the problem]"
  - "[User quote about desired solution]"
```

#### Technical Research
```yaml
Technology_Analysis:
  recommended_stack: [Technology choices and rationale]
  alternatives_considered: [Other options evaluated]
  decision_rationale: [Why this choice is best]

Architecture_Patterns:
  pattern: [Chosen architectural pattern]
  benefits: [Why this pattern fits]
  trade_offs: [What we give up for this choice]
```

### 📖 Documentation Resources
```yaml
External_Documentation:
  - name: [API/Library name]
    url: [Documentation URL]
    relevance: [How it applies to our solution]
    key_sections: [Specific sections to reference]
    
  - name: [Framework/Tool name]
    url: [Documentation URL]
    relevance: [How it applies to our solution]
    key_sections: [Specific sections to reference]

Internal_Documentation:
  - document: [Existing internal doc]
    location: [File path or URL]
    relevance: [How it informs this solution]
    key_patterns: [Patterns to follow/avoid]
```

### 💡 Examples and Patterns from Codebase
```yaml
Code_Examples:
  - pattern: [Code pattern name]
    file_location: [Path to example in codebase]
    example: |
      # Relevant code example showing the pattern
      function exampleImplementation() {
        // Implementation details with keywords
      }
    usage: [When and how to use this pattern]
    keywords: [Important keywords from codebase]

Reference_Implementations:
  - name: [Similar feature in codebase]
    location: [File path]
    lessons: [What we learned from this implementation]
    patterns_to_reuse: [Specific patterns to follow]
```

### ⚠️ Gotchas and Caveats (Battle-Tested Wisdom)
```yaml
Technical_Gotchas:
  - issue: [Specific technical challenge]
    impact: [How it affects implementation]
    mitigation: [How to handle or avoid it]
    source: [Where we learned this lesson]

Business_Considerations:
  - consideration: [Business constraint or requirement]
    impact: [How it affects the solution]
    accommodation: [How we address it in design]

Performance_Considerations:
  - concern: [Performance risk or limitation]
    impact: [Effect on user experience]
    optimization: [How to mitigate]
    measurement: [How to monitor in production]
```

---

## 🛠️ IMPLEMENTATION BLUEPRINT (Pseudocode with Critical Details)

### Progressive Success Phases (Start Simple → Validate → Enhance)

#### Phase 1: MVP (Minimum Viable Implementation)
```yaml
Scope: [Core functionality only - simplest working version]
Duration: [Estimated time]
Success_Criteria: [How we know Phase 1 is complete]
Risk_Level: Low

Key_Components:
  - component: [System component]
    description: [What it does in MVP]
    pseudocode: |
      // Simplified implementation approach
      function mvpImplementation() {
        // Core logic only
        return basicResult;
      }
    acceptance: [How we validate it works]

MVP_User_Stories:
  - "As a [user], I can [basic capability] so that [core benefit]"
  - "As a [user], I can [essential function] so that [primary value]"

Validation_Commands:
  - npm run lint && npm run type-check
  - npm run test:mvp
  - npm run build:mvp
```

#### Phase 2: Enhanced Features
```yaml
Scope: [Additional functionality and improvements]
Duration: [Estimated time]
Success_Criteria: [How we know Phase 2 is complete]
Risk_Level: Medium

Enhancement_Areas:
  - area: [Feature area to enhance]
    improvements: [Specific enhancements]
    pseudocode: |
      // Enhanced implementation
      function enhancedImplementation() {
        // Additional features and edge cases
        return improvedResult;
      }
    value: [Additional value delivered]

Enhanced_User_Stories:
  - "As a [user], I can [advanced capability] so that [enhanced benefit]"
  - "As a [user], I can [additional function] so that [expanded value]"

Validation_Commands:
  - npm run test:integration
  - npm run performance:check
  - npm run security:scan
```

#### Phase 3: Production Optimization
```yaml
Scope: [Performance, monitoring, and production readiness]
Duration: [Estimated time]
Success_Criteria: [Production readiness checklist complete]
Risk_Level: High

Production_Features:
  - Monitoring and alerting implementation
  - Performance optimization and tuning
  - Security hardening and compliance
  - Documentation and support materials

Production_Pseudocode: |
  // Production-ready implementation
  function productionImplementation() {
    // Includes monitoring, error handling, performance optimization
    try {
      const result = optimizedImplementation();
      monitoringService.trackSuccess(result);
      return result;
    } catch (error) {
      errorTrackingService.captureError(error);
      throw enhancedError;
    }
  }

Validation_Commands:
  - npm run test:e2e
  - npm run load-test
  - npm run security:audit
  - npm run deploy:staging
```

### Detailed Technical Implementation

#### Database Design
```yaml
Data_Models:
  - entity: [Data entity name]
    fields: [Key fields and types]
    relationships: [How it relates to other entities]
    indexes: [Required database indexes]
    pseudocode: |
      // Database schema pseudocode
      CREATE TABLE entity_name (
        id PRIMARY KEY,
        field1 TYPE,
        field2 TYPE
      );

Migration_Strategy:
  - step: [Migration step]
    description: [What changes]
    rollback: [How to reverse if needed]
    command: [Specific migration command]
```

#### API Design
```yaml
Endpoints:
  - method: [GET | POST | PUT | DELETE]
    path: [/api/endpoint/path]
    description: [What this endpoint does]
    pseudocode: |
      // API endpoint pseudocode
      app.post('/api/endpoint', async (req, res) => {
        // Validation, processing, response
        return processedData;
      });
    request: [Request format and validation]
    response: [Response format and status codes]
    authentication: [Auth requirements]

Error_Handling:
  - scenario: [Error condition]
    response: [How API responds]
    user_experience: [What user sees/experiences]
```

#### Frontend Implementation
```yaml
Components:
  - component: [Component name]
    purpose: [What it displays/handles]
    props: [Required props and types]
    pseudocode: |
      // Component pseudocode
      function ComponentName({ props }) {
        // State management and rendering logic
        return <UI>{renderedContent}</UI>;
      }
    state: [Internal state management]
    interactions: [User interactions handled]

State_Management:
  global_state: [What needs to be globally managed]
  local_state: [What stays component-local]
  data_flow: [How data moves between components]
```

### Task Lists with Critical Details
```yaml
Sprint_1_Tasks:
  - task: [Specific development task]
    estimate: [Time estimate]
    dependencies: [What must be done first]
    critical_details:
      - [Specific implementation detail that matters]
      - [Edge case to handle]
      - [Performance consideration]
    acceptance: [How we know it's complete]

Sprint_2_Tasks:
  - task: [Specific development task]
    estimate: [Time estimate]
    dependencies: [What must be done first]
    critical_details:
      - [Specific implementation detail that matters]
      - [Integration point to validate]
      - [Security consideration]
    acceptance: [How we know it's complete]
```

---

## ✅ VALIDATION LOOPS (Must be Executable)

### Level 1: Syntax & Style (Immediate)
```bash
# EXECUTABLE COMMANDS (Phase 1)
npm run lint                    # ESLint + Prettier
npm run type-check             # TypeScript compilation
npm run complexity-check       # Cyclomatic complexity < 10
npm run security-scan          # Static security analysis (eslint-plugin-security)

# SUCCESS CRITERIA: All commands exit with code 0
# TIME LIMIT: < 2 minutes
# AUTOMATION: Pre-commit hooks
```

### Level 2: Unit Testing (Per Story)
```bash
# EXECUTABLE COMMANDS (Phase 2)
npm run test -- --coverage --threshold=80    # Jest/Vitest with coverage
npm run test:performance                      # Performance budget validation
npm run test:integration:unit                # Component integration tests
npm run build                               # Verify build success

# SUCCESS CRITERIA: All tests pass, 80%+ coverage, build succeeds
# TIME LIMIT: < 10 minutes
# AUTOMATION: PR validation
```

### Level 3: Integration Testing (Per Epic)
```bash
# EXECUTABLE COMMANDS (Phase 3)
npm run test:integration                     # API endpoint testing
npm run test:database                       # Database operations validation
npm run test:e2e                           # End-to-end user workflows
npm run test:external-services             # Third-party integrations

# SUCCESS CRITERIA: All integration tests pass, no regressions
# TIME LIMIT: < 30 minutes
# AUTOMATION: Merge to main branch
```

### Level 4: Production Readiness (Pre-Deploy)
```bash
# EXECUTABLE COMMANDS (Phase 4)
npm run security:audit                      # SAST/DAST security scanning
npm run load-test                          # Performance under load
npm run compliance:check                   # Regulatory compliance validation
npm run monitoring:validate                # Monitoring and alerting setup
npm run deploy:staging                     # Staging deployment test
npm run smoke-test:staging                 # Post-deploy validation

# SUCCESS CRITERIA: All production checks pass
# TIME LIMIT: < 2 hours
# AUTOMATION: Production deployment pipeline
```

### Creative Self-Validation
```yaml
MCP_Servers: [Custom validation servers for domain-specific checks]
AI_Code_Review: [Automated code review using AI models]
Chaos_Engineering: [Fault injection and resilience testing]
A_B_Testing: [Feature flag and experimentation validation]
```

---

## 🚫 ANTI-PATTERNS TO AVOID (Battle-Tested Lessons)

```yaml
Context_Anti_Patterns:
  - "❌ DON'T create minimal context prompts"
    reason: "Context is everything - comprehensive context ensures one-pass success"
    instead: "Include ALL documentation, examples, and caveats"
  
  - "❌ DON'T skip context scoring validation"
    reason: "Context score < 190/200 leads to implementation gaps"
    instead: "Always validate context completeness before development"

Validation_Anti_Patterns:
  - "❌ DON'T skip validation steps"
    reason: "They're critical for one-pass success"
    instead: "Run all validation levels, fix failures immediately"
  
  - "❌ DON'T ignore the structured PRP format"
    reason: "Format is battle-tested for AI comprehension"
    instead: "Follow template structure religiously"

Implementation_Anti_Patterns:
  - "❌ DON'T start with complex implementation"
    reason: "Complex first attempts fail more often"
    instead: "Start simple (MVP), validate, then enhance"
  
  - "❌ DON'T hardcode values that should be configuration"
    reason: "Reduces flexibility and maintainability"
    instead: "Use environment variables and config files"
  
  - "❌ DON'T catch all exceptions generically"
    reason: "Masks specific error conditions"
    instead: "Handle specific exceptions with appropriate responses"

Process_Anti_Patterns:
  - "❌ DON'T create new patterns when existing ones work"
    reason: "Consistency is more valuable than novelty"
    instead: "Reuse proven patterns from codebase"
  
  - "❌ DON'T proceed with confidence score < 8/10"
    reason: "Low confidence leads to implementation failures"
    instead: "Improve context and research until confidence ≥ 8/10"
```

---

## 📊 CONFIDENCE SCORING RATIONALE

### Context Completeness Analysis
```yaml
Context_Score_Achieved: __/200 points

12_Dimension_Analysis:
  Business_Users_Context: __/15
    - User personas: [Complete/Partial/Missing]
    - Market analysis: [Complete/Partial/Missing]
    - Business case: [Complete/Partial/Missing]
  
  Technical_Architecture_Context: __/20
    - System architecture: [Complete/Partial/Missing]
    - Technology decisions: [Complete/Partial/Missing]
    - Integration points: [Complete/Partial/Missing]
  
  # [Continue for all 12 dimensions...]

Confidence_Impact: [How context completeness affects overall confidence]
Areas_Needing_Improvement: [Specific dimensions to strengthen]
```

### Research Depth Analysis
```yaml
Research_Quality_Assessment:
  Multi_Source_Validation: [How findings were cross-validated across sources]
  Primary_Research: [Direct user/market research conducted]
  Secondary_Research: [External documentation and competitive analysis]
  Internal_Research: [Codebase patterns and historical lessons]

Research_Sources:
  - source: [Research source 1]
    quality: [High | Medium | Low]
    relevance: [Direct/Indirect/Tangential]
    credibility: [First-party/Industry/Community]
    
  - source: [Research source 2]
    quality: [High | Medium | Low]
    relevance: [Direct/Indirect/Tangential]
    credibility: [First-party/Industry/Community]

Confidence_Impact: [How research depth affects overall confidence]
Research_Gaps: [Areas where additional research would improve confidence]
```

### Technical Clarity Analysis
```yaml
Architecture_Decision_Clarity:
  - decision: [Technical choice made]
    rationale: [Clear reasoning provided]
    alternatives: [Other options considered and rejected]
    confidence: [High | Medium | Low]
    documentation: [Fully documented/Partially/Unclear]

Implementation_Path_Clarity:
  - area: [Implementation area]
    clarity_level: [Crystal clear/Mostly clear/Some ambiguity/Very unclear]
    specific_gaps: [What specific details are missing]
    risk_level: [Low/Medium/High]

Confidence_Impact: [How technical clarity affects overall confidence]
Clarity_Improvement_Actions: [Specific steps to improve technical clarity]
```

---

## 🎯 FINAL CONFIDENCE ASSESSMENT

```yaml
Overall_Confidence: __/10

Confidence_Breakdown:
  Context_Completeness: __/10 (40% weight) = __/4.0 points
  Research_Depth: __/10 (30% weight) = __/3.0 points
  Technical_Clarity: __/10 (30% weight) = __/3.0 points

Ready_for_Development: [YES | NO | NEEDS_REVISION]

Development_Authorization:
  Minimum_Confidence_Met: [8.0+/10] ✅❌
  Context_Score_Met: [190+/200] ✅❌
  All_Validation_Commands_Identified: [YES/NO] ✅❌
  Progressive_Implementation_Planned: [YES/NO] ✅❌

If_Not_Ready_Improvement_Plan:
  Context_Improvements:
    - [Specific dimension needing work]
    - [Additional research required]
    - [Documentation gaps to fill]
  
  Research_Improvements:
    - [Additional sources to consult]
    - [User research to conduct]
    - [Technical validation needed]
  
  Technical_Improvements:
    - [Architecture decisions to clarify]
    - [Implementation details to specify]
    - [Risk mitigation to plan]

Next_Steps_if_Ready:
  1. [Load PRP and understand all context and requirements]
  2. [ULTRATHINK: Create comprehensive plan, break down into todos]
  3. [Execute Phase 1 (MVP) following the blueprint]
  4. [Run Level 1-2 validation commands, fix any failures]
  5. [Proceed to Phase 2 only after Phase 1 validation passes]

Next_Steps_if_Not_Ready:
  1. [Address specific improvement areas identified above]
  2. [Re-evaluate confidence score after improvements]
  3. [Repeat assessment until 8.0+/10 confidence achieved]
```

---

## 📈 SUCCESS METRICS TRACKING

```yaml
Implementation_Success_Metrics:
  One_Pass_Success_Rate: [Target: >90% of features implemented correctly on first attempt]
  Context_Utilization_Score: [How well implementation followed PRP context]
  Validation_Pass_Rate: [% of validation levels passed on first run]
  Progressive_Success_Adherence: [How well MVP→Enhanced→Production was followed]

Business_Impact_Metrics:
  User_Adoption_Rate: [Actual vs predicted user adoption]
  Performance_Against_Goals: [Achievement vs success metrics defined above]
  Development_Velocity: [Time to market vs estimates]
  Quality_Indicators: [Bug reports, user satisfaction, performance metrics]

Continuous_Improvement_Metrics:
  PRP_Template_Effectiveness: [How often template leads to successful outcomes]
  Anti_Pattern_Avoidance: [Frequency of known anti-patterns in implementations]
  Context_Score_Correlation: [Relationship between context score and success rate]
  Confidence_Score_Accuracy: [How well confidence predicts actual success]
```

---

**DevMethod 2.0 PRP Template - WIRASM-Enhanced Engineering-First AI-Amplified Development**  
**"Context is King + Validation Loops + Progressive Success = One-Pass Implementation Success"**  
**Minimum Confidence Required: 8/10 for development authorization**