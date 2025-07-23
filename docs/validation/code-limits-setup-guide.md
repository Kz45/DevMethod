# DevMethod 2.0 Code Limits Setup Guide

## 🎯 Overview

Esta guía te ayuda a configurar las validaciones automáticas de límites de código de DevMethod 2.0, implementando los 4 estándares fundamentales:

1. **Complejidad Ciclomática**: < 10 por función
2. **Complejidad Cognitiva**: < 15 por función  
3. **Longitud de Función**: < 50 líneas
4. **Longitud de Archivo**: < 500 líneas

## 🚀 Quick Setup

### Para Proyectos JavaScript/TypeScript (Next.js, React, etc.)

#### 1. Instalar Dependencias
```bash
npm install --save-dev eslint eslint-plugin-complexity @typescript-eslint/eslint-plugin prettier husky lint-staged
```

#### 2. Configurar ESLint
```bash
# Copia la configuración DevMethod
cp .devmethod/config/eslint-devmethod.json .eslintrc.devmethod.json
```

#### 3. Actualizar package.json
```bash
# Copia el template de package.json DevMethod
cp .devmethod/templates/package-devmethod-setup.json package.json
# Luego edita según tu proyecto específico
```

#### 4. Configurar Git Hooks
```bash
npx husky install
npx husky add .husky/pre-commit "npm run devmethod:validate"
npx husky add .husky/pre-push "npm run devmethod:validate-all"
```

### Para Proyectos Python

#### 1. Instalar Dependencias
```bash
pip install flake8 flake8-cognitive-complexity black mypy
```

#### 2. Configurar Flake8
```bash
# Copia la configuración DevMethod
cp .devmethod/config/flake8-devmethod.ini .flake8
```

#### 3. Configurar pre-commit (Python)
```bash
pip install pre-commit
# Crear .pre-commit-config.yaml con hooks DevMethod
```

## 🔧 Configuración Detallada

### ESLint DevMethod Rules

```json
{
  "rules": {
    // Límites DevMethod
    "complexity": ["error", 10],
    "max-lines": ["error", {"max": 500, "skipBlankLines": true}],
    "max-lines-per-function": ["error", {"max": 50, "skipBlankLines": true}],
    "cognitive-complexity": ["error", 15],
    
    // Calidad adicional
    "max-depth": ["error", 4],
    "max-params": ["error", 5],
    "max-statements": ["error", 20]
  }
}
```

### Flake8 DevMethod Configuration

```ini
[flake8]
max-line-length = 100
max-complexity = 10
max-cognitive-complexity = 15

# Custom DevMethod checks
max-function-length = 50
max-file-lines = 500

exclude = .git,__pycache__,build,dist,venv
```

## 📋 Comandos de Validación

### Nivel 1: Validación Rápida (< 2 minutos)
```bash
# JavaScript/TypeScript
npm run lint
npm run type-check  
npm run complexity-check

# Python
flake8 .
black --check .
mypy .
```

### Validación Completa DevMethod
```bash
# Script principal de validación
./.devmethod/scripts/devmethod-validation-enhanced.sh . all

# Validador específico de límites de código
python .devmethod/scripts/code-limits-validator.py .
```

## 🎯 Integración en CI/CD

### GitHub Actions

```yaml
name: DevMethod Validation
on: [push, pull_request]

jobs:
  devmethod-validation:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'
          
      - name: Install dependencies
        run: npm ci
        
      - name: DevMethod Code Limits Validation
        run: npm run devmethod:validate-all
        
      - name: Upload validation report
        uses: actions/upload-artifact@v3
        if: always()
        with:
          name: devmethod-validation-report
          path: .devmethod/validation/results/
```

### Pre-commit Integration

```yaml
# .pre-commit-config.yaml
repos:
  - repo: local
    hooks:
      - id: devmethod-code-limits
        name: DevMethod Code Limits
        entry: python .devmethod/scripts/code-limits-validator.py .
        language: system
        pass_filenames: false
        
      - id: devmethod-validation-level1
        name: DevMethod Level 1 Validation
        entry: .devmethod/scripts/devmethod-validation-enhanced.sh . level1
        language: system
        pass_filenames: false
```

## 🚨 Manejo de Violaciones

### Cuando se Exceden los Límites

