# DevMethod: Product Requirement Prompt (PRP) - Scored Template

**Version**: 1.0  
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

## 📋 GOAL (What we want to achieve)

### Primary Objective
<!-- Specific, measurable end state -->

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

## 🎯 WHY (Business value and impact)

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

### Market Opportunity
<!-- Competitive advantage and market positioning -->

---

## 🔧 WHAT (Visible behavior and technical requirements)

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

## 📚 ALL NEEDED CONTEXT

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
    
  - name: [Framework/Tool name]
    url: [Documentation URL]
    relevance: [How it applies to our solution]

Internal_Documentation:
  - document: [Existing internal doc]
    location: [File path or URL]
    relevance: [How it informs this solution]
```

### 💡 Examples and Patterns
```yaml
Code_Examples:
  - pattern: [Code pattern name]
    example: |
      # Relevant code example showing the pattern
      function exampleImplementation() {
        // Implementation details
      }
    usage: [When and how to use this pattern]

Reference_Implementations:
  - name: [Similar feature in codebase]
    location: [File path]
    lessons: [What we learned from this implementation]
```

### ⚠️ Gotchas and Considerations
```yaml
Technical_Gotchas:
  - issue: [Specific technical challenge]
    impact: [How it affects implementation]
    mitigation: [How to handle or avoid it]

Business_Considerations:
  - consideration: [Business constraint or requirement]
    impact: [How it affects the solution]
    accommodation: [How we address it in design]

Performance_Considerations:
  - concern: [Performance risk or limitation]
    impact: [Effect on user experience]
    optimization: [How to mitigate]
```

---

## 🛠️ IMPLEMENTATION BLUEPRINT

### Progressive Implementation Strategy

#### Phase 1: MVP (Minimum Viable Product)
```yaml
Scope: [Core functionality only]
Duration: [Estimated time]
Success_Criteria: [How we know Phase 1 is complete]

Key_Components:
  - component: [System component]
    description: [What it does in MVP]
    acceptance: [How we validate it works]

MVP_User_Stories:
  - "As a [user], I can [basic capability] so that [core benefit]"
  - "As a [user], I can [essential function] so that [primary value]"
```

#### Phase 2: Enhanced Features
```yaml
Scope: [Additional functionality and polish]
Duration: [Estimated time]
Success_Criteria: [How we know Phase 2 is complete]

Enhancement_Areas:
  - area: [Feature area to enhance]
    improvements: [Specific enhancements]
    value: [Additional value delivered]

Enhanced_User_Stories:
  - "As a [user], I can [advanced capability] so that [enhanced benefit]"
  - "As a [user], I can [additional function] so that [expanded value]"
```

#### Phase 3: Production Optimization
```yaml
Scope: [Performance, monitoring, and production readiness]
Duration: [Estimated time]
Success_Criteria: [Production readiness checklist complete]

Production_Features:
  - Monitoring and alerting implementation
  - Performance optimization and tuning
  - Security hardening and compliance
  - Documentation and support materials
```

### Technical Implementation Plan

#### Database Design
```yaml
Data_Models:
  - entity: [Data entity name]
    fields: [Key fields and types]
    relationships: [How it relates to other entities]
    indexes: [Required database indexes]

Migration_Strategy:
  - step: [Migration step]
    description: [What changes]
    rollback: [How to reverse if needed]
```

#### API Design
```yaml
Endpoints:
  - method: [GET | POST | PUT | DELETE]
    path: [/api/endpoint/path]
    description: [What this endpoint does]
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
    state: [Internal state management]
    interactions: [User interactions handled]

State_Management:
  global_state: [What needs to be globally managed]
  local_state: [What stays component-local]
  data_flow: [How data moves between components]
```

#### Security Implementation
```yaml
Authentication_Flow:
  1: [Step 1 of auth process]
  2: [Step 2 of auth process]  
  3: [Step 3 of auth process]

