# DevMethod: Context Gathering Template (12 Dimensiones)

**Versión**: 1.0  
**Proyecto**: [NOMBRE_PROYECTO]  
**Fecha**: [FECHA]  
**Responsable**: [NOMBRE]  

---

## 🎯 INSTRUCCIONES DE USO

1. **Completa TODAS las secciones** - Mínimo 190/200 puntos requerido
2. **Sé específico** - Evita generalidades, usa ejemplos concretos
3. **Documenta fuentes** - Incluye URLs, referencias, y evidencia
4. **Valida constantemente** - Usa el scoring para medir progreso
5. **Itera hasta completar** - No procedas con score <190

---

## **1. BUSINESS & USERS CONTEXT** ⭐ (15 puntos)

### 1.1 User Personas (Requerido)
```yaml
Persona_1:
  name: [Nombre específico]
  age: [Edad]
  role: [Rol/Job title]
  context: [Cuándo/dónde usa el producto]
  pain_points: [3+ problemas específicos que resolvemos]
  tech_comfort: [Nivel técnico 1-10]
  goals: [Qué quiere lograr]

Persona_2:
  name: [Nombre específico]
  age: [Edad]
  role: [Rol/Job title]
  context: [Cuándo/dónde usa el producto]
  pain_points: [3+ problemas específicos que resolvemos]
  tech_comfort: [Nivel técnico 1-10]
  goals: [Qué quiere lograr]

# Añadir más personas si es necesario
```

### 1.2 Business Value & ROI (Requerido)
```yaml
Primary_Problem: [Problema específico que resolvemos]
Current_Solution: [Cómo lo resuelven ahora]
Our_Solution_Advantage: [Por qué somos mejores]

ROI_Metrics:
  Cost_Savings: [$ específico ahorrado]
  Time_Savings: [Horas/día ahorradas por usuario]
  Revenue_Impact: [$ adicional generado]
  Efficiency_Gain: [% mejora en eficiencia]

Success_Metrics:
  - [Métrica medible 1]
  - [Métrica medible 2] 
  - [Métrica medible 3]
```

### 1.3 Competitive Analysis (Requerido)
```yaml
Competitor_1:
  name: [Nombre]
  url: [Website/app]
  strengths: [Qué hacen bien]
  weaknesses: [Dónde fallan]
  pricing: [Modelo de precios]
  our_advantage: [Por qué somos mejores]

Competitor_2:
  name: [Nombre]
  url: [Website/app]
  strengths: [Qué hacen bien]
  weaknesses: [Dónde fallan]
  pricing: [Modelo de precios]
  our_advantage: [Por qué somos mejores]

Competitor_3:
  name: [Nombre]
  url: [Website/app]
  strengths: [Qué hacen bien]
  weaknesses: [Dónde fallan]
  pricing: [Modelo de precios]
  our_advantage: [Por qué somos mejores]
```

### 1.4 Constraints & Resources (Requerido)
```yaml
Budget:
  total_budget: $[Cantidad específica]
  development_budget: $[Para desarrollo]
  infrastructure_budget: $[Para hosting/tools]
  marketing_budget: $[Para lanzamiento]

Timeline:
  mvp_deadline: [Fecha específica]
  beta_launch: [Fecha específica]
  production_launch: [Fecha específica]
  non_negotiable_deadline: [Fecha límite]

Team:
  available_developers: [Número y skills]
  designer_access: [Sí/No, interno/externo]
  pm_support: [Nivel de support disponible]
  stakeholder_availability: [Para reviews/feedback]

Legal_Compliance:
  - [Regulación 1 si aplica]
  - [Regulación 2 si aplica]
  - [Restricción legal específica]
```

**Scoring Sección 1**: ___ / 15 puntos

---

## **2. TECHNICAL ARCHITECTURE CONTEXT** ⚒️ (20 puntos)