#### Archivo Demasiado Grande (>500 líneas)
```bash
# ERROR encontrado
❌ File src/components/Dashboard.jsx has 650 lines (exceeds 500 limit)

# SOLUCIONES:
# 1. Extraer componentes
# 2. Crear custom hooks
# 3. Separar lógica de negocio
```

**Ejemplo de Refactorización:**
```javascript
// ANTES: Dashboard.jsx (650 líneas)
// TODO en un archivo

// DESPUÉS: Múltiples archivos
// Dashboard.jsx (200 líneas) - componente principal
// DashboardHeader.jsx (80 líneas)
// DashboardSidebar.jsx (150 líneas) 
// DashboardContent.jsx (220 líneas)
```

#### Función Demasiado Compleja
```bash
# ERROR encontrado  
❌ Function 'processUserData' has complexity 12 (exceeds 10 limit)

# SOLUCIONES:
# 1. Extraer subfunciones
# 2. Usar early returns
# 3. Simplificar condiciones
```

**Ejemplo de Refactorización:**
```javascript
// ANTES: Complejidad 12
function processUserData(user) {
  if (user.age > 18) {
    if (user.verified) {
      if (user.premium) {
        // Muchas condiciones anidadas...
      }
    }
  }
}

// DESPUÉS: Complejidad 4
function processUserData(user) {
  if (!isEligibleUser(user)) return null;
  
  return applyUserProcessing(user);
}

function isEligibleUser(user) {
  return user.age > 18 && user.verified;
}

function applyUserProcessing(user) {
  return user.premium ? processPremiumUser(user) : processRegularUser(user);
}
```

## 📊 Monitoreo y Métricas

### Dashboard de Calidad de Código

El sistema DevMethod trackea:
- **Compliance Rate**: % de archivos que cumplen límites
- **Average Complexity**: Complejidad promedio por función
- **Refactoring Opportunities**: Archivos que necesitan refactorización
- **Technical Debt**: Deuda técnica acumulada

### Reportes Automáticos

```bash
# Generar reporte detallado
python .devmethod/scripts/code-limits-validator.py . --format json > code-quality-report.json

# Reporte para humanos
python .devmethod/scripts/code-limits-validator.py . --format text
```

## 🔄 Workflow de Desarrollo

### 1. Pre-Development
```bash
# Verificar estado actual del proyecto
npm run devmethod:validate

# Si hay errores, arreglar antes de continuar
```

### 2. Durante Development  
```bash
# Validar mientras desarrollas (cada 30 min)
npm run devmethod:code-limits

# Auto-fix cuando sea posible
npm run lint:fix
```

### 3. Pre-Commit
```bash
# Automático con Husky
git commit -m "feat: add user dashboard"
# Ejecuta validaciones automáticamente
```

### 4. Pre-Push
```bash
# Validación completa antes de push
git push origin feature/dashboard
# Ejecuta validación completa de 4 niveles
```

## 🎯 Best Practices

### ✅ DO's
- **Refactorizar proactivamente** cuando te acerques a los límites
- **Usar herramientas automáticas** para detectar problemas temprano
- **Escribir funciones pequeñas** y con propósito único
- **Extraer componentes** cuando UI se vuelve complejo

### ❌ DON'Ts  
- **No ignorar warnings** de límites de código
- **No deshabilitar rules** sin justificación documentada
- **No crear funciones monolíticas** que hagan muchas cosas
- **No posponer refactorización** hasta "después"

## 🆘 Troubleshooting

### Problema: "ESLint no encuentra la configuración DevMethod"
```bash
# Solución: Verificar que existe el archivo
ls -la .eslintrc.devmethod.json

# Si no existe, copiarlo
cp .devmethod/config/eslint-devmethod.json .eslintrc.devmethod.json
```

### Problema: "Python validator falla"
```bash
# Solución: Instalar dependencias
pip install ast pathlib

# O usar el validator incluido en el proyecto
python3 -m pip install -r .devmethod/requirements.txt
```

### Problema: "Validación muy lenta"
```bash
# Solución: Ejecutar solo nivel 1 para desarrollo
npm run devmethod:validate level1

# Usar validación completa solo pre-push
```

---

**Con esta configuración, tendrás validación automática de límites de código integrada en tu workflow de desarrollo, asegurando que el código siempre cumpla con los estándares DevMethod 2.0.**