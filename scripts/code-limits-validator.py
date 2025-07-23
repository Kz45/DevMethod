#!/usr/bin/env python3
"""
DevMethod Code Limits Validator
Enhanced Python script for validating DevMethod code quality standards.
"""

import ast
import os
import sys
import argparse
from pathlib import Path
from typing import List, Dict, Any, Tuple
import subprocess
import json

class DevMethodValidator:
    """DevMethod code quality validator implementing the 4 core limits."""
    
    def __init__(self, project_path: str):
        self.project_path = Path(project_path)
        self.errors = []
        self.warnings = []
        
        # DevMethod Standards
        self.MAX_FILE_LINES = 500
        self.MAX_FUNCTION_LINES = 50
        self.MAX_CYCLOMATIC_COMPLEXITY = 10
        self.MAX_COGNITIVE_COMPLEXITY = 15
        
    def validate_file_length(self, file_path: Path) -> bool:
        """Validate file length against DevMethod limit of 500 lines."""
        try:
            with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
                lines = f.readlines()
                
            # Count non-empty, non-comment lines
            code_lines = [line.strip() for line in lines 
                         if line.strip() and not line.strip().startswith('#')]
            
            if len(code_lines) > self.MAX_FILE_LINES:
                self.errors.append({
                    'type': 'file_length',
                    'file': str(file_path),
                    'lines': len(code_lines),
                    'limit': self.MAX_FILE_LINES,
                    'message': f"File has {len(code_lines)} lines (exceeds {self.MAX_FILE_LINES} limit)"
                })
                return False
                
        except Exception as e:
            self.warnings.append(f"Could not check file length for {file_path}: {e}")
            
        return True
    
    def validate_python_functions(self, file_path: Path) -> bool:
        """Validate Python function lengths and complexity."""
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
                
            tree = ast.parse(content, filename=str(file_path))
            
            for node in ast.walk(tree):
                if isinstance(node, (ast.FunctionDef, ast.AsyncFunctionDef)):
                    # Calculate function length
                    func_lines = node.end_lineno - node.lineno + 1 if hasattr(node, 'end_lineno') else 0
                    
                    if func_lines > self.MAX_FUNCTION_LINES:
                        self.errors.append({
                            'type': 'function_length',
                            'file': str(file_path),
                            'function': node.name,
                            'line': node.lineno,
                            'lines': func_lines,
                            'limit': self.MAX_FUNCTION_LINES,
                            'message': f"Function '{node.name}' has {func_lines} lines (exceeds {self.MAX_FUNCTION_LINES} limit)"
                        })
                        
                    # Calculate cyclomatic complexity (basic implementation)
                    complexity = self.calculate_cyclomatic_complexity(node)
                    if complexity > self.MAX_CYCLOMATIC_COMPLEXITY:
                        self.errors.append({
                            'type': 'cyclomatic_complexity',
                            'file': str(file_path),
                            'function': node.name,
                            'line': node.lineno,
                            'complexity': complexity,
                            'limit': self.MAX_CYCLOMATIC_COMPLEXITY,
                            'message': f"Function '{node.name}' has complexity {complexity} (exceeds {self.MAX_CYCLOMATIC_COMPLEXITY} limit)"
                        })
                        
        except SyntaxError as e:
            self.warnings.append(f"Syntax error in {file_path}: {e}")
        except Exception as e:
            self.warnings.append(f"Could not analyze {file_path}: {e}")
            
        return len(self.errors) == 0
    
    def calculate_cyclomatic_complexity(self, node: ast.AST) -> int:
        """Calculate cyclomatic complexity for a function."""
        complexity = 1  # Base complexity
        
        for child in ast.walk(node):
            # Decision points that increase complexity
            if isinstance(child, (ast.If, ast.While, ast.For, ast.AsyncFor)):
                complexity += 1
            elif isinstance(child, ast.Try):
                complexity += 1
            elif isinstance(child, ast.ExceptHandler):
                complexity += 1
            elif isinstance(child, ast.With, ast.AsyncWith):
                complexity += 1
            elif isinstance(child, ast.BoolOp):
                # AND/OR operators add complexity
                complexity += len(child.values) - 1
                
        return complexity
    
    def validate_javascript_typescript(self, file_path: Path) -> bool:
        """Validate JavaScript/TypeScript files using ESLint if available."""
        try:
            # Try to use ESLint for comprehensive checks
            eslint_config = self.project_path / '.eslintrc.devmethod.json'
            
            if not eslint_config.exists():
                # Create temporary config
                config = {
                    "rules": {
                        "max-lines": ["error", {"max": self.MAX_FILE_LINES}],
                        "max-lines-per-function": ["error", {"max": self.MAX_FUNCTION_LINES}],
                        "complexity": ["error", self.MAX_CYCLOMATIC_COMPLEXITY]
                    }
                }
                with open(eslint_config, 'w') as f:
                    json.dump(config, f, indent=2)
            
            # Run ESLint
            result = subprocess.run([
                'npx', 'eslint', str(file_path), 
                '--config', str(eslint_config),
                '--format', 'json'
            ], capture_output=True, text=True)
            
            if result.returncode != 0:
                try:
                    eslint_output = json.loads(result.stdout)
                    for file_result in eslint_output:
                        for message in file_result.get('messages', []):
                            if message.get('severity') == 2:  # Error
                                self.errors.append({
                                    'type': 'eslint_error',
                                    'file': file_result['filePath'],
                                    'line': message.get('line', 0),
                                    'rule': message.get('ruleId', 'unknown'),
                                    'message': message.get('message', '')
                                })
                except json.JSONDecodeError:
                    # Fallback to basic line counting
                    return self.validate_file_length(file_path)
                    
        except (subprocess.SubprocessError, FileNotFoundError):
            # Fallback to basic validation
            return self.validate_file_length(file_path)
            
        return len(self.errors) == 0
    
    def validate_project(self) -> Dict[str, Any]:
        """Validate entire project against DevMethod standards."""
        results = {
            'project_path': str(self.project_path),
            'standards': {
                'max_file_lines': self.MAX_FILE_LINES,
                'max_function_lines': self.MAX_FUNCTION_LINES,
                'max_cyclomatic_complexity': self.MAX_CYCLOMATIC_COMPLEXITY,
                'max_cognitive_complexity': self.MAX_COGNITIVE_COMPLEXITY
            },
            'files_checked': 0,
            'errors': [],
            'warnings': [],
            'passed': False
        }
        
        # File patterns to check
        patterns = [
            '**/*.py',
            '**/*.js', 
            '**/*.jsx',
            '**/*.ts',
            '**/*.tsx'
        ]
        
        exclude_patterns = [
            '**/node_modules/**',
            '**/build/**',
            '**/dist/**',
            '**/__pycache__/**',
            '**/venv/**',
            '**/.env/**',
            '**/coverage/**'
        ]
        
        for pattern in patterns:
            for file_path in self.project_path.glob(pattern):
                # Skip excluded directories
                if any(file_path.match(exclude) for exclude in exclude_patterns):
                    continue
                    
                if not file_path.is_file():
                    continue
                    
                results['files_checked'] += 1
                
                # Validate based on file type
                if file_path.suffix == '.py':
                    self.validate_file_length(file_path)
                    self.validate_python_functions(file_path)
                elif file_path.suffix in ['.js', '.jsx', '.ts', '.tsx']:
                    self.validate_javascript_typescript(file_path)
                else:
                    self.validate_file_length(file_path)
        
        results['errors'] = self.errors
        results['warnings'] = self.warnings
        results['passed'] = len(self.errors) == 0
        
        return results