### 2.1 Current Tech Stack (Requerido)
```yaml
Frontend:
  framework: [React 18.x, Vue 3.x, etc.]
  version: [Versión específica]
  state_management: [Redux, Zustand, Context API]
  styling: [TailwindCSS, Styled Components, CSS Modules]
  build_tools: [Vite, Webpack, etc.]

Backend:
  language: [Node.js, Python, Java, etc.]
  version: [Versión específica]
  framework: [Express, FastAPI, Spring Boot]
  database: [PostgreSQL 15, MongoDB 6.x]
  orm: [Prisma, SQLAlchemy, etc.]

Infrastructure:
  hosting: [AWS, GCP, Azure, Vercel]
  containerization: [Docker, none]
  orchestration: [Kubernetes, none]
  ci_cd: [GitHub Actions, Jenkins, none]

Development:
  ide_primary: [VS Code, WebStorm, etc.]
  version_control: [Git + GitHub/GitLab]
  package_manager: [npm, yarn, pnpm]
  testing_framework: [Jest, Vitest, Pytest]
```

### 2.2 Architecture Patterns (Requerido)
```yaml
Overall_Architecture: [Monolith, Microservices, Serverless, JAMstack]
Frontend_Pattern: [SPA, MPA, SSG, SSR]
Backend_Pattern: [REST, GraphQL, tRPC]
Database_Pattern: [Relational, NoSQL, Hybrid]
Authentication: [JWT, Session, OAuth, Auth0]

Communication:
  api_style: [REST, GraphQL, tRPC]
  real_time: [WebSockets, SSE, polling, none]
  file_uploads: [Direct, S3, CloudStorage]
  notifications: [Email, SMS, Push, none]
```

### 2.3 Integration Points (Requerido)
```yaml
External_APIs:
  - name: [API Name]
    purpose: [Para qué la usamos]
    documentation: [URL de docs]
    rate_limits: [Limits específicos]
    authentication: [Tipo de auth]

Internal_Services:
  - name: [Service name]
    purpose: [Función]
    endpoint: [URL/connection]
    dependencies: [De qué depende]

Third_Party_Integrations:
  - service: [Stripe, PayPal, etc.]
    purpose: [Payments, analytics, etc.]
    configuration_needed: [API keys, webhooks, etc.]
```

### 2.4 Performance Requirements (Requerido)
```yaml
Performance_Budgets:
  page_load_time: [< 2 seconds]
  api_response_time: [< 200ms]
  bundle_size: [< 500KB initial]
  lighthouse_score: [> 90]

Scalability_Requirements:
  concurrent_users: [Número esperado]
  requests_per_second: [Peak load]
  data_growth_rate: [GB/month estimated]
  geographic_distribution: [Regions to serve]
```

### 2.5 Technical Constraints (Requerido)
```yaml
Legacy_Systems:
  - system: [System name]
    constraint: [What we must maintain]
    integration_method: [How to integrate]

Technical_Debt:
  - area: [Code area]
    issue: [Specific problem]
    impact: [Performance, maintainability, etc.]
    priority: [High, Medium, Low]

Team_Constraints:
  - skill_gaps: [Technologies team doesn't know]
  - learning_budget: [Time available for learning]
  - preference_strong: [Technologies team prefers]
  - preference_avoid: [Technologies to avoid]
```

**Scoring Sección 2**: ___ / 20 puntos

---

## **3. FUNCTIONAL REQUIREMENTS CONTEXT** 🎯 (20 puntos)

### 3.1 Core Features (Requerido)
```yaml
Feature_1:
  name: [Feature name]
  description: [Detailed description]
  user_story: "As a [user], I want [capability], so that [benefit]"
  acceptance_criteria:
    - [Criteria 1]
    - [Criteria 2]
    - [Criteria 3]
  priority: [High, Medium, Low]
  complexity: [1-10 scale]

Feature_2:
  name: [Feature name]
  description: [Detailed description]
  user_story: "As a [user], I want [capability], so that [benefit]"
  acceptance_criteria:
    - [Criteria 1]
    - [Criteria 2]
    - [Criteria 3]
  priority: [High, Medium, Low]
  complexity: [1-10 scale]

# Continue for 5+ core features
```

