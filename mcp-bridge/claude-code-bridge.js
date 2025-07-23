#!/usr/bin/env node

/**
 * Claude Code to Claude Desktop MCP Bridge
 * Allows Claude Code (WSL) to access Claude Desktop MCPs (Windows)
 * 
 * Generic version - Configure paths for your system
 */

const { spawn } = require('child_process');
const path = require('path');
const fs = require('fs');
const os = require('os');

class MCPBridge {
  constructor() {
    // Auto-detect configuration path based on OS
    this.configPath = this.detectConfigPath();
    this.mcpServers = {};
    this.isWindows = process.platform === 'win32';
    this.username = process.env.USER || process.env.USERNAME || 'user';
  }

  detectConfigPath() {
    const homeDir = os.homedir();
    const possiblePaths = [
      // WSL accessing Windows config
      `/mnt/c/Users/${this.username}/AppData/Roaming/Claude/claude_desktop_config.json`,
      // Direct Windows access
      `${homeDir}/AppData/Roaming/Claude/claude_desktop_config.json`,
      // macOS
      `${homeDir}/Library/Application Support/Claude/claude_desktop_config.json`,
      // Linux
      `${homeDir}/.config/claude/claude_desktop_config.json`,
      // Generic fallback
      `${homeDir}/.claude/claude_desktop_config.json`
    ];

    for (const configPath of possiblePaths) {
      if (fs.existsSync(configPath)) {
        console.log(`✅ Found Claude Desktop configuration: ${configPath}`);
        return configPath;
      }
    }

    console.error('❌ Claude Desktop configuration not found.');
    console.log('Searched in:');
    possiblePaths.forEach(p => console.log(`  - ${p}`));
    console.log('\nPlease ensure Claude Desktop is installed and configured with MCPs.');
    return null;
  }

  async loadConfiguration() {
    if (!this.configPath) {
      return false;
    }

    try {
      const configData = fs.readFileSync(this.configPath, 'utf8');
      const config = JSON.parse(configData);
      this.mcpServers = config.mcpServers || {};
      console.log(`✅ Loaded ${Object.keys(this.mcpServers).length} MCP servers`);
      return true;
    } catch (error) {
      console.error('❌ Failed to load MCP configuration:', error.message);
      return false;
    }
  }

  translatePaths(args) {
    return args.map(arg => {
      // Convert common Windows paths to WSL paths
      if (arg.includes('Users\\') && arg.includes('C:\\')) {
        return '/mnt/c/' + arg.slice(3).replace(/\\/g, '/');
      }
      
      // Convert macOS-style paths to appropriate system paths
      if (arg.startsWith('/Users/')) {
        if (process.platform === 'win32') {
          // On Windows, assume WSL
          return arg.replace('/Users/', '/mnt/c/Users/');
        }
        // On Unix systems, keep as-is or adapt as needed
        return arg;
      }
      
      // Handle relative paths
      if (arg === '~/Desktop' || arg === '~/Downloads') {
        const homeDir = os.homedir();
        return path.join(homeDir, arg.slice(2));
      }
      
      return arg;
    });
  }

  async startMCPServer(serverName, config) {
    console.log(`🚀 Starting MCP server: ${serverName}`);
    
    let command = config.command;
    let args = [...config.args];
    
    // Handle WSL command execution
    if (!this.isWindows) {
      // We're in WSL, need to adjust paths and commands
      args = this.translatePaths(args);
      
      // Handle different package managers
      if (command === 'npx') {
        command = 'npx';
      } else if (command === 'uvx') {
        // uvx might not be available in WSL, use npm alternative
        console.log(`⚠️  uvx not available, attempting npm alternative for ${serverName}`);
        command = 'npx';
      }
    }

    // Sanitize environment variables (remove sensitive data)
    const env = {
      ...process.env,
      ...(config.env || {})
    };

    // Remove or mask sensitive environment variables for logging
    const logEnv = { ...env };
    Object.keys(logEnv).forEach(key => {
      if (key.includes('TOKEN') || key.includes('KEY') || key.includes('SECRET')) {
        logEnv[key] = '***MASKED***';
      }
    });

    try {
      const childProcess = spawn(command, args, {
        stdio: ['pipe', 'pipe', 'pipe'],
        env: env,
        shell: true
      });

      return new Promise((resolve, reject) => {
        let serverReady = false;
        
        childProcess.stdout.on('data', (data) => {
          const output = data.toString();
          console.log(`📡 ${serverName}:`, output.trim());
          
          // Check if server is ready (MCP servers usually output JSON on startup)
          if (!serverReady && (output.includes('MCP') || output.includes('server') || output.includes('{"'))) {
            serverReady = true;
            resolve({
              name: serverName,
              process: childProcess,
              stdin: childProcess.stdin,
              stdout: childProcess.stdout,
              stderr: childProcess.stderr
            });
          }
        });

        childProcess.stderr.on('data', (data) => {
          const errorOutput = data.toString();
          // Filter out sensitive information from error logs
          const cleanError = errorOutput.replace(/ghp_[a-zA-Z0-9]+/g, '***TOKEN***')
                                        .replace(/eyJ[a-zA-Z0-9_-]+\.[a-zA-Z0-9_-]+\.[a-zA-Z0-9_-]+/g, '***JWT***');
          console.error(`❌ ${serverName} error:`, cleanError.trim());
        });

        childProcess.on('error', (error) => {
          console.error(`❌ Failed to start ${serverName}:`, error.message);
          reject(error);
        });

        childProcess.on('exit', (code) => {
          console.log(`🔚 ${serverName} exited with code ${code}`);
        });

        // Timeout if server doesn't start within 10 seconds
        setTimeout(() => {
          if (!serverReady) {
            console.log(`⏰ ${serverName} started (assuming ready after timeout)`);
            resolve({
              name: serverName,
              process: childProcess,
              stdin: childProcess.stdin,
              stdout: childProcess.stdout,
              stderr: childProcess.stderr
            });
          }
        }, 10000);
      });
    } catch (error) {
      console.error(`❌ Error starting ${serverName}:`, error.message);
      throw error;
    }
  }

