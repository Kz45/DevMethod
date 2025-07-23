#!/usr/bin/env python3
"""
Context7 Proof of Concept for DevMethod 2.0
===========================================

This PoC demonstrates automated documentation generation and updates
using LSP integration, inspired by Serena's semantic analysis capabilities.

Features:
- Real-time documentation generation from LSP hover information
- Automatic updates when code changes
- Contextual documentation provision
- Multi-language support through unified LSP interface
"""

import asyncio
import json
import os
import time
from abc import ABC, abstractmethod
from dataclasses import dataclass, field
from datetime import datetime
from pathlib import Path
from typing import Dict, List, Optional, Set, Any, Union
from enum import Enum
import subprocess
import logging

# Mock LSP types for PoC (in real implementation, use lsprotocol)
@dataclass
class Position:
    line: int
    character: int

@dataclass
class Range:
    start: Position
    end: Position

@dataclass
class Location:
    uri: str
    range: Range

@dataclass
class SymbolInformation:
    name: str
    kind: int  # SymbolKind
    location: Location
    container_name: Optional[str] = None

@dataclass
class Hover:
    contents: Union[str, List[str]]
    range: Optional[Range] = None

class Language(Enum):
    PYTHON = "python"
    TYPESCRIPT = "typescript"
    JAVASCRIPT = "javascript"
    JAVA = "java"
    RUST = "rust"
    GO = "go"

# Core Context7 Components

@dataclass
class Documentation:
    """Represents generated documentation for a symbol"""
    symbol_name: str
    symbol_kind: str
    description: str
    type_signature: Optional[str]
    parameters: List[Dict[str, str]] = field(default_factory=list)
    returns: Optional[str] = None
    examples: List[str] = field(default_factory=list)
    related_symbols: List[str] = field(default_factory=list)
    source_location: Optional[Location] = None
    last_updated: datetime = field(default_factory=datetime.now)

@dataclass
class FileChange:
    """Represents a file change event"""
    file_path: str
    change_type: str  # 'modified', 'created', 'deleted'
    timestamp: datetime = field(default_factory=datetime.now)

class DocumentationCache:
    """In-memory cache for generated documentation"""
    
    def __init__(self):
        self._cache: Dict[str, Documentation] = {}
        self._file_symbols: Dict[str, Set[str]] = {}
    
    def get(self, symbol_key: str) -> Optional[Documentation]:
        return self._cache.get(symbol_key)
    
    def update(self, symbol_key: str, documentation: Documentation):
        self._cache[symbol_key] = documentation
        
    def invalidate_file(self, file_path: str):
        """Invalidate all documentation for symbols in a file"""
        if file_path in self._file_symbols:
            for symbol_key in self._file_symbols[file_path]:
                self._cache.pop(symbol_key, None)
            del self._file_symbols[file_path]
    
    def add_file_symbol(self, file_path: str, symbol_key: str):
        if file_path not in self._file_symbols:
            self._file_symbols[file_path] = set()
        self._file_symbols[file_path].add(symbol_key)

class MockLSPClient:
    """Mock LSP client for PoC demonstration"""
    
    def __init__(self, language: Language):
        self.language = language
        self.mock_symbols = self._create_mock_symbols()
        self.mock_hover_info = self._create_mock_hover_info()
    
    def _create_mock_symbols(self) -> List[SymbolInformation]:
        """Create mock symbols for demonstration"""
        if self.language == Language.PYTHON:
            return [
                SymbolInformation(
                    name="calculate_total",
                    kind=12,  # Function
                    location=Location(
                        uri="file:///example.py",
                        range=Range(Position(10, 0), Position(15, 0))
                    )
                ),
                SymbolInformation(
                    name="UserManager",
                    kind=5,  # Class
                    location=Location(
                        uri="file:///user_manager.py", 
                        range=Range(Position(5, 0), Position(50, 0))
                    )
                ),
                SymbolInformation(
                    name="validate_input",
                    kind=12,  # Function
                    location=Location(
                        uri="file:///validator.py",
                        range=Range(Position(20, 4), Position(35, 0))
                    )
                )
            ]
        return []
    
    def _create_mock_hover_info(self) -> Dict[str, Hover]:
        """Create mock hover information"""
        return {
            "calculate_total": Hover(
                contents=[
                    "```python\ndef calculate_total(items: List[Item]) -> float\n```",
                    "Calculates the total price of all items in the list.",
                    "Args:\n    items: List of Item objects with price attributes",
                    "Returns:\n    float: Total price of all items"
                ]
            ),
            "UserManager": Hover(
                contents=[
                    "```python\nclass UserManager:\n```",
                    "Manages user accounts and authentication.",
                    "Provides methods for creating, updating, and deleting users."
                ]
            ),
            "validate_input": Hover(
                contents=[
                    "```python\ndef validate_input(data: dict) -> bool\n```",
                    "Validates user input data according to schema.",
                    "Returns True if valid, False otherwise."
                ]
            )
        }
    
    async def get_document_symbols(self, file_uri: str) -> List[SymbolInformation]:
        """Mock LSP textDocument/documentSymbol request"""
        await asyncio.sleep(0.1)  # Simulate network delay
        return [s for s in self.mock_symbols if s.location.uri == file_uri]
    
    async def get_hover(self, file_uri: str, position: Position) -> Optional[Hover]:
        """Mock LSP textDocument/hover request"""
        await asyncio.sleep(0.1)  # Simulate network delay
        # In real implementation, would find symbol at position
        for symbol in self.mock_symbols:
            if symbol.location.uri == file_uri:
                return self.mock_hover_info.get(symbol.name)
        return None
    
    async def find_references(self, file_uri: str, position: Position) -> List[Location]:
        """Mock LSP textDocument/references request"""
        await asyncio.sleep(0.1)
        # Return mock references
        return [
            Location("file:///main.py", Range(Position(25, 10), Position(25, 20))),
            Location("file:///test.py", Range(Position(15, 5), Position(15, 15)))
        ]