### 3.2 User Journeys (Requerido)
```yaml
Journey_1_Happy_Path:
  name: [Journey name - e.g., "User Registration"]
  steps:
    1. [User action]
    2. [System response]
    3. [User action]
    4. [System response]
    # Continue step by step
  expected_outcome: [What should happen]

Journey_1_Edge_Cases:
  - case: [Edge case scenario]
    steps: [How it differs]
    expected_behavior: [How system should handle]
  - case: [Edge case scenario]
    steps: [How it differs]
    expected_behavior: [How system should handle]
```

### 3.3 Business Rules & Validation (Requerido)
```yaml
Business_Rules:
  - rule: [Specific business rule]
    applies_to: [Feature/area]
    logic: [If X then Y]
    exceptions: [When rule doesn't apply]

Validation_Logic:
  - field: [Form field/data]
    rules: [Validation rules]
    error_messages: [User-friendly messages]
    server_validation: [Yes/No and logic]
```

### 3.4 UI/UX Requirements (Requerido)
```yaml
Design_System:
  colors_primary: [Hex codes]
  colors_secondary: [Hex codes]
  fonts: [Font families]
  spacing_scale: [4px, 8px, 16px, etc.]
  component_library: [MUI, Chakra UI, custom]

Wireframes:
  - page: [Page name]
    wireframe_url: [URL to wireframe/mockup]
    key_elements: [List of important UI elements]

Responsive_Breakpoints:
  mobile: [< 768px]
  tablet: [768px - 1024px]
  desktop: [> 1024px]
  behavior: [How layout changes]

Accessibility:
  wcag_level: [AA compliance required]
  screen_reader: [Support required - Yes/No]
  keyboard_navigation: [Full support required]
  color_contrast: [Minimum ratio required]
```

**Scoring Sección 3**: ___ / 20 puntos

---

## **4. QUALITY & TESTING CONTEXT** ✅ (15 puntos)

### 4.1 Testing Strategy (Requerido)
```yaml
Unit_Testing:
  framework: [Jest, Vitest, Pytest, etc.]
  coverage_target: [80%+]
  areas_critical: [Functions/components that must be tested]
  mock_strategy: [How to handle external dependencies]

Integration_Testing:
  framework: [Cypress, Playwright, pytest, etc.]
  scope: [API endpoints, user workflows, etc.]
  test_data: [How to handle test data]
  environments: [Where to run integration tests]

End_to_End_Testing:
  framework: [Cypress, Playwright, Selenium]
  critical_paths: [User journeys that must work]
  browser_matrix: [Chrome, Firefox, Safari, etc.]
  device_testing: [Mobile, tablet, desktop]
```

### 4.2 Quality Gates (Requerido)
```yaml
Code_Quality:
  linting: [ESLint, Flake8, etc.]
  formatting: [Prettier, Black, etc.]
  complexity_limit: [Cyclomatic complexity < 10]
  duplication_limit: [< 3% code duplication]

Performance_Budgets:
  page_load: [< 2 seconds]
  bundle_size: [< 500KB gzipped]
  lighthouse_mobile: [> 85]
  lighthouse_desktop: [> 90]

Security_Standards:
  dependency_scanning: [Automated vulnerability checks]
  code_analysis: [SAST tools]
  secret_detection: [No secrets in code]
  auth_requirements: [Security measures required]
```

### 4.3 Acceptance Criteria Framework (Requerido)
```yaml
Definition_of_Ready:
  - [Requirement clearly defined]
  - [Acceptance criteria written]
  - [Dependencies identified]
  - [Design mockups available]

Definition_of_Done:
  - [Code written and reviewed]
  - [Tests written and passing]
  - [Documentation updated]
  - [Performance validated]
  - [Security reviewed]
  - [Deployed to staging]
  - [Stakeholder approved]
```

**Scoring Sección 4**: ___ / 15 puntos

---

## **5. DEPENDENCIES & INTEGRATIONS CONTEXT** 🔗 (10 puntos)

