#!/usr/bin/env python3
"""
Automated Documentation Update Mechanism for DevMethod 2.0
===========================================================

This module implements an automated documentation update system that:
1. Monitors file changes in real-time
2. Detects semantic changes using LSP
3. Updates documentation automatically
4. Maintains documentation consistency
5. Provides rollback capabilities
6. Integrates with DevMethod's context engineering

Based on analysis of Serena's SolidLSP implementation.
"""

import asyncio
import hashlib
import json
import os
import time
from abc import ABC, abstractmethod
from dataclasses import dataclass, field, asdict
from datetime import datetime, timedelta
from pathlib import Path
from typing import Dict, List, Optional, Set, Any, Callable, Union
from enum import Enum
import logging
import threading
import queue
from concurrent.futures import ThreadPoolExecutor

# File system monitoring
try:
    from watchdog.observers import Observer
    from watchdog.events import FileSystemEventHandler, FileModifiedEvent, FileCreatedEvent, FileDeletedEvent
    WATCHDOG_AVAILABLE = True
except ImportError:
    WATCHDOG_AVAILABLE = False

# Configuration and Types

class ChangeType(Enum):
    CREATED = "created"
    MODIFIED = "modified"
    DELETED = "deleted"
    MOVED = "moved"

class DocumentationLevel(Enum):
    MINIMAL = "minimal"        # Basic description only
    STANDARD = "standard"      # Description + parameters + return
    COMPREHENSIVE = "comprehensive"  # Everything + examples + relationships

@dataclass
class FileChangeEvent:
    """Represents a file system change event"""
    file_path: str
    change_type: ChangeType
    timestamp: datetime = field(default_factory=datetime.now)
    file_hash: Optional[str] = None
    metadata: Dict[str, Any] = field(default_factory=dict)

@dataclass
class SemanticChange:
    """Represents a semantic change detected via LSP"""
    symbol_name: str
    change_type: str  # 'added', 'modified', 'deleted', 'signature_changed'
    old_signature: Optional[str] = None
    new_signature: Optional[str] = None
    file_path: str = ""
    line_number: int = 0
    impact_level: str = "low"  # 'low', 'medium', 'high'

@dataclass
class DocumentationChangeLog:
    """Tracks changes to documentation"""
    symbol_name: str
    change_timestamp: datetime
    change_type: str
    old_content: Optional[str]
    new_content: str
    triggered_by: FileChangeEvent
    semantic_change: Optional[SemanticChange] = None

class FileMonitor(ABC):
    """Abstract base class for file monitoring"""
    
    @abstractmethod
    async def start_monitoring(self, paths: List[str], callback: Callable[[FileChangeEvent], None]):
        pass
    
    @abstractmethod
    def stop_monitoring(self):
        pass

class WatchdogFileMonitor(FileMonitor):
    """File monitor using watchdog library"""
    
    def __init__(self):
        self.observer = None
        self.event_handler = None
        self.callback = None
        self.logger = logging.getLogger(__name__)
    
    async def start_monitoring(self, paths: List[str], callback: Callable[[FileChangeEvent], None]):
        if not WATCHDOG_AVAILABLE:
            raise RuntimeError("Watchdog library not available. Install with: pip install watchdog")
        
        self.callback = callback
        self.observer = Observer()
        self.event_handler = DevMethodFileEventHandler(callback)
        
        for path in paths:
            if os.path.exists(path):
                self.observer.schedule(self.event_handler, path, recursive=True)
                self.logger.info(f"Monitoring directory: {path}")
        
        self.observer.start()
        self.logger.info("File monitoring started")
    
    def stop_monitoring(self):
        if self.observer:
            self.observer.stop()
            self.observer.join()
            self.logger.info("File monitoring stopped")