Data_Protection:
  - data_type: [Type of sensitive data]
    protection: [How it's protected]
    access_control: [Who can access it]
```

### Development Task Breakdown
```yaml
Sprint_1_Tasks:
  - task: [Specific development task]
    estimate: [Time estimate]
    dependencies: [What must be done first]
    acceptance: [How we know it's complete]

Sprint_2_Tasks:
  - task: [Specific development task]
    estimate: [Time estimate]
    dependencies: [What must be done first]  
    acceptance: [How we know it's complete]

# Continue for additional sprints...
```

---

## ✅ VALIDATION LOOP

### Level 1: Syntax & Style Validation
```yaml
Automated_Checks:
  linting: [ESLint, Prettier, language-specific tools]
  complexity: [Cyclomatic < 10, Function < 50 lines]
  security: [SAST tools, secret detection]
  dependencies: [Vulnerability scanning]

Success_Criteria: All automated checks pass before code review
```

### Level 2: Unit Testing Validation  
```yaml
Test_Requirements:
  coverage: [≥80% line coverage]
  test_cases: [All edge cases covered]
  performance: [Performance budgets met]
  mocking: [External dependencies properly mocked]

Test_Framework: [Jest, Vitest, Pytest, JUnit, etc.]
Success_Criteria: All unit tests pass, coverage threshold met
```

### Level 3: Integration Testing Validation
```yaml
Integration_Scope:
  api_testing: [All endpoints tested with real data]
  database_testing: [Migrations and queries validated]
  external_integration: [Third-party services tested]
  end_to_end: [Complete user workflows validated]

Success_Criteria: All integration tests pass, no regression detected
```

### Level 4: Production Readiness Validation
```yaml
Security_Validation:
  sast_dast: [Static and dynamic security testing]
  penetration_testing: [Security vulnerability assessment]
  compliance_check: [Regulatory requirement validation]

Performance_Validation:
  load_testing: [Expected load handling confirmed]
  stress_testing: [Breaking point identified]
  monitoring: [Observability stack operational]

Operational_Validation:
  documentation: [Complete and accurate]
  runbooks: [Support procedures ready]
  rollback: [Rollback procedures tested]

Success_Criteria: All production readiness checks pass
```

### Quality Gates
```yaml
Gate_1_Commit:
  trigger: [Every code commit]
  validation: [Level 1 - Syntax & Style]
  time_limit: [< 2 minutes]
  action_on_failure: [Block commit]

Gate_2_PR:
  trigger: [Pull request creation]
  validation: [Level 2 - Unit Testing]
  time_limit: [< 10 minutes]
  action_on_failure: [Block merge]

Gate_3_Merge:
  trigger: [PR merge to main branch]
  validation: [Level 3 - Integration Testing]
  time_limit: [< 30 minutes]
  action_on_failure: [Rollback merge]

Gate_4_Deploy:
  trigger: [Production deployment]
  validation: [Level 4 - Production Readiness]
  time_limit: [< 2 hours]
  action_on_failure: [Rollback deployment]
```

### Continuous Monitoring
```yaml
Business_Metrics:
  - metric: [User adoption rate]
    target: [Expected growth rate]
    monitoring: [How and when measured]
    
  - metric: [Feature usage]
    target: [Usage threshold]
    monitoring: [Analytics and reporting]

Technical_Metrics:
  - metric: [Response time]
    target: [Performance budget]
    monitoring: [APM tools and alerts]
    
  - metric: [Error rate]
    target: [< X% error rate]
    monitoring: [Error tracking and alerting]

User_Experience_Metrics:
  - metric: [User satisfaction]
    target: [Rating threshold]
    monitoring: [Surveys and feedback]
```

---

## 📊 CONFIDENCE SCORING RATIONALE

### Context Completeness Analysis
```yaml
Context_Score_Achieved: __/200 points
Breakdown:
  - Business context: Complete user personas and market analysis
  - Technical context: Full architecture and integration documented
  - [Continue for all 12 dimensions...]

Confidence_Impact: [How context completeness affects confidence score]
```

### Research Depth Analysis
```yaml
Research_Sources:
  - source: [Research source 1]
    quality: [High | Medium | Low]
    relevance: [How relevant to our solution]
    
  - source: [Research source 2]
    quality: [High | Medium | Low] 
    relevance: [How relevant to our solution]

Multi_Source_Validation: [How findings were cross-validated]
Confidence_Impact: [How research depth affects confidence score]
```

### Technical Clarity Analysis
```yaml
Architecture_Decisions:
  - decision: [Technical choice made]
    rationale: [Why this choice]
    alternatives: [Other options considered]
    confidence: [High | Medium | Low]

Implementation_Clarity:
  - area: [Implementation area]
    clarity_level: [How well-defined it is]
    remaining_ambiguity: [What's still unclear]

Confidence_Impact: [How technical clarity affects confidence score]
```

---

## 🎯 FINAL CONFIDENCE ASSESSMENT

```yaml
Overall_Confidence: __/10

Ready_for_Development: [YES | NO | NEEDS_REVISION]

If_Not_Ready_Areas_to_Improve:
  - [Specific area needing more work]
  - [Another area requiring clarification]
  - [Additional research or context needed]

Next_Steps:
  - [Immediate action item 1]
  - [Immediate action item 2] 
  - [Validation step needed]
```

---

**DevMethod PRP Template v1.0 - Engineering-First AI-Amplified Development**  
**Minimum Confidence Required: 8/10 for development authorization**