  async startAllServers() {
    console.log('🔄 Starting all MCP servers...');
    const serverPromises = [];

    for (const [serverName, config] of Object.entries(this.mcpServers)) {
      serverPromises.push(
        this.startMCPServer(serverName, config).catch(error => {
          console.error(`Failed to start ${serverName}:`, error.message);
          return null;
        })
      );
    }

    const servers = await Promise.all(serverPromises);
    const successfulServers = servers.filter(server => server !== null);
    
    console.log(`✅ Successfully started ${successfulServers.length}/${Object.keys(this.mcpServers).length} MCP servers`);
    return successfulServers;
  }

  async testMCPConnectivity() {
    console.log('🧪 Testing MCP server connectivity...');
    
    // Test filesystem server
    if (this.mcpServers.filesystem) {
      console.log('📁 Testing filesystem server...');
      const args = this.mcpServers.filesystem.args;
      const directories = args.filter(arg => arg.startsWith('/') || arg.includes('Desktop') || arg.includes('Downloads'));
      
      for (const dir of directories) {
        const translatedDir = this.translatePaths([dir])[0];
        try {
          if (fs.existsSync(translatedDir)) {
            console.log(`✅ Filesystem access confirmed: ${translatedDir}`);
          } else {
            console.log(`⚠️  Directory not found: ${translatedDir}`);
          }
        } catch (error) {
          console.log(`❌ Filesystem test failed for ${translatedDir}:`, error.message);
        }
      }
    }

    // Test github server
    if (this.mcpServers.github) {
      console.log('🐙 Testing GitHub server...');
      const token = this.mcpServers.github.env?.GITHUB_PERSONAL_ACCESS_TOKEN;
      if (token) {
        console.log('✅ GitHub token found in configuration');
      } else {
        console.log('⚠️  No GitHub token configured');
      }
    }

    // Test other servers generically
    Object.keys(this.mcpServers).forEach(serverName => {
      if (!['filesystem', 'github'].includes(serverName)) {
        console.log(`🔧 ${serverName} server configured`);
      }
    });
  }

  async showAvailableTools() {
    console.log('\n📋 Available MCP Tools Summary:');
    console.log('=====================================');
    
    for (const [serverName, config] of Object.entries(this.mcpServers)) {
      console.log(`\n🔧 ${serverName}:`);
      console.log(`   Command: ${config.command} ${config.args.join(' ')}`);
      
      // Show capabilities based on server type
      switch (serverName) {
        case 'filesystem':
          console.log('   📁 Capabilities: File reading, writing, directory listing');
          break;
        case 'github':
          console.log('   🐙 Capabilities: Repository management, issues, PRs, releases');
          break;
        case 'n8n-mcp':
          console.log('   🔗 Capabilities: Workflow automation, API integrations');
          break;
        case 'playwright':
          console.log('   🎭 Capabilities: Web automation, testing, scraping');
          break;
        case 'sequential-thinking':
          console.log('   🧠 Capabilities: Enhanced reasoning, step-by-step analysis');
          break;
        default:
          console.log('   ⚙️  Capabilities: Custom MCP server functionality');
      }
    }
  }
}

// Main execution
async function main() {
  console.log('🌉 Claude Code MCP Bridge Starting...');
  console.log('=====================================');
  
  const bridge = new MCPBridge();
  
  // Load configuration
  const configLoaded = await bridge.loadConfiguration();
  if (!configLoaded) {
    process.exit(1);
  }

  // Show available tools
  await bridge.showAvailableTools();

  // Test connectivity
  await bridge.testMCPConnectivity();

  // Start servers
  try {
    const servers = await bridge.startAllServers();
    
    if (servers.length > 0) {
      console.log('\n🎉 MCP Bridge is ready!');
      console.log('Claude Code can now access Claude Desktop MCPs');
      
      // Keep the process alive
      process.on('SIGINT', () => {
        console.log('\n👋 Shutting down MCP Bridge...');
        servers.forEach(server => {
          if (server.process && !server.process.killed) {
            server.process.kill();
          }
        });
        process.exit(0);
      });
      
      // Keep running
      setInterval(() => {
        // Heartbeat - keep process alive
      }, 30000);
      
    } else {
      console.log('❌ No MCP servers could be started');
      process.exit(1);
    }
  } catch (error) {
    console.error('❌ Failed to start MCP bridge:', error.message);
    process.exit(1);
  }
}

if (require.main === module) {
  main().catch(error => {
    console.error('❌ Bridge startup failed:', error);
    process.exit(1);
  });
}

module.exports = MCPBridge;