class DevMethodFileEventHandler(FileSystemEventHandler):
    """Custom file event handler for DevMethod"""
    
    def __init__(self, callback: Callable[[FileChangeEvent], None]):
        self.callback = callback
        self.logger = logging.getLogger(__name__)
        self.ignored_extensions = {'.pyc', '.pyo', '.pyd', '__pycache__', '.git', '.DS_Store'}
        self.monitored_extensions = {'.py', '.js', '.ts', '.java', '.rs', '.go', '.cpp', '.c', '.h'}
    
    def _should_process(self, file_path: str) -> bool:
        """Check if file should be processed for documentation updates"""
        path = Path(file_path)
        
        # Skip if extension is ignored
        if any(ignored in str(path) for ignored in self.ignored_extensions):
            return False
        
        # Only process monitored file types
        if path.suffix and path.suffix not in self.monitored_extensions:
            return False
        
        return True
    
    def _create_file_event(self, event, change_type: ChangeType) -> FileChangeEvent:
        """Create a FileChangeEvent from filesystem event"""
        file_hash = None
        if change_type != ChangeType.DELETED and os.path.exists(event.src_path):
            file_hash = self._calculate_file_hash(event.src_path)
        
        return FileChangeEvent(
            file_path=event.src_path,
            change_type=change_type,
            file_hash=file_hash,
            metadata={'is_directory': event.is_directory}
        )
    
    def _calculate_file_hash(self, file_path: str) -> str:
        """Calculate SHA-256 hash of file content"""
        try:
            with open(file_path, 'rb') as f:
                return hashlib.sha256(f.read()).hexdigest()
        except Exception:
            return ""
    
    def on_created(self, event):
        if not event.is_directory and self._should_process(event.src_path):
            file_event = self._create_file_event(event, ChangeType.CREATED)
            self.callback(file_event)
    
    def on_modified(self, event):
        if not event.is_directory and self._should_process(event.src_path):
            file_event = self._create_file_event(event, ChangeType.MODIFIED)
            self.callback(file_event)
    
    def on_deleted(self, event):
        if not event.is_directory and self._should_process(event.src_path):
            file_event = self._create_file_event(event, ChangeType.DELETED)
            self.callback(file_event)

class PollingFileMonitor(FileMonitor):
    """Fallback file monitor using polling"""
    
    def __init__(self, poll_interval: float = 2.0):
        self.poll_interval = poll_interval
        self.monitoring = False
        self.monitored_paths = []
        self.callback = None
        self.file_hashes = {}
        self.logger = logging.getLogger(__name__)
    
    async def start_monitoring(self, paths: List[str], callback: Callable[[FileChangeEvent], None]):
        self.monitored_paths = paths
        self.callback = callback
        self.monitoring = True
        self.logger.info(f"Started polling file monitor (interval: {self.poll_interval}s)")
        
        # Initialize file hashes
        self._scan_initial_files()
        
        # Start polling
        while self.monitoring:
            await asyncio.sleep(self.poll_interval)
            await self._poll_files()
    
    def stop_monitoring(self):
        self.monitoring = False
        self.logger.info("Stopped polling file monitor")
    
    def _scan_initial_files(self):
        """Scan initial files to establish baseline"""
        for path in self.monitored_paths:
            if os.path.isdir(path):
                for root, dirs, files in os.walk(path):
                    for file in files:
                        file_path = os.path.join(root, file)
                        if self._should_monitor(file_path):
                            self.file_hashes[file_path] = self._calculate_file_hash(file_path)
    
    async def _poll_files(self):
        """Poll files for changes"""
        current_files = set()
        
        for path in self.monitored_paths:
            if os.path.isdir(path):
                for root, dirs, files in os.walk(path):
                    for file in files:
                        file_path = os.path.join(root, file)
                        if self._should_monitor(file_path):
                            current_files.add(file_path)
                            current_hash = self._calculate_file_hash(file_path)
                            
                            if file_path not in self.file_hashes:
                                # New file
                                self.file_hashes[file_path] = current_hash
                                self.callback(FileChangeEvent(file_path, ChangeType.CREATED, file_hash=current_hash))
                            elif self.file_hashes[file_path] != current_hash:
                                # Modified file
                                self.file_hashes[file_path] = current_hash
                                self.callback(FileChangeEvent(file_path, ChangeType.MODIFIED, file_hash=current_hash))
        
        # Check for deleted files
        deleted_files = set(self.file_hashes.keys()) - current_files
        for file_path in deleted_files:
            del self.file_hashes[file_path]
            self.callback(FileChangeEvent(file_path, ChangeType.DELETED))
    
    def _should_monitor(self, file_path: str) -> bool:
        """Check if file should be monitored"""
        path = Path(file_path)
        monitored_extensions = {'.py', '.js', '.ts', '.java', '.rs', '.go', '.cpp', '.c', '.h'}
        return path.suffix in monitored_extensions
    
    def _calculate_file_hash(self, file_path: str) -> str:
        """Calculate file hash"""
        try:
            with open(file_path, 'rb') as f:
                return hashlib.sha256(f.read()).hexdigest()
        except Exception:
            return ""

