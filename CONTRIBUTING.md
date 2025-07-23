# Contributing to DevMethod 2.0

Welcome to DevMethod 2.0! We're excited that you want to contribute to the future of AI-amplified software engineering.

## 🎯 What is DevMethod 2.0?

DevMethod 2.0 is an open-source framework that combines engineering rigor with AI amplification to achieve **90%+ one-pass implementation success rates**. We're building tools and methodologies that help developers ship production-ready code from day 1.

## 🤝 Ways to Contribute

### 🐛 Bug Reports
Found a bug? Help us fix it!

**Before submitting:**
- Search existing [issues](https://github.com/yourusername/DevMethod/issues) to avoid duplicates
- Try the latest version to see if it's already fixed

**When submitting:**
- Use our [Bug Report Template](.github/ISSUE_TEMPLATE/bug_report.md)
- Include steps to reproduce
- Provide your environment details (OS, Node.js version, etc.)
- Add relevant logs or screenshots

### 💡 Feature Requests
Have an idea to make DevMethod better?

**Before submitting:**
- Check existing [feature requests](https://github.com/yourusername/DevMethod/issues?q=label%3Aenhancement)
- Consider if it aligns with our [Core Philosophy](docs/methodology/01-core-philosophy.md)

**When submitting:**
- Use our [Feature Request Template](.github/ISSUE_TEMPLATE/feature_request.md)
- Explain the problem you're solving
- Describe your proposed solution
- Consider impact on the 12-dimension context system

### 📖 Documentation
Documentation is crucial for adoption. Help us improve:

- **Guides**: Add tutorials, examples, or case studies
- **API Docs**: Improve technical documentation
- **Methodology**: Enhance methodology explanations
- **Examples**: Create real-world usage examples

### 💻 Code Contributions
Ready to dive into the code?

**Good First Issues:**
Look for issues labeled [`good first issue`](https://github.com/yourusername/DevMethod/issues?q=label%3A%22good+first+issue%22) - these are beginner-friendly and well-documented.

**Areas We Need Help:**
- 🔧 **Validation Scripts**: Improve automated code quality checks
- 🤖 **Agent Templates**: Create specialized agent configurations
- 📊 **Context Scoring**: Enhance the 12-dimension scoring system
- 🧪 **Testing**: Add test coverage and validation scenarios
- 🌐 **Integrations**: Support for new frameworks and tools

## 🚀 Development Setup

### Prerequisites
- Node.js 18+
- Python 3.9+
- Git
- Claude Code or compatible AI assistant

### Getting Started
```bash
# 1. Fork and clone the repository
git clone https://github.com/yourusername/DevMethod.git
cd DevMethod

# 2. Run the setup script
chmod +x scripts/devmethod-setup.sh
./scripts/devmethod-setup.sh

# 3. Install development dependencies
npm install
pip install -r requirements-dev.txt

# 4. Run tests to verify setup
npm run test
python -m pytest tests/

# 5. Create your feature branch
git checkout -b feature/amazing-new-feature
```

## 📋 Development Guidelines

### Code Standards
We maintain high code quality standards:

- **JavaScript/TypeScript**: ESLint + Prettier
- **Python**: Black + Flake8 + mypy
- **Maximum file size**: 500 lines
- **Maximum function size**: 50 lines
- **Cyclomatic complexity**: < 10

```bash
# Run quality checks
npm run lint
npm run type-check
python -m flake8
python -m mypy .
```

### Testing Requirements
All contributions must include tests:

- **Unit tests**: Required for new functions/features
- **Integration tests**: Required for new components
- **Minimum coverage**: 80%
- **Test naming**: Descriptive and clear

```bash
# Run tests
npm run test -- --coverage
python -m pytest --cov=. --cov-report=html
```

### Git Workflow

#### Commits
- Use [Conventional Commits](https://www.conventionalcommits.org/)
- Keep commits atomic and focused
- Write clear commit messages

**Examples:**
```bash
feat: add WIRASM validation loops to PRP template
fix: resolve context scoring calculation bug
docs: update beginner's guide with examples
test: add unit tests for context scorer
```

#### Branches
- `main`: Production-ready code
- `develop`: Integration branch for features
- `feature/`: New features (`feature/wirasm-integration`)
- `fix/`: Bug fixes (`fix/context-scoring-bug`)
- `docs/`: Documentation updates (`docs/contributing-guide`)

#### Pull Requests
1. **Create focused PRs**: One feature/fix per PR
2. **Use our PR template**: Fill out all sections
3. **Update documentation**: Include relevant docs changes
4. **Add tests**: Ensure good test coverage
5. **Request review**: Tag relevant maintainers

### DevMethod-Specific Guidelines

#### Context Engineering
When working on context-related features:
- Follow the 12-dimension framework
- Ensure minimum 190/200 points validation
- Test with real project examples

#### Agent System
For agent-related contributions:
- Use the established agent naming (Mary, John, Winston, etc.)
- Follow the handoff protocols
- Include agent configuration files

#### WIRASM Integration
When enhancing WIRASM features:
- Maintain "Context is King" principle
- Include executable validation loops
- Support progressive success patterns

## 📝 Pull Request Process

### Before Submitting
- [ ] Code follows our style guidelines
- [ ] All tests pass
- [ ] Documentation is updated
- [ ] CHANGELOG.md is updated (if applicable)
- [ ] Commit messages follow Conventional Commits

### PR Template
Use our template to ensure all requirements are met:

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Performance improvement

## Testing
- [ ] Unit tests added/updated
- [ ] Integration tests pass
- [ ] Manual testing completed

## DevMethod Validation
- [ ] Context scoring works correctly
- [ ] Validation scripts pass
- [ ] Agent handoffs function properly

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] No breaking changes (or documented)
```

### Review Process
1. **Automated checks** must pass (CI/CD)
2. **Code review** by at least one maintainer
3. **DevMethod validation** using our framework
4. **Final approval** and merge

## 🏗️ Architecture & Design

### Core Principles
When contributing, keep these principles in mind:

1. **Context is King**: Comprehensive documentation enables one-pass success
2. **Engineering Rigor**: High standards, automated validation
3. **AI Amplification**: Design for AI assistant collaboration
4. **Progressive Success**: Start simple, iterate to production-ready

### File Organization
```
DevMethod/
├── docs/                    # All documentation
│   ├── methodology/         # Core framework docs
│   ├── guides/             # How-to guides
│   └── architecture/       # System design
├── templates/              # PRP and other templates
├── scripts/               # Automation scripts
├── examples/              # Usage examples
├── config/                # Configuration files
└── tests/                 # Test suites
```

## 🌍 Community Guidelines

### Code of Conduct
We are committed to providing a welcoming and inclusive environment. Please read our [Code of Conduct](CODE_OF_CONDUCT.md).

### Communication
- **GitHub Issues**: Bug reports, feature requests
- **GitHub Discussions**: Questions, ideas, showcases
- **Discord**: Real-time community chat (coming soon)
- **Twitter**: [@DevMethod](https://twitter.com/devmethod) for updates

### Recognition
Contributors are recognized in:
- README.md contributors section
- Release notes for significant contributions
- Community showcase for excellent examples

## 🎓 Learning Resources

### Understanding DevMethod
- [Core Philosophy](docs/methodology/01-core-philosophy.md)
- [Context Engineering](docs/methodology/02-context-engineering-system.md)
- [WIRASM Integration](docs/methodology/06-wirasm-integration.md)

### Technical Resources
- [Next.js 15 Documentation](https://nextjs.org/docs)
- [TypeScript Handbook](https://www.typescriptlang.org/docs/)
- [Claude Code Documentation](https://docs.anthropic.com/claude-code)

## ❓ Questions?

- **GitHub Discussions**: For general questions about usage or contribution
- **Issues**: For bug reports and feature requests
- **Email**: devmethod@example.com for private matters

## 🙏 Thank You!

Every contribution, no matter how small, helps make DevMethod better for the entire developer community. Your effort to improve AI-amplified software engineering is greatly appreciated!

---

**Happy Contributing! 🚀**

*Made with ❤️ by the DevMethod community*