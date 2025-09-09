# Simple MCP Directory Server with MCPHost

This project is a minimal Model Context Protocol (MCP) server built with NestJS that integrates with **MCPHost** for seamless AI model interaction. It exposes a tool to list directory contents using the `ls` command via Git Bash on Windows, designed for use with **Llama 3.2:1b** through MCPHost.

## Features
- **MCP server** with stdio transport protocol
- **Tool**: `list_directory` - Lists contents of any directory
- **Git Bash integration** - Uses `ls` command on Windows
- **MCPHost integration** - No complex Ollama configuration needed
- **Llama 3.2:1b optimized** - Configured for the 1b parameter model
- **Simple configuration** - Single YAML config file

## Prerequisites

### Required Software
- **Node.js** (v18+ recommended) - [Download](https://nodejs.org)
- **npm** (comes with Node.js)
- **Git Bash** - [Download Git for Windows](https://git-scm.com)
- **Ollama** - [Download](https://ollama.ai) 
- **MCPHost** - [GitHub Repository](https://github.com/mark3labs/mcphost)

### Installation Steps

1. **Install MCPHost**
   ```powershell
   go install github.com/mark3labs/mcphost@latest
   ```

2. **Install Ollama and Llama 3.2:1b**
   ```powershell
   # Install Ollama, then pull the model
   ollama pull llama3.2:1b
   ```

3. **Verify Git Bash location**
   ```powershell
   Test-Path "C:\Program Files\Git\bin\bash.exe"
   ```

## Project Setup

1. **Clone and Install**
   ```powershell
   git clone <your-repo-url>
   cd simple-mcp
   npm install
   ```

2. **Build the project**
   ```powershell
   npm run build
   ```

## Quick Start

### Method 1: Automated Startup (Recommended)

**Use the provided PowerShell script:**
```powershell
.\start-mcphost.ps1
```

**Or use the restart script:**
```powershell
.\restart.ps1
```

**For Git Bash users:**
```bash
./restart.sh
```

### Method 2: Manual Startup

1. **Build the MCP server**
   ```powershell
   npm run build
   ```

2. **Start Ollama service**
   ```powershell
   ollama serve
   ```

3. **Start MCPHost** (in a new terminal)
   ```powershell
   mcphost
   ```

MCPHost will automatically load the MCP server using the `.mcphost.yml` configuration.

## Configuration

The project includes a pre-configured `.mcphost.yml` file optimized for Llama 3.2:1b:

```yaml
# Model Configuration
model: "ollama:llama3.2:1b"

# MCP Servers Configuration  
mcpServers:
  simple-directory-server:
    type: "local"
    command: ["node", "dist/main.js"]
    environment:
      NODE_ENV: "production"
      DEBUG: "${env://DEBUG:-false}"

# Model parameters optimized for Llama 3.2:1b
max-tokens: 2048
temperature: 0.7
top-p: 0.95
top-k: 40
```

## Available Tool

### `list_directory`
- **Description:** Lists contents of a directory using Git Bash `ls` command
- **Input:** 
  - `path` (string): Directory path to list (e.g., `"C:/Users"`, `"."`)
- **Output:** Directory listing with file details in `ls -l` format

**Example usage in MCPHost:**
```
You: List the files in C:/Users
AI: I'll list the contents of the C:/Users directory for you.
[Uses list_directory tool]
```

## MCPHost Integration

### Why MCPHost?

MCPHost provides a better integration experience compared to direct Ollama configuration:

- ✅ **No complex JSON configuration** - Simple YAML config
- ✅ **Reliable MCP protocol support** - Better than Ollama's experimental MCP support  
- ✅ **Built-in tool discovery** - Automatically detects available tools
- ✅ **Better error handling** - Clear error messages and debugging
- ✅ **Environment variable support** - Flexible configuration options
- ✅ **Multiple model support** - Easy to switch between models

### MCPHost Commands

When running MCPHost, you have access to these interactive commands:

- **`/help`** - Show all available commands
- **`/tools`** - List all available MCP tools 
- **`/servers`** - Show configured MCP servers
- **`/quit`** - Exit MCPHost
- **`Ctrl+C`** - Exit at any time

### Testing the Integration

1. **Start MCPHost**
   ```powershell
   mcphost
   ```

2. **Check available tools**
   ```
   /tools
   ```
   You should see `list_directory` in the output.

3. **Test the tool**
   ```
   Can you list the files in C:/Users?
   ```

4. **Example conversations:**
   - "Show me what's in the current directory"
   - "List all files in my Documents folder"  
   - "What files are in C:/Program Files?"

## Testing and Verification

### 1. Test MCP Server Directly
```powershell
# Test the server independently
node dist/main.js
```
You should see: `"Simple MCP Directory Server running on stdio"`

### 2. Test with MCPHost
```powershell
# Start mcphost
mcphost

# In MCPHost, check tools
/tools

# Test the directory tool
Can you list the files in the current directory?
```

### 3. Verify Prerequisites
```powershell
# Check all required software
node --version        # Should be v18+
npm --version        # Should be present
ollama --version     # Should be installed
mcphost --version    # Should be installed
ollama list          # Should show llama3.2:1b

# Check Git Bash
Test-Path "C:\Program Files\Git\bin\bash.exe"  # Should return True
```

## Configuration Files

### Primary Configuration: `.mcphost.yml`

The main configuration file for MCPHost integration:

```yaml
# Model Configuration
model: "ollama:llama3.2:1b"

# MCP Servers Configuration
mcpServers:
  simple-directory-server:
    type: "local"
    command: ["node", "dist/main.js"]
    environment:
      NODE_ENV: "production"
      DEBUG: "${env://DEBUG:-false}"

# Application settings
max-steps: 0  # Unlimited steps
debug: false
stream: true

# Model generation parameters optimized for Llama 3.2:1b
max-tokens: 2048
temperature: 0.7
top-p: 0.95
top-k: 40
```

### Legacy Configuration: `ollama-mcp-config.json`

**Note:** This file is kept for reference but is **no longer needed** with MCPHost integration.

The old Ollama configuration approach required complex JSON setup in:
- `%APPDATA%\Ollama\config.json`

MCPHost eliminates this complexity by managing MCP servers directly.

### Environment Variables (Optional)

You can customize behavior using environment variables:

```powershell
# Enable debug mode
$env:DEBUG = "true"

# Then start MCPHost
mcphost
```

## Project Structure
```
src/
  app.module.ts           # Main NestJS module
  main.ts                # MCP server entry point with stdio transport
  directory/
    directory.controller.ts  # REST controller (for HTTP access)
    directory.module.ts     # NestJS module configuration  
    directory.service.ts    # Service that handles Git Bash ls command
dist/                    # Compiled TypeScript files
.mcphost.yml             # MCPHost configuration (primary)
ollama-mcp-config.json   # Legacy Ollama config (reference only)
start-mcphost.ps1        # Full setup and startup script
restart.ps1              # Quick restart script (PowerShell)
restart.sh               # Quick restart script (Bash)
package.json             # Node.js dependencies and scripts
README.md                # This documentation
```

## Troubleshooting Guide

### MCPHost Issues

**Problem**: `mcphost` command not found
**Solution**:
```powershell
# Install MCPHost
go install github.com/mark3labs/mcphost@latest

# Verify Go is in PATH
go version

# Make sure Go bin is in PATH
$env:PATH += ";$(go env GOPATH)\bin"
```

**Problem**: "No tools available" in MCPHost
**Solution**:
1. Verify `.mcphost.yml` exists in project directory
2. Check MCP server builds successfully:
   ```powershell
   npm run build
   Test-Path "dist/main.js"  # Should return True
   ```
3. Test MCP server directly:
   ```powershell
   node dist/main.js
   # Should output: "Simple MCP Directory Server running on stdio"
   ```

**Problem**: MCPHost can't connect to Ollama
**Solution**:
1. Ensure Ollama is running:
   ```powershell
   ollama serve
   ```
2. Verify Llama 3.2:1b is available:
   ```powershell
   ollama list | Select-String "llama3.2:1b"
   ```
3. Test Ollama directly:
   ```powershell
   ollama run llama3.2:1b
   ```

### MCP Server Issues

**Problem**: `Error listing directory: spawn ENOENT`
**Solution**:
1. Verify Git Bash installation:
   ```powershell
   Test-Path "C:\Program Files\Git\bin\bash.exe"
   ```
2. If Git Bash is elsewhere, find and update path:
   ```powershell
   # Find Git Bash
   Get-Command bash -ErrorAction SilentlyContinue
   
   # Update src/directory/directory.service.ts with correct path
   # Then rebuild: npm run build
   ```

**Problem**: Permission denied accessing directories
**Solution**:
1. Run PowerShell as Administrator
2. Test directory access manually:
   ```powershell
   & "C:\Program Files\Git\bin\bash.exe" -c "ls -l C:\Users"
   ```

### Build and Development Issues

**Problem**: TypeScript compilation errors
**Solution**:
1. Clean install dependencies:
   ```powershell
   Remove-Item node_modules -Recurse -Force
   Remove-Item package-lock.json -Force
   npm install
   npm run build
   ```

**Problem**: Node.js version conflicts
**Solution**:
1. Check Node.js version:
   ```powershell
   node --version  # Should be v18+
   ```
2. Update if needed from [nodejs.org](https://nodejs.org)

### Quick Diagnostic Commands

```powershell
# Check all prerequisites
node --version
npm --version
ollama --version
mcphost --version
ollama list | Select-String "llama3.2"
Test-Path "C:\Program Files\Git\bin\bash.exe"
Test-Path ".mcphost.yml"
Test-Path "dist/main.js"

# Test components
npm run build
node dist/main.js  # Should show server startup message
```

### Debug Mode

Enable debug logging:
```powershell
# Set debug environment variable
$env:DEBUG = "true"

# Start MCPHost with debug info
mcphost --debug
```

### Getting Help

If issues persist:
1. Use the automated startup script: `.\start-mcphost.ps1`
2. Check MCPHost documentation: [GitHub](https://github.com/mark3labs/mcphost)
3. Verify all prerequisites are properly installed
4. Test each component independently before integration

## Example Usage with MCPHost

### 1. Quick Start
```powershell
# Use the automated script
.\start-mcphost.ps1
```

### 2. Manual Start
```powershell
# Terminal 1: Start Ollama
ollama serve

# Terminal 2: Start MCPHost
mcphost
```

### 3. Example Conversations

**Basic directory listing:**
```
You: List the files in the current directory
AI: I'll list the contents of the current directory for you.
[MCPHost automatically calls list_directory tool with path: "."]
```

**Specific path:**
```
You: Show me what's in C:/Users
AI: I'll show you the contents of C:/Users directory.
[Uses list_directory tool with path: "C:/Users"]
```

**Natural language:**
```
You: What files are in my Documents folder?
AI: I'll check your Documents folder for you.
[Translates to appropriate path and uses list_directory tool]
```

### 4. MCPHost Interactive Features

- **Auto-completion** - Type `/` and press Tab for commands
- **Tool discovery** - Use `/tools` to see available tools
- **History** - Previous conversations are remembered
- **Streaming responses** - See AI responses in real-time

## Summary

This project demonstrates a complete MCP (Model Context Protocol) integration using:

- **NestJS MCP Server** - Provides directory listing functionality
- **MCPHost** - Manages AI model and MCP server integration  
- **Ollama + Llama 3.2:1b** - Local AI model execution
- **Git Bash** - Cross-platform `ls` command execution on Windows

### Key Benefits of MCPHost Integration

- ✅ **Simplified setup** - No complex Ollama JSON configuration
- ✅ **Reliable protocol** - Better MCP support than direct Ollama integration
- ✅ **Easy debugging** - Clear error messages and tool discovery
- ✅ **Flexible configuration** - YAML-based config with environment variables
- ✅ **Better user experience** - Interactive commands and streaming responses

### Quick Reference

| Command | Purpose |
|---------|---------|
| `.\start-mcphost.ps1` | Full automated setup and start |
| `.\restart.ps1` | Quick restart (PowerShell) |
| `.\restart.sh` | Quick restart (Bash) |
| `mcphost` | Start MCPHost manually |
| `/tools` | List available tools in MCPHost |
| `/quit` | Exit MCPHost |

### Next Steps

- Extend the MCP server with additional tools (file reading, writing, etc.)
- Add more sophisticated directory operations
- Integrate with other MCP servers for expanded functionality
- Explore MCPHost's scripting capabilities for automation

## License
MIT