class SemanticChangeDetector:
    """Detects semantic changes using LSP analysis"""
    
    def __init__(self, lsp_provider):
        self.lsp_provider = lsp_provider
        self.symbol_cache = {}  # Cache of symbol signatures
        self.logger = logging.getLogger(__name__)
    
    async def analyze_file_changes(self, file_event: FileChangeEvent) -> List[SemanticChange]:
        """Analyze file changes to detect semantic changes"""
        semantic_changes = []
        
        if file_event.change_type == ChangeType.DELETED:
            # All symbols in file are deleted
            if file_event.file_path in self.symbol_cache:
                for symbol_name in self.symbol_cache[file_event.file_path]:
                    semantic_changes.append(SemanticChange(
                        symbol_name=symbol_name,
                        change_type='deleted',
                        file_path=file_event.file_path,
                        impact_level='high'
                    ))
                del self.symbol_cache[file_event.file_path]
            
            return semantic_changes
        
        try:
            # Get current symbols from file
            file_uri = f"file://{file_event.file_path}"
            current_symbols = await self.lsp_provider.lsp.get_document_symbols(file_uri)
            
            # Get cached symbols for comparison
            cached_symbols = self.symbol_cache.get(file_event.file_path, {})
            current_symbol_map = {s.name: s for s in current_symbols}
            
            # Detect changes
            semantic_changes.extend(self._detect_added_symbols(current_symbol_map, cached_symbols, file_event.file_path))
            semantic_changes.extend(self._detect_deleted_symbols(current_symbol_map, cached_symbols, file_event.file_path))
            semantic_changes.extend(await self._detect_modified_symbols(current_symbol_map, cached_symbols, file_event.file_path))
            
            # Update cache
            self.symbol_cache[file_event.file_path] = {name: self._get_symbol_signature(symbol) 
                                                       for name, symbol in current_symbol_map.items()}
            
        except Exception as e:
            self.logger.error(f"Error analyzing semantic changes in {file_event.file_path}: {e}")
        
        return semantic_changes
    
    def _detect_added_symbols(self, current_symbols, cached_symbols, file_path):
        """Detect newly added symbols"""
        changes = []
        for name, symbol in current_symbols.items():
            if name not in cached_symbols:
                changes.append(SemanticChange(
                    symbol_name=name,
                    change_type='added',
                    new_signature=self._get_symbol_signature(symbol),
                    file_path=file_path,
                    line_number=symbol.location.range.start.line,
                    impact_level='medium'
                ))
        return changes
    
    def _detect_deleted_symbols(self, current_symbols, cached_symbols, file_path):
        """Detect deleted symbols"""
        changes = []
        for name in cached_symbols:
            if name not in current_symbols:
                changes.append(SemanticChange(
                    symbol_name=name,
                    change_type='deleted',
                    old_signature=cached_symbols[name],
                    file_path=file_path,
                    impact_level='high'
                ))
        return changes
    
    async def _detect_modified_symbols(self, current_symbols, cached_symbols, file_path):
        """Detect modified symbols by comparing signatures"""
        changes = []
        for name, symbol in current_symbols.items():
            if name in cached_symbols:
                current_sig = self._get_symbol_signature(symbol)
                cached_sig = cached_symbols[name]
                
                if current_sig != cached_sig:
                    # Get more detailed information about the change
                    change_type = await self._analyze_signature_change(symbol, cached_sig, current_sig)
                    impact_level = self._assess_change_impact(change_type)
                    
                    changes.append(SemanticChange(
                        symbol_name=name,
                        change_type=change_type,
                        old_signature=cached_sig,
                        new_signature=current_sig,
                        file_path=file_path,
                        line_number=symbol.location.range.start.line,
                        impact_level=impact_level
                    ))
        return changes
    
    def _get_symbol_signature(self, symbol) -> str:
        """Generate a signature string for a symbol"""
        # In real implementation, would extract actual signature from LSP
        return f"{symbol.name}:{symbol.kind}:{symbol.location.range.start.line}"
    
    async def _analyze_signature_change(self, symbol, old_sig, new_sig):
        """Analyze the type of signature change"""
        # Simple analysis - in real implementation would be more sophisticated
        if ":" in old_sig and ":" in new_sig:
            old_parts = old_sig.split(":")
            new_parts = new_sig.split(":")
            if len(old_parts) >= 3 and len(new_parts) >= 3:
                if old_parts[2] != new_parts[2]:  # Line number changed
                    return 'moved'
        return 'signature_changed'
    
    def _assess_change_impact(self, change_type: str) -> str:
        """Assess the impact level of a change"""
        impact_map = {
            'signature_changed': 'high',
            'moved': 'low',
            'modified': 'medium'
        }
        return impact_map.get(change_type, 'medium')