### 5.1 External APIs (Requerido)
```yaml
API_1:
  name: [API name]
  purpose: [What it's used for]
  documentation: [URL]
  authentication: [API key, OAuth, etc.]
  rate_limits: [Requests per minute/hour]
  pricing: [Cost structure]
  reliability: [SLA/uptime requirements]

API_2:
  name: [API name]
  purpose: [What it's used for]
  documentation: [URL]
  authentication: [API key, OAuth, etc.]
  rate_limits: [Requests per minute/hour]
  pricing: [Cost structure]
  reliability: [SLA/uptime requirements]
```

### 5.2 Third-Party Services (Requerido)
```yaml
Payment_Provider:
  service: [Stripe, PayPal, Square]
  features_needed: [One-time payments, subscriptions, etc.]
  integration_complexity: [Simple, moderate, complex]
  compliance_requirements: [PCI DSS, etc.]

Analytics:
  service: [Google Analytics, Mixpanel, etc.]
  events_to_track: [List of important events]
  privacy_considerations: [GDPR compliance, etc.]

Email_Service:
  provider: [SendGrid, Mailgun, etc.]
  volume_expected: [Emails per month]
  template_requirements: [Transactional, marketing]

File_Storage:
  provider: [AWS S3, Cloudinary, etc.]
  storage_needs: [GB/month estimated]
  file_types: [Images, documents, etc.]
  cdn_requirements: [Global delivery needed]
```

### 5.3 Environment Configuration (Requerido)
```yaml
Environment_Variables:
  development:
    - name: [VAR_NAME]
      purpose: [What it configures]
      example_value: [Example (not real secrets)]
  
  production:
    - name: [VAR_NAME]
      purpose: [What it configures]
      security_level: [Public, secret, restricted]

Configuration_Management:
  secrets_storage: [AWS Secrets, Azure Key Vault, etc.]
  config_deployment: [How config gets to production]
  environment_parity: [How to keep dev/prod similar]
```

**Scoring Sección 5**: ___ / 10 puntos

---

## **6. DATA & STATE CONTEXT** 📊 (10 puntos)

### 6.1 Data Models (Requerido)
```yaml
Entity_1:
  name: [Entity name - e.g., User]
  fields:
    - name: [field name]
      type: [string, integer, etc.]
      required: [true/false]
      validation: [Rules]
  relationships:
    - related_to: [Other entity]
      type: [one-to-many, many-to-many]

Entity_2:
  name: [Entity name]
  fields:
    - name: [field name]
      type: [string, integer, etc.]
      required: [true/false]
      validation: [Rules]
  relationships:
    - related_to: [Other entity]
      type: [one-to-many, many-to-many]
```

### 6.2 State Management (Requerido)
```yaml
Client_State:
  approach: [Context API, Redux, Zustand, etc.]
  global_state: [What needs to be global]
  local_state: [What stays component-local]
  persistence: [localStorage, sessionStorage, none]

Server_State:
  caching_strategy: [React Query, SWR, etc.]
  invalidation_strategy: [How to refresh stale data]
  offline_support: [Required - Yes/No]
  real_time_updates: [WebSockets, polling, etc.]
```

### 6.3 Database Design (Requerido)
```yaml
Database_Choice: [PostgreSQL, MongoDB, etc.]
Database_Version: [Specific version]
Schema_Migrations: [How to handle schema changes]
Indexing_Strategy: [What fields to index]
Backup_Strategy: [How often, where stored]

Performance_Considerations:
  expected_records: [Rough scale per table]
  query_patterns: [Common queries to optimize]
  partitioning_needs: [If data will be partitioned]
```

**Scoring Sección 6**: ___ / 10 puntos

---

## **7. EXPERIENCE & PATTERNS CONTEXT** 🧠 (10 puntos)

### 7.1 Existing Codebase Patterns (Si Aplica)
```yaml
Code_Organization:
  folder_structure: [How code is organized]
  naming_conventions: [File and variable naming]
  import_patterns: [How modules are imported]
  component_patterns: [How components are structured]

Architecture_Patterns:
  design_patterns: [Patterns currently used]
  anti_patterns: [Patterns to avoid]
  code_style: [ESLint rules, style guides]
  documentation_style: [How code is documented]
```