def main():
    parser = argparse.ArgumentParser(description='DevMethod Code Limits Validator')
    parser.add_argument('project_path', help='Path to project directory')
    parser.add_argument('--format', choices=['json', 'text'], default='text',
                       help='Output format')
    parser.add_argument('--strict', action='store_true',
                       help='Treat warnings as errors')
    
    args = parser.parse_args()
    
    if not os.path.exists(args.project_path):
        print(f"Error: Project path '{args.project_path}' does not exist")
        sys.exit(1)
    
    validator = DevMethodValidator(args.project_path)
    results = validator.validate_project()
    
    if args.format == 'json':
        print(json.dumps(results, indent=2))
    else:
        # Text output
        print("🔍 DevMethod Code Limits Validation Report")
        print("=" * 50)
        print(f"Project: {results['project_path']}")
        print(f"Files checked: {results['files_checked']}")
        print()
        
        print("📏 DevMethod Standards:")
        print(f"  • Max file lines: {results['standards']['max_file_lines']}")
        print(f"  • Max function lines: {results['standards']['max_function_lines']}")
        print(f"  • Max cyclomatic complexity: {results['standards']['max_cyclomatic_complexity']}")
        print(f"  • Max cognitive complexity: {results['standards']['max_cognitive_complexity']}")
        print()
        
        if results['errors']:
            print("❌ ERRORS FOUND:")
            for error in results['errors']:
                print(f"  • {error['message']}")
                if 'file' in error:
                    print(f"    File: {error['file']}")
                if 'line' in error:
                    print(f"    Line: {error['line']}")
                print()
        
        if results['warnings']:
            print("⚠️  WARNINGS:")
            for warning in results['warnings']:
                print(f"  • {warning}")
            print()
        
        if results['passed']:
            print("✅ ALL CHECKS PASSED - Code meets DevMethod standards!")
            sys.exit(0)
        else:
            print("❌ VALIDATION FAILED - Please fix the errors above")
            sys.exit(1)

if __name__ == '__main__':
    main()