class DocumentationUpdateManager:
    """Manages automated documentation updates"""
    
    def __init__(self, context7_provider, documentation_level: DocumentationLevel = DocumentationLevel.STANDARD):
        self.context7_provider = context7_provider
        self.documentation_level = documentation_level
        self.change_log = []
        self.max_log_entries = 1000
        self.logger = logging.getLogger(__name__)
        self.rollback_data = {}  # Stores rollback information
    
    async def update_documentation(self, semantic_changes: List[SemanticChange], file_event: FileChangeEvent):
        """Update documentation based on semantic changes"""
        for change in semantic_changes:
            try:
                await self._process_semantic_change(change, file_event)
            except Exception as e:
                self.logger.error(f"Error updating documentation for {change.symbol_name}: {e}")
    
    async def _process_semantic_change(self, change: SemanticChange, file_event: FileChangeEvent):
        """Process a single semantic change"""
        self.logger.info(f"Processing semantic change: {change.symbol_name} ({change.change_type})")
        
        if change.change_type == 'deleted':
            await self._handle_symbol_deletion(change, file_event)
        elif change.change_type == 'added':
            await self._handle_symbol_addition(change, file_event)
        elif change.change_type in ['modified', 'signature_changed']:
            await self._handle_symbol_modification(change, file_event)
        elif change.change_type == 'moved':
            await self._handle_symbol_move(change, file_event)
    
    async def _handle_symbol_deletion(self, change: SemanticChange, file_event: FileChangeEvent):
        """Handle symbol deletion"""
        symbol_key = f"{change.file_path}:{change.symbol_name}"
        old_doc = self.context7_provider.doc_cache.get(symbol_key)
        
        if old_doc:
            # Store rollback data
            self.rollback_data[symbol_key] = old_doc
            
            # Remove from cache
            self.context7_provider.doc_cache._cache.pop(symbol_key, None)
            
            # Log change
            self._log_documentation_change(
                change.symbol_name,
                'deleted',
                old_doc.description if old_doc else None,
                None,
                file_event,
                change
            )
    
    async def _handle_symbol_addition(self, change: SemanticChange, file_event: FileChangeEvent):
        """Handle symbol addition"""
        # Find the symbol in the file
        file_uri = f"file://{change.file_path}"
        symbols = await self.context7_provider.lsp.get_document_symbols(file_uri)
        
        target_symbol = None
        for symbol in symbols:
            if symbol.name == change.symbol_name:
                target_symbol = symbol
                break
        
        if target_symbol:
            # Generate documentation for new symbol
            new_doc = await self.context7_provider.generate_symbol_documentation(target_symbol)
            
            # Log change
            self._log_documentation_change(
                change.symbol_name,
                'added',
                None,
                new_doc.description,
                file_event,
                change
            )
    
    async def _handle_symbol_modification(self, change: SemanticChange, file_event: FileChangeEvent):
        """Handle symbol modification"""
        symbol_key = f"{change.file_path}:{change.symbol_name}"
        old_doc = self.context7_provider.doc_cache.get(symbol_key)
        
        # Find the updated symbol
        file_uri = f"file://{change.file_path}"
        symbols = await self.context7_provider.lsp.get_document_symbols(file_uri)
        
        target_symbol = None
        for symbol in symbols:
            if symbol.name == change.symbol_name:
                target_symbol = symbol
                break
        
        if target_symbol:
            # Store rollback data
            if old_doc:
                self.rollback_data[symbol_key] = old_doc
            
            # Regenerate documentation
            new_doc = await self.context7_provider.generate_symbol_documentation(target_symbol)
            
            # Log change
            self._log_documentation_change(
                change.symbol_name,
                'modified',
                old_doc.description if old_doc else None,
                new_doc.description,
                file_event,
                change
            )
    
    async def _handle_symbol_move(self, change: SemanticChange, file_event: FileChangeEvent):
        """Handle symbol move (line number change)"""
        # For moves, we typically just update the location without regenerating docs
        symbol_key = f"{change.file_path}:{change.symbol_name}"
        existing_doc = self.context7_provider.doc_cache.get(symbol_key)
        
        if existing_doc:
            # Update timestamp to indicate freshness
            existing_doc.last_updated = datetime.now()
            
            # Log change
            self._log_documentation_change(
                change.symbol_name,
                'moved',
                None,
                None,
                file_event,
                change
            )
    
    def _log_documentation_change(self, symbol_name: str, change_type: str, 
                                  old_content: Optional[str], new_content: Optional[str],
                                  file_event: FileChangeEvent, semantic_change: SemanticChange):
        """Log a documentation change"""
        log_entry = DocumentationChangeLog(
            symbol_name=symbol_name,
            change_timestamp=datetime.now(),
            change_type=change_type,
            old_content=old_content,
            new_content=new_content,
            triggered_by=file_event,
            semantic_change=semantic_change
        )
        
        self.change_log.append(log_entry)
        
        # Limit log size
        if len(self.change_log) > self.max_log_entries:
            self.change_log = self.change_log[-self.max_log_entries:]
        
        self.logger.info(f"Documented change: {symbol_name} ({change_type})")
    
    def get_change_history(self, symbol_name: Optional[str] = None, hours: int = 24) -> List[DocumentationChangeLog]:
        """Get change history for symbol or all changes within time window"""
        cutoff_time = datetime.now() - timedelta(hours=hours)
        
        filtered_log = [log for log in self.change_log if log.change_timestamp >= cutoff_time]
        
        if symbol_name:
            filtered_log = [log for log in filtered_log if log.symbol_name == symbol_name]
        
        return sorted(filtered_log, key=lambda x: x.change_timestamp, reverse=True)
    
    async def rollback_symbol_documentation(self, symbol_name: str, file_path: str) -> bool:
        """Rollback documentation for a symbol to previous state"""
        symbol_key = f"{file_path}:{symbol_name}"
        
        if symbol_key in self.rollback_data:
            old_doc = self.rollback_data[symbol_key]
            self.context7_provider.doc_cache.update(symbol_key, old_doc)
            
            self.logger.info(f"Rolled back documentation for {symbol_name}")
            return True
        
        return False
    
    def export_change_log(self, output_path: str):
        """Export change log to file"""
        log_data = []
        for log in self.change_log:
            log_dict = asdict(log)
            # Convert datetime to string for JSON serialization
            log_dict['change_timestamp'] = log.change_timestamp.isoformat()
            log_dict['triggered_by'] = asdict(log.triggered_by)
            log_dict['triggered_by']['timestamp'] = log.triggered_by.timestamp.isoformat()
            if log.semantic_change:
                log_dict['semantic_change'] = asdict(log.semantic_change)
            log_data.append(log_dict)
        
        with open(output_path, 'w') as f:
            json.dump(log_data, f, indent=2)