class Context7LSPProvider:
    """Core Context7 implementation using LSP"""
    
    def __init__(self, lsp_client: MockLSPClient):
        self.lsp = lsp_client
        self.doc_cache = DocumentationCache()
        self.logger = logging.getLogger(__name__)
        
    async def generate_symbol_documentation(self, symbol: SymbolInformation) -> Documentation:
        """Generate comprehensive documentation for a symbol using LSP"""
        self.logger.info(f"Generating documentation for symbol: {symbol.name}")
        
        # Get hover information
        hover_info = await self.lsp.get_hover(symbol.location.uri, symbol.location.range.start)
        
        # Get references for usage examples
        references = await self.lsp.find_references(symbol.location.uri, symbol.location.range.start)
        
        # Parse hover information
        description, type_signature, parameters, returns = self._parse_hover_info(hover_info)
        
        # Generate usage examples from references
        examples = self._generate_usage_examples(symbol, references)
        
        # Create documentation object
        documentation = Documentation(
            symbol_name=symbol.name,
            symbol_kind=self._get_symbol_kind_name(symbol.kind),
            description=description,
            type_signature=type_signature,
            parameters=parameters,
            returns=returns,
            examples=examples,
            source_location=symbol.location,
            last_updated=datetime.now()
        )
        
        # Cache the documentation
        symbol_key = f"{symbol.location.uri}:{symbol.name}"
        self.doc_cache.update(symbol_key, documentation)
        self.doc_cache.add_file_symbol(symbol.location.uri, symbol_key)
        
        return documentation
    
    def _parse_hover_info(self, hover: Optional[Hover]) -> tuple:
        """Parse LSP hover information into structured documentation"""
        if not hover or not hover.contents:
            return "No description available", None, [], None
        
        contents = hover.contents if isinstance(hover.contents, list) else [hover.contents]
        
        description = ""
        type_signature = None
        parameters = []
        returns = None
        
        for content in contents:
            if content.startswith("```"):
                # Extract type signature from code block
                lines = content.split('\n')
                if len(lines) > 1:
                    type_signature = lines[1].strip()
            elif content.startswith("Args:"):
                # Parse parameters
                parameters = self._parse_parameters(content)
            elif content.startswith("Returns:"):
                # Parse return type
                returns = content.replace("Returns:", "").strip()
            elif not content.startswith("```") and not content.startswith("Args:") and not content.startswith("Returns:"):
                # General description
                if description:
                    description += " " + content
                else:
                    description = content
        
        return description, type_signature, parameters, returns
    
    def _parse_parameters(self, args_text: str) -> List[Dict[str, str]]:
        """Parse parameter information from hover text"""
        parameters = []
        lines = args_text.split('\n')
        for line in lines[1:]:  # Skip "Args:" line
            if ':' in line:
                parts = line.strip().split(':', 1)
                if len(parts) == 2:
                    param_name = parts[0].strip()
                    param_desc = parts[1].strip()
                    parameters.append({"name": param_name, "description": param_desc})
        return parameters
    
    def _generate_usage_examples(self, symbol: SymbolInformation, references: List[Location]) -> List[str]:
        """Generate usage examples based on symbol references"""
        examples = []
        
        # Mock examples based on symbol type
        if symbol.kind == 12:  # Function
            examples.append(f"result = {symbol.name}(data)")
            examples.append(f"if {symbol.name}(input_data):")
        elif symbol.kind == 5:  # Class
            examples.append(f"manager = {symbol.name}()")
            examples.append(f"instance = {symbol.name}(config)")
        
        # In real implementation, would analyze actual usage at reference locations
        return examples[:3]  # Limit to 3 examples
    
    def _get_symbol_kind_name(self, kind: int) -> str:
        """Convert LSP symbol kind to readable name"""
        symbol_kinds = {
            1: "File", 2: "Module", 3: "Namespace", 4: "Package", 5: "Class",
            6: "Method", 7: "Property", 8: "Field", 9: "Constructor", 10: "Enum",
            11: "Interface", 12: "Function", 13: "Variable", 14: "Constant",
            15: "String", 16: "Number", 17: "Boolean", 18: "Array", 19: "Object",
            20: "Key", 21: "Null", 22: "EnumMember", 23: "Struct", 24: "Event",
            25: "Operator", 26: "TypeParameter"
        }
        return symbol_kinds.get(kind, "Unknown")
    
    async def auto_update_documentation(self, file_changes: List[FileChange]):
        """Automatically update documentation when files change"""
        for change in file_changes:
            self.logger.info(f"Processing file change: {change.file_path} ({change.change_type})")
            
            if change.change_type == "deleted":
                # Remove all documentation for deleted file
                self.doc_cache.invalidate_file(change.file_path)
                continue
            
            # Get updated symbols from file
            file_uri = f"file://{change.file_path}"
            symbols = await self.lsp.get_document_symbols(file_uri)
            
            # Regenerate documentation for affected symbols
            for symbol in symbols:
                await self.generate_symbol_documentation(symbol)
    
    async def provide_contextual_docs(self, query: str, file_context: Optional[str] = None) -> List[Documentation]:
        """Provide relevant documentation based on query and context"""
        self.logger.info(f"Searching documentation for query: {query}")
        
        relevant_docs = []
        
        # Search cached documentation
        for symbol_key, doc in self.doc_cache._cache.items():
            if (query.lower() in doc.symbol_name.lower() or 
                query.lower() in doc.description.lower()):
                relevant_docs.append(doc)
        
        # If no cached docs found, search symbols and generate documentation
        if not relevant_docs:
            for symbol in self.lsp.mock_symbols:
                if query.lower() in symbol.name.lower():
                    doc = await self.generate_symbol_documentation(symbol)
                    relevant_docs.append(doc)
        
        return relevant_docs[:5]  # Limit results
    
    def export_documentation(self, output_path: str, format: str = "markdown"):
        """Export all cached documentation to file"""
        self.logger.info(f"Exporting documentation to {output_path} in {format} format")
        
        if format == "markdown":
            self._export_markdown(output_path)
        elif format == "json":
            self._export_json(output_path)
        else:
            raise ValueError(f"Unsupported export format: {format}")
    
    def _export_markdown(self, output_path: str):
        """Export documentation as Markdown"""
        with open(output_path, 'w') as f:
            f.write("# Code Documentation\n\n")
            f.write(f"Generated on: {datetime.now().isoformat()}\n\n")
            
            for doc in self.doc_cache._cache.values():
                f.write(f"## {doc.symbol_name} ({doc.symbol_kind})\n\n")
                f.write(f"{doc.description}\n\n")
                
                if doc.type_signature:
                    f.write(f"**Signature:** `{doc.type_signature}`\n\n")
                
                if doc.parameters:
                    f.write("**Parameters:**\n")
                    for param in doc.parameters:
                        f.write(f"- `{param['name']}`: {param['description']}\n")
                    f.write("\n")
                
                if doc.returns:
                    f.write(f"**Returns:** {doc.returns}\n\n")
                
                if doc.examples:
                    f.write("**Examples:**\n")
                    for example in doc.examples:
                        f.write(f"```python\n{example}\n```\n")
                    f.write("\n")
                
                f.write(f"*Last updated: {doc.last_updated.isoformat()}*\n\n")
                f.write("---\n\n")
    
    def _export_json(self, output_path: str):
        """Export documentation as JSON"""
        docs_data = []
        for doc in self.doc_cache._cache.values():
            doc_dict = {
                "symbol_name": doc.symbol_name,
                "symbol_kind": doc.symbol_kind,
                "description": doc.description,
                "type_signature": doc.type_signature,
                "parameters": doc.parameters,
                "returns": doc.returns,
                "examples": doc.examples,
                "last_updated": doc.last_updated.isoformat()
            }
            docs_data.append(doc_dict)
        
        with open(output_path, 'w') as f:
            json.dump(docs_data, f, indent=2)