### 7.2 Team Experience (Requerido)
```yaml
Team_Skills:
  frontend_experience: [Years of experience, technologies]
  backend_experience: [Years of experience, technologies]
  devops_experience: [CI/CD, containerization, etc.]
  design_skills: [UI/UX capabilities]

Learning_Capacity:
  time_for_learning: [Hours/week available]
  preferred_learning: [Docs, tutorials, courses]
  technology_comfort: [Willingness to try new tech]
  knowledge_gaps: [Skills team needs to develop]
```

### 7.3 Previous Lessons (Requerido)
```yaml
Previous_Projects:
  - project: [Similar project name]
    what_worked: [Successful practices]
    what_failed: [Problems encountered]
    lessons_learned: [Key takeaways]

Technical_Debt:
  - area: [Code area]
    problem: [Specific issue]
    root_cause: [Why it happened]
    prevention: [How to avoid this time]

Best_Practices:
  - practice: [Best practice to follow]
    reason: [Why it's important]
    implementation: [How to implement]
```

**Scoring Sección 7**: ___ / 10 puntos

---

## **8. INFRASTRUCTURE & DEPLOYMENT CONTEXT** 🏗️ (20 puntos)

### 8.1 Containerization Strategy (Requerido)
```yaml
Container_Approach: [Docker, none]
Orchestration: [Kubernetes, Docker Compose, none]

Docker_Requirements:
  base_images: [node:18-alpine, python:3.11-slim, etc.]
  multi_stage: [Required for optimization - Yes/No]
  registry: [Docker Hub, AWS ECR, etc.]
  security_scanning: [Required - Yes/No]

Kubernetes_Requirements: # If using K8s
  cluster_type: [Managed service, self-hosted]
  scaling_needs: [Auto-scaling required - Yes/No]
  resource_limits: [Memory, CPU requirements]
  networking: [Ingress, service mesh needs]
```

### 8.2 CI/CD Pipeline (Requerido)
```yaml
Pipeline_Platform: [GitHub Actions, Jenkins, GitLab CI, etc.]

Pipeline_Stages:
  1: [Lint and format check]
  2: [Unit tests]
  3: [Build application]
  4: [Integration tests]
  5: [Security scanning]
  6: [Deploy to staging]
  7: [E2E tests on staging]
  8: [Deploy to production]

Deployment_Strategy:
  type: [Rolling, blue-green, canary]
  rollback_plan: [How to revert if issues]
  approval_process: [Manual approval required - Yes/No]
  
Environments:
  development:
    auto_deploy: [On every commit - Yes/No]
    testing: [Automated testing - Yes/No]
  staging:
    auto_deploy: [On PR merge - Yes/No]
    approval_required: [Yes/No]
  production:
    approval_required: [Yes/No]
    rollback_time: [< 5 minutes target]
```

### 8.3 Cloud Infrastructure (Requerido)
```yaml
Cloud_Provider: [AWS, GCP, Azure, etc.]
Region: [Primary region for deployment]
Multi_Region: [Required for disaster recovery - Yes/No]

Core_Services:
  compute: [EC2, Cloud Run, App Service, etc.]
  database: [RDS, Cloud SQL, CosmosDB, etc.]
  storage: [S3, Cloud Storage, Blob Storage, etc.]
  networking: [VPC, Load Balancers, CDN, etc.]

Infrastructure_as_Code:
  tool: [Terraform, CloudFormation, Pulumi, none]
  repository: [Where IaC code will be stored]
  automation: [How infrastructure changes are deployed]
```

### 8.4 Monitoring & Observability (Requerido)
```yaml
Application_Monitoring:
  apm_tool: [New Relic, DataDog, Application Insights, etc.]
  metrics_collected: [Response time, error rate, throughput, etc.]
  alerting: [When to alert and how]

Infrastructure_Monitoring:
  tool: [CloudWatch, Stackdriver, Azure Monitor, etc.]
  metrics: [CPU, memory, disk, network]
  thresholds: [When to alert]

Logging:
  centralized_logging: [ELK Stack, Splunk, etc.]
  log_levels: [Debug, info, warn, error]
  log_retention: [How long to keep logs]
  
Dashboards:
  business_metrics: [User signups, revenue, etc.]
  technical_metrics: [Performance, errors, etc.]
  real_time_monitoring: [Required - Yes/No]
```