class AutoDocumentationSystem:
    """Complete automated documentation system"""
    
    def __init__(self, context7_provider, project_root: str, documentation_level: DocumentationLevel = DocumentationLevel.STANDARD):
        self.context7_provider = context7_provider
        self.project_root = project_root
        self.documentation_level = documentation_level
        
        # Components
        self.file_monitor = WatchdogFileMonitor() if WATCHDOG_AVAILABLE else PollingFileMonitor()
        self.semantic_detector = SemanticChangeDetector(context7_provider)
        self.update_manager = DocumentationUpdateManager(context7_provider, documentation_level)
        
        # Event processing
        self.event_queue = queue.Queue()
        self.processing_thread = None
        self.running = False
        
        self.logger = logging.getLogger(__name__)
    
    async def start(self, watch_paths: Optional[List[str]] = None):
        """Start the automated documentation system"""
        if watch_paths is None:
            watch_paths = [self.project_root]
        
        self.running = True
        self.logger.info("Starting automated documentation system")
        
        # Start event processing thread
        self.processing_thread = threading.Thread(target=self._process_events)
        self.processing_thread.start()
        
        # Start file monitoring
        await self.file_monitor.start_monitoring(watch_paths, self._handle_file_change)
    
    def stop(self):
        """Stop the automated documentation system"""
        self.running = False
        self.logger.info("Stopping automated documentation system")
        
        # Stop file monitoring
        self.file_monitor.stop_monitoring()
        
        # Stop event processing
        if self.processing_thread:
            self.processing_thread.join()
    
    def _handle_file_change(self, file_event: FileChangeEvent):
        """Handle file change events"""
        self.event_queue.put(file_event)
    
    def _process_events(self):
        """Process file change events in background thread"""
        while self.running:
            try:
                # Get event with timeout
                file_event = self.event_queue.get(timeout=1.0)
                
                # Process in async context
                asyncio.run(self._process_file_event(file_event))
                
                self.event_queue.task_done()
                
            except queue.Empty:
                continue
            except Exception as e:
                self.logger.error(f"Error processing file event: {e}")
    
    async def _process_file_event(self, file_event: FileChangeEvent):
        """Process a single file event"""
        self.logger.debug(f"Processing file event: {file_event.file_path} ({file_event.change_type.value})")
        
        try:
            # Detect semantic changes
            semantic_changes = await self.semantic_detector.analyze_file_changes(file_event)
            
            if semantic_changes:
                self.logger.info(f"Detected {len(semantic_changes)} semantic changes in {file_event.file_path}")
                
                # Update documentation
                await self.update_manager.update_documentation(semantic_changes, file_event)
            
        except Exception as e:
            self.logger.error(f"Error processing file event for {file_event.file_path}: {e}")
    
    def get_system_status(self) -> Dict[str, Any]:
        """Get status of the documentation system"""
        return {
            "running": self.running,
            "monitored_paths": getattr(self.file_monitor, 'monitored_paths', []),
            "events_in_queue": self.event_queue.qsize() if hasattr(self.event_queue, 'qsize') else 0,
            "cached_files": len(self.semantic_detector.symbol_cache),
            "total_changes_logged": len(self.update_manager.change_log),
            "documentation_level": self.documentation_level.value
        }
    
    def get_recent_activity(self, hours: int = 1) -> Dict[str, Any]:
        """Get recent system activity"""
        recent_changes = self.update_manager.get_change_history(hours=hours)
        
        return {
            "recent_changes": len(recent_changes),
            "change_types": {change.change_type: len([c for c in recent_changes if c.change_type == change.change_type]) 
                           for change in recent_changes},
            "most_active_files": self._get_most_active_files(recent_changes),
            "latest_changes": [
                {
                    "symbol": change.symbol_name,
                    "type": change.change_type,
                    "timestamp": change.change_timestamp.isoformat(),
                    "file": change.triggered_by.file_path
                }
                for change in recent_changes[:10]
            ]
        }
    
    def _get_most_active_files(self, changes: List[DocumentationChangeLog]) -> List[Dict[str, Any]]:
        """Get files with most documentation changes"""
        file_counts = {}
        for change in changes:
            file_path = change.triggered_by.file_path
            file_counts[file_path] = file_counts.get(file_path, 0) + 1
        
        return [
            {"file": file_path, "changes": count}
            for file_path, count in sorted(file_counts.items(), key=lambda x: x[1], reverse=True)
        ][:5]

