# DevMethod Project Configuration for Claude Code

**Project**: E-commerce Admin Panel  
**Framework**: DevMethod v1.0  
**Tech Stack**: Next.js 15 + TypeScript + Tailwind + Prisma  

---

## 🎯 PROJECT OVERVIEW

This project uses **DevMethod: Engineering-First AI-Amplified Development** with specialized agent roles and systematic validation.

### Current Phase
- **Phase**: [Foundation | Development | Production]
- **Context Score**: 194/200 ✅
- **PRP Confidence**: 8.5/10 ✅
- **Active Agent**: [Current agent working]

---

## 🤖 AGENT SYSTEM

### Agent Roles and Responsibilities

#### 🔧 DEV Agent (James)
- **Role**: Full-stack implementation
- **Trigger**: `/agent-dev` or when implementing features
- **Always Load**:
  - `docs/agents/agent-configs/dev-config.md`
  - `docs/agents/knowledge-base/nextjs-dev-patterns.md`
  - `docs/architecture/coding-standards.md`

#### 🏗️ ARCHITECT Agent (Winston)  
- **Role**: System architecture and technical decisions
- **Trigger**: `/agent-architect` or when architectural decisions needed
- **Always Load**:
  - `docs/agents/agent-configs/architect-config.md` 
  - `docs/agents/knowledge-base/nextjs-architecture.md`
  - `docs/context/infrastructure.md`

#### ✅ QA Agent (Quinn)
- **Role**: Code review, testing, and quality validation
- **Trigger**: `/agent-qa` or when reviewing code
- **Always Load**:
  - `docs/agents/agent-configs/qa-config.md`
  - `docs/agents/knowledge-base/testing-strategies.md`
  - `docs/validation/quality-gates.md`

#### 📋 PM Agent (John)
- **Role**: Requirements management and PRP creation
- **Trigger**: `/agent-pm` or when defining requirements
- **Always Load**:
  - `docs/agents/agent-configs/pm-config.md`
  - `docs/context/business.md`
  - `templates/prp-scored-template.md`

---

## 📋 DEVELOPMENT WORKFLOW

### Context-Driven Development
1. **Foundation Phase** (Web UI recommended)
   - Context gathering: 12 dimensions, 190+ points required
   - Research automation: Multi-source validation
   - PRP generation: 8+ confidence score required
   - Architecture design: Production-first approach

2. **Development Phase** (IDE required)
   - Document sharding for agent context
   - Progressive story development (MVP → Enhanced)
   - Multi-level validation (4 levels)
   - Clean agent handoffs (NEW CHAT per agent)

3. **Production Phase**
   - Level 4 validation (security, performance, compliance)
   - Automated deployment with rollback capability
   - Monitoring and observability activation

### Agent Handoff Protocol
- **ALWAYS** use NEW CHAT when switching between agents
- **LOAD** agent-specific context files first
- **VALIDATE** previous agent's work before proceeding
- **LOG** handoffs in `docs/workflow/handoff-log.md`

---

## 🎯 CURRENT CONTEXT LOADING

### Project Context (Always Available)
```yaml
Business_Context:
  - Project: E-commerce admin panel for product management
  - Users: Store managers and admin staff
  - Goals: Reduce manual work by 75%, save 3 hours/day per user
  - Timeline: 3 weeks MVP, 2 weeks enhancement

Technical_Context:
  - Stack: Next.js 15 + TypeScript + Tailwind CSS + Prisma
  - Database: PostgreSQL 15.x
  - Hosting: AWS (EC2 + RDS + S3)
  - Authentication: NextAuth.js with JWT

Current_Status:
  - Context_Score: 194/200 ✅
  - PRP_Confidence: 8.5/10 ✅  
  - Phase: Development
  - Active_Sprint: Sprint 1 - Core CRUD Operations
```

### Agent Context Loading Rules
- **DEV Agent**: Load current story + architecture + coding standards
- **ARCHITECT**: Load full context + infrastructure requirements
- **QA**: Load story + quality gates + testing requirements
- **PM**: Load business context + stakeholder requirements

---

## 🔧 CODING STANDARDS

### Next.js 15 Specific Rules
- **ALWAYS** use App Router (`app/` directory)
- **NEVER** use Pages Router (`pages/` directory)
- **DEFAULT** to Server Components unless interactivity needed
- **STRICT** TypeScript mode (no `any` types)
- **REQUIRED** error boundaries and loading states

### Code Quality Gates
```yaml
Level_1_Validation: # Per commit
  - ESLint + Prettier formatting
  - TypeScript compilation
  - Complexity limits (< 10 cyclomatic)
  - Security static analysis

Level_2_Validation: # Per story
  - Unit test coverage ≥ 80%
  - Performance budgets met
  - Error handling comprehensive
  - Integration tests passing

Level_3_Validation: # Per epic  
  - End-to-end tests passing
  - API contract validation
  - Database performance validated
  - Security testing completed

Level_4_Validation: # Pre-production
  - Load testing passed
  - Security scan clean
  - Monitoring configured
  - Rollback procedures tested
```

---

## 📝 VALIDATION COMMANDS

### Development Validation
```bash
# Run these before any handoff
npm run lint              # ESLint + Prettier
npm run type-check        # TypeScript compilation
npm run test             # Unit tests  
npm run test:integration # Integration tests
npm run build            # Production build test
```

### Quality Gates Enforcement
- **Commit**: Level 1 must pass
- **Story Complete**: Level 2 must pass
- **Epic Complete**: Level 3 must pass  
- **Production Deploy**: Level 4 must pass

---

## 🎯 AGENT ACTIVATION COMMANDS

### Quick Agent Switching
```bash
/agent-dev           # Switch to DEV agent (James)
/agent-architect     # Switch to ARCHITECT agent (Winston)  
/agent-qa            # Switch to QA agent (Quinn)
/agent-pm            # Switch to PM agent (John)
```

### DevMethod Commands
```bash
/devmethod-context   # Context gathering with 12 dimensions
/devmethod-prp       # Generate scored PRP
/devmethod-validate  # Run validation suite
/devmethod-status    # Show current project status
```

---

## 📊 PROJECT METRICS

### Success Indicators
```yaml
Context_Quality: 194/200 (97%) ✅
PRP_Confidence: 8.5/10 ✅
Development_Phase: Active
Code_Quality: Passing all gates
Test_Coverage: 87% (target: >80%) ✅
Performance: Meeting budgets ✅

Next_Milestone: Sprint 1 completion
Expected_Completion: 3 days
Risk_Level: Low
```

---

## 🔄 CONTINUOUS IMPROVEMENT

### After Each Sprint
- Update agent configurations based on learnings
- Refine validation criteria
- Improve handoff procedures
- Document lessons learned

### Quality Metrics Tracking
- Context gathering effectiveness
- PRP confidence accuracy
- Agent handoff efficiency
- Validation pass rates

---

**DevMethod v1.0 - Engineering-First AI-Amplified Development**  
**For questions or issues, reference the DevMethod documentation in `/docs/methodology/`**