**Scoring Sección 8**: ___ / 20 puntos

---

## **9. SECURITY & COMPLIANCE CONTEXT** 🔐 (20 puntos)

### 9.1 Security Framework (Requerido)
```yaml
Security_Standards: [OWASP Top 10 compliance required]
Security_Testing:
  sast_tool: [SonarQube, Snyk, etc.]
  dast_tool: [OWASP ZAP, Burp Suite, etc.]
  dependency_scanning: [Automated vulnerability checks]
  penetration_testing: [Required - Yes/No, frequency]

Threat_Model:
  - threat: [Specific security threat]
    likelihood: [High, Medium, Low]
    impact: [High, Medium, Low]
    mitigation: [How to prevent/detect]
```

### 9.2 Authentication & Authorization (Requerido)
```yaml
Authentication:
  method: [JWT, Session-based, OAuth, etc.]
  providers: [Auth0, Firebase Auth, AWS Cognito, custom]
  mfa_required: [Yes/No]
  password_policy: [Length, complexity requirements]
  session_management: [Timeout, refresh strategy]

Authorization:
  model: [RBAC, ABAC, simple roles]
  roles: [List of user roles and permissions]
  resource_protection: [How to protect sensitive resources]
  api_security: [Rate limiting, API keys, etc.]
```

### 9.3 Data Protection (Requerido)
```yaml
Data_Classification:
  public: [Data that can be public]
  internal: [Data for internal use only]
  confidential: [Sensitive data requiring protection]
  restricted: [Highly sensitive data]

Encryption:
  data_at_rest: [Database encryption required]
  data_in_transit: [HTTPS/TLS requirements]
  key_management: [How encryption keys are managed]
  
Privacy:
  pii_handling: [How personal data is handled]
  data_retention: [How long to keep user data]
  deletion_process: [How users can delete their data]
  consent_management: [How to track user consent]
```

### 9.4 Compliance Requirements (Requerido)
```yaml
Regulatory_Compliance:
  gdpr: [Required - Yes/No]
  ccpa: [Required - Yes/No]
  hipaa: [Required - Yes/No]
  sox: [Required - Yes/No]
  other: [Other specific regulations]

Compliance_Measures:
  - requirement: [Specific compliance requirement]
    implementation: [How we'll meet it]
    validation: [How we'll verify compliance]
    documentation: [What records we need to keep]

Audit_Requirements:
  audit_logging: [What actions need to be logged]
  access_controls: [Who can access what]
  change_management: [How changes are tracked]
  incident_response: [How to respond to security incidents]
```

**Scoring Sección 9**: ___ / 20 puntos

---

## **10. PERFORMANCE & SCALABILITY CONTEXT** ⚡ (15 puntos)

### 10.1 Performance Budgets (Requerido)
```yaml
Frontend_Performance:
  first_contentful_paint: [< 1.5 seconds]
  largest_contentful_paint: [< 2.5 seconds]
  cumulative_layout_shift: [< 0.1]
  first_input_delay: [< 100ms]
  
Backend_Performance:
  api_response_time: [95th percentile < 200ms]
  database_query_time: [95th percentile < 100ms]
  file_upload_time: [< 5 seconds for 10MB]
  
Network_Performance:
  bundle_size: [Initial load < 500KB gzipped]
  image_optimization: [WebP format, lazy loading]
  cdn_usage: [Static assets served from CDN]
```

### 10.2 Load Testing Strategy (Requerido)
```yaml
Load_Testing_Tool: [K6, JMeter, Artillery, etc.]
Test_Scenarios:
  - name: [Test scenario name]
    description: [What this test simulates]
    concurrent_users: [Number of simultaneous users]
    duration: [How long test runs]
    success_criteria: [Response time, error rate thresholds]

Performance_Testing:
  baseline_testing: [Establish current performance]
  stress_testing: [Find breaking point]
  spike_testing: [Handle sudden traffic increases]
  volume_testing: [Handle large amounts of data]
```