class DocumentationUpdateScheduler:
    """Schedules and manages documentation updates"""
    
    def __init__(self, context7_provider: Context7LSPProvider):
        self.provider = context7_provider
        self.watch_paths: Set[str] = set()
        self.running = False
        self.logger = logging.getLogger(__name__)
    
    def add_watch_path(self, path: str):
        """Add a path to watch for changes"""
        self.watch_paths.add(path)
        self.logger.info(f"Added watch path: {path}")
    
    async def start_watching(self):
        """Start watching for file changes"""
        self.running = True
        self.logger.info("Started documentation update scheduler")
        
        # In real implementation, would use file system watcher
        # For PoC, simulate periodic updates
        while self.running:
            await asyncio.sleep(5)  # Check every 5 seconds
            
            # Simulate file changes
            mock_changes = [
                FileChange("example.py", "modified"),
                FileChange("user_manager.py", "modified")
            ]
            
            if mock_changes:
                await self.provider.auto_update_documentation(mock_changes)
    
    def stop_watching(self):
        """Stop watching for file changes"""
        self.running = False
        self.logger.info("Stopped documentation update scheduler")

# DevMethod Integration Layer

class DevMethodContext7Integration:
    """Integration layer for Context7 with DevMethod 2.0"""
    
    def __init__(self, project_root: str):
        self.project_root = project_root
        self.language_providers: Dict[Language, Context7LSPProvider] = {}
        self.scheduler = None
        self.logger = logging.getLogger(__name__)
    
    async def initialize(self, languages: List[Language]):
        """Initialize Context7 for specified languages"""
        self.logger.info(f"Initializing Context7 for languages: {languages}")
        
        for language in languages:
            lsp_client = MockLSPClient(language)
            provider = Context7LSPProvider(lsp_client)
            self.language_providers[language] = provider
        
        # Initialize scheduler
        primary_provider = next(iter(self.language_providers.values()))
        self.scheduler = DocumentationUpdateScheduler(primary_provider)
        self.scheduler.add_watch_path(self.project_root)
    
    async def generate_project_documentation(self) -> Dict[Language, List[Documentation]]:
        """Generate documentation for entire project"""
        all_docs = {}
        
        for language, provider in self.language_providers.items():
            self.logger.info(f"Generating documentation for {language.value}")
            docs = []
            
            # Get all symbols for language
            for symbol in provider.lsp.mock_symbols:
                doc = await provider.generate_symbol_documentation(symbol)
                docs.append(doc)
            
            all_docs[language] = docs
        
        return all_docs
    
    async def query_documentation(self, query: str, language: Optional[Language] = None) -> List[Documentation]:
        """Query documentation across languages or specific language"""
        results = []
        
        providers = [self.language_providers[language]] if language else self.language_providers.values()
        
        for provider in providers:
            docs = await provider.provide_contextual_docs(query)
            results.extend(docs)
        
        return results
    
    def export_all_documentation(self, output_dir: str):
        """Export documentation for all languages"""
        os.makedirs(output_dir, exist_ok=True)
        
        for language, provider in self.language_providers.items():
            output_file = os.path.join(output_dir, f"{language.value}_docs.md")
            provider.export_documentation(output_file, "markdown")
        
        # Create unified index
        self._create_documentation_index(output_dir)
    
    def _create_documentation_index(self, output_dir: str):
        """Create unified documentation index"""
        index_path = os.path.join(output_dir, "README.md")
        
        with open(index_path, 'w') as f:
            f.write("# DevMethod Project Documentation\n\n")
            f.write(f"Generated on: {datetime.now().isoformat()}\n\n")
            f.write("## Available Documentation\n\n")
            
            for language in self.language_providers.keys():
                f.write(f"- [{language.value.title()}]({language.value}_docs.md)\n")