# Example usage and integration test

async def demo_auto_documentation():
    """Demo of the automated documentation system"""
    logging.basicConfig(level=logging.INFO)
    logger = logging.getLogger(__name__)
    
    # Mock Context7 provider (in real implementation, use actual provider)
    from context7_poc import Context7LSPProvider, MockLSPClient, Language
    
    lsp_client = MockLSPClient(Language.PYTHON)
    context7_provider = Context7LSPProvider(lsp_client)
    
    # Create auto documentation system
    project_root = "/tmp/demo_project"
    os.makedirs(project_root, exist_ok=True)
    
    auto_doc_system = AutoDocumentationSystem(
        context7_provider, 
        project_root, 
        DocumentationLevel.COMPREHENSIVE
    )
    
    try:
        # Start the system
        logger.info("Starting automated documentation system...")
        await auto_doc_system.start([project_root])
        
        # Simulate some file changes
        test_file = os.path.join(project_root, "test.py")
        
        # Create a file
        with open(test_file, 'w') as f:
            f.write("""
def hello_world():
    \"\"\"Print hello world message.\"\"\"
    print("Hello, World!")

class Calculator:
    \"\"\"Simple calculator class.\"\"\"
    
    def add(self, a, b):
        \"\"\"Add two numbers.\"\"\"
        return a + b
""")
        
        # Wait for processing
        await asyncio.sleep(3)
        
        # Modify the file
        with open(test_file, 'w') as f:
            f.write("""
def hello_world(name="World"):
    \"\"\"Print personalized hello message.\"\"\"
    print(f"Hello, {name}!")

class Calculator:
    \"\"\"Advanced calculator class with validation.\"\"\"
    
    def add(self, a, b):
        \"\"\"Add two numbers with type checking.\"\"\"
        if not isinstance(a, (int, float)) or not isinstance(b, (int, float)):
            raise ValueError("Arguments must be numbers")
        return a + b
    
    def multiply(self, a, b):
        \"\"\"Multiply two numbers.\"\"\"
        return a * b
""")
        
        # Wait for processing
        await asyncio.sleep(3)
        
        # Check system status
        status = auto_doc_system.get_system_status()
        logger.info(f"System status: {json.dumps(status, indent=2)}")
        
        # Check recent activity
        activity = auto_doc_system.get_recent_activity(hours=1)
        logger.info(f"Recent activity: {json.dumps(activity, indent=2)}")
        
        # Export change log
        log_file = os.path.join(project_root, "documentation_changes.json")
        auto_doc_system.update_manager.export_change_log(log_file)
        logger.info(f"Change log exported to: {log_file}")
        
    finally:
        # Stop the system
        auto_doc_system.stop()
        logger.info("Automated documentation system stopped")

if __name__ == "__main__":
    asyncio.run(demo_auto_documentation())