### 10.3 Caching Strategy (Requerido)
```yaml
Browser_Caching:
  static_assets: [Cache duration for CSS/JS/images]
  api_responses: [Which APIs should be cached]
  cache_invalidation: [How to bust cache when needed]

Server_Caching:
  redis: [Required - Yes/No, what to cache]
  application_cache: [In-memory caching strategy]
  database_cache: [Query result caching]

CDN_Strategy:
  provider: [CloudFlare, AWS CloudFront, etc.]
  global_distribution: [Regions to cover]
  cache_rules: [What content gets cached where]
```

### 10.4 Scalability Planning (Requerido)
```yaml
Growth_Projections:
  current_users: [Starting number of users]
  year_1_target: [Expected users after 1 year]
  year_3_target: [Expected users after 3 years]
  peak_traffic: [Expected peak concurrent users]

Scaling_Strategy:
  horizontal_scaling: [Add more servers - Yes/No]
  vertical_scaling: [Upgrade server resources - Yes/No]
  database_scaling: [Read replicas, sharding, etc.]
  auto_scaling: [Automatic scaling based on metrics]

Bottleneck_Analysis:
  - component: [System component]
    bottleneck_at: [Number of users/requests]
    scaling_solution: [How to scale this component]
    monitoring: [How to detect when scaling is needed]
```

**Scoring Sección 10**: ___ / 15 puntos

---

## **11. MAINTENANCE & SUPPORT CONTEXT** 🔧 (15 puntos)

### 11.1 Logging & Debugging (Requerido)
```yaml
Logging_Strategy:
  log_levels: [DEBUG, INFO, WARN, ERROR]
  structured_logging: [JSON format required - Yes/No]
  centralized_logging: [ELK, Splunk, CloudWatch, etc.]
  
Log_Categories:
  - category: [Application errors]
    what_to_log: [Error details, stack trace, user context]
    retention: [How long to keep these logs]
  - category: [User actions]
    what_to_log: [Important user actions for analytics]
    retention: [How long to keep these logs]
  - category: [Performance metrics]
    what_to_log: [Response times, database queries, etc.]
    retention: [How long to keep these logs]

Debugging_Tools:
  development: [Browser dev tools, debugger, etc.]
  staging: [Log analysis, performance profilers, etc.]
  production: [Error tracking, APM tools, etc.]
```

### 11.2 Error Handling & Recovery (Requerido)
```yaml
Error_Handling_Strategy:
  user_facing_errors: [How to show errors to users]
  error_boundaries: [How to prevent app crashes]
  retry_logic: [When and how to retry failed operations]
  fallback_behavior: [What to do when services are down]

Error_Tracking:
  tool: [Sentry, Rollbar, Bugsnag, etc.]
  error_grouping: [How similar errors are grouped]
  alerting: [When to alert on errors]
  resolution_tracking: [How to track error fixes]

Recovery_Procedures:
  - scenario: [Service outage]
    detection: [How we'll know it's happening]
    response: [Steps to take]
    communication: [How to inform users/stakeholders]
```

### 11.3 Backup & Disaster Recovery (Requerido)
```yaml
Backup_Strategy:
  database_backups: [How often, where stored]
  file_backups: [User uploads, static files, etc.]
  configuration_backups: [Environment variables, etc.]
  retention_policy: [How long to keep backups]

Disaster_Recovery:
  rto: [Recovery Time Objective - how long to restore]
  rpo: [Recovery Point Objective - how much data loss acceptable]
  backup_testing: [How often to test backup restoration]
  failover_plan: [Steps for switching to backup systems]

Business_Continuity:
  critical_functions: [What must keep working]
  alternative_procedures: [Manual processes if systems down]
  communication_plan: [How to coordinate during incidents]
```

### 11.4 Documentation & Support (Requerido)
```yaml
Documentation_Strategy:
  code_documentation: [Inline comments, README files, etc.]
  api_documentation: [OpenAPI/Swagger, Postman collections, etc.]
  user_documentation: [How-to guides, FAQs, etc.]
  runbook_documentation: [Operations procedures, troubleshooting]

Support_Structure:
  internal_support: [Who handles technical issues]
  user_support: [How users get help]
  escalation_procedure: [When and how to escalate issues]
  knowledge_base: [Documentation for common issues]

Maintenance_Schedule:
  regular_updates: [How often to update dependencies]
  security_patches: [How quickly to apply security updates]
  feature_updates: [Release schedule for new features]
  maintenance_windows: [When scheduled downtime can occur]
```

**Scoring Sección 11**: ___ / 15 puntos

---

## **12. EMERGING TECHNOLOGIES CONTEXT** 🚀 (10 puntos)

### 12.1 AI/ML Integration (Si Aplica)
```yaml
AI_ML_Requirements:
  use_cases: [Where AI/ML will be used]
  models_needed: [Text processing, image recognition, etc.]
  data_requirements: [What data is needed for training]
  privacy_considerations: [How to handle user data]

Integration_Approach:
  external_apis: [OpenAI, Google AI, AWS AI services, etc.]
  self_hosted: [Models running on our infrastructure]
  hybrid: [Combination of external and self-hosted]
  
Performance_Considerations:
  response_time: [Acceptable latency for AI features]
  cost_budgets: [$ per request/month for AI services]
  fallback_behavior: [What to do if AI service unavailable]
```

### 12.2 Real-time & Edge Computing (Si Aplica)
```yaml
Real_Time_Requirements:
  use_cases: [Chat, notifications, live updates, etc.]
  technology: [WebSockets, Server-Sent Events, WebRTC, etc.]
  latency_requirements: [< 100ms, < 500ms, etc.]
  scalability_needs: [Concurrent real-time connections]

Edge_Computing:
  cdn_requirements: [Global content delivery]
  edge_functions: [Serverless functions at edge locations]
  geographic_distribution: [Regions where users are located]
  data_locality: [Requirements to keep data in specific regions]
```

### 12.3 Future Technology Roadmap (Requerido)
```yaml
Technology_Evolution:
  next_6_months: [Technologies to evaluate/adopt]
  next_12_months: [Major technology decisions/migrations]
  next_24_months: [Long-term technology vision]

Innovation_Priorities:
  - priority: [e.g., Performance optimization]
    technologies: [What tech could help]
    timeline: [When to evaluate/implement]
    
Legacy_Migration:
  - component: [What might need updating]
    reason: [Why it might become obsolete]
    timeline: [When to consider migration]
    alternatives: [What could replace it]
```

**Scoring Sección 12**: ___ / 10 puntos

---

## 🎯 SCORING SUMMARY

```yaml
Context_Completeness_Score:
  Section_1_Business: ___/15
  Section_2_Technical: ___/20
  Section_3_Functional: ___/20
  Section_4_Quality: ___/15
  Section_5_Dependencies: ___/10
  Section_6_Data: ___/10
  Section_7_Experience: ___/10
  Section_8_Infrastructure: ___/20
  Section_9_Security: ___/20
  Section_10_Performance: ___/15
  Section_11_Maintenance: ___/15
  Section_12_Emerging: ___/10

TOTAL_SCORE: ___/200 (95%+ required = 190+ points)

Score_Interpretation:
  195-200: EXCELLENT - Ready for immediate development
  190-194: GOOD - Minor context gaps to address
  180-189: FAIR - Significant context work needed
  <180: POOR - Major context development required
```

## ✅ NEXT STEPS

### If Score ≥ 190:
1. Proceed to Research Automation phase
2. Generate PRP with confidence scoring
3. Begin architecture design

### If Score < 190:
1. Identify specific gaps from scoring above
2. Prioritize missing information by impact
3. Gather additional context for low-scoring sections
4. Re-evaluate and iterate until 190+ achieved

---

**DevMethod Context Template v1.0 - No proceder con desarrollo hasta completar 190+ puntos**