# Example Usage and Demo

async def main():
    """Demo of Context7 PoC functionality"""
    
    # Configure logging
    logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
    logger = logging.getLogger(__name__)
    
    logger.info("Starting Context7 PoC demonstration")
    
    # Initialize DevMethod Context7 integration
    integration = DevMethodContext7Integration("/mock/project/root")
    
    # Initialize for Python (can be extended to other languages)
    await integration.initialize([Language.PYTHON])
    
    # Generate project documentation
    logger.info("Generating project documentation...")
    all_docs = await integration.generate_project_documentation()
    
    # Display generated documentation
    for language, docs in all_docs.items():
        logger.info(f"\n{language.value.upper()} Documentation Generated:")
        for doc in docs:
            logger.info(f"  - {doc.symbol_name} ({doc.symbol_kind}): {doc.description[:50]}...")
    
    # Query documentation
    logger.info("\nQuerying documentation for 'calculate'...")
    query_results = await integration.query_documentation("calculate")
    for doc in query_results:
        logger.info(f"  Found: {doc.symbol_name} - {doc.description}")
    
    # Export documentation
    output_dir = "/tmp/context7_docs"
    logger.info(f"\nExporting documentation to {output_dir}...")
    integration.export_all_documentation(output_dir)
    
    logger.info("Context7 PoC demonstration completed")

if __name__ == "__main__":
    asyncio.run(main())