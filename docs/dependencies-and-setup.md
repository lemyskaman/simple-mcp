# Dependencies and Setup

Complete dependency manifest and cross-platform installation guide for the Simple MCP Server project.

---

## Table of Contents

1. [Runtime Dependencies](#runtime-dependencies)
2. [Development Dependencies](#development-dependencies)
3. [External Tools](#external-tools)
4. [Windows Setup](#windows-setup)
5. [Linux Setup](#linux-setup)
6. [macOS Setup](#macos-setup)
7. [Build and Verification](#build-and-verification)

---

## Runtime Dependencies

From `package.json` — installed via `npm install`:

| Name | Version | Purpose |
|------|---------|---------|
| `@modelcontextprotocol/sdk` | ^1.17.5 | Official MCP protocol SDK — server, transports, tool registration |
| `@nestjs/common` | ^10.0.0 | NestJS core decorators, modules, DI container |
| `@nestjs/core` | ^10.0.0 | NestJS kernel — bootstrapping, application context |
| `@nestjs/platform-express` | ^10.0.0 | NestJS adapter for Express.js HTTP server |
| `cors` | ^2.8.5 | CORS middleware — required for MCPHost HTTP connections |
| `express` | ^5.1.0 | HTTP server framework (used internally by NestJS) |
| `reflect-metadata` | ^0.1.13 | TypeScript decorator metadata — required by NestJS DI |
| `rxjs` | ^7.8.1 | Reactive extensions — used internally by NestJS |
| `zod` | ^3.25.76 | Schema validation — tool parameter validation |

---

## Development Dependencies

| Name | Version | Purpose |
|------|---------|---------|
| `@nestjs/cli` | ^10.0.0 | NestJS CLI — `nest build`, `nest start`, code generation |
| `@nestjs/schematics` | ^10.0.0 | NestJS code generation schematics |
| `@nestjs/testing` | ^10.0.0 | NestJS testing utilities |
| `@types/cors` | ^2.8.17 | TypeScript types for cors package |
| `@types/express` | ^4.17.17 | TypeScript types for Express |
| `@types/jest` | ^29.5.2 | TypeScript types for Jest |
| `@types/node` | ^20.3.1 | TypeScript types for Node.js built-ins |
| `@typescript-eslint/eslint-plugin` | ^6.0.0 | ESLint rules for TypeScript |
| `@typescript-eslint/parser` | ^6.0.0 | TypeScript parser for ESLint |
| `eslint` | ^8.42.0 | JavaScript/TypeScript linter |
| `eslint-config-prettier` | ^9.0.0 | Disables ESLint rules that conflict with Prettier |
| `eslint-plugin-prettier` | ^5.0.0 | Runs Prettier as an ESLint rule |
| `jest` | ^29.5.0 | Test framework |
| `prettier` | ^3.0.0 | Code formatter |
| `source-map-support` | ^0.5.21 | Source map support for Node.js stack traces |
| `supertest` | ^6.3.3 | HTTP testing library for integration tests |
| `ts-jest` | ^29.1.0 | TypeScript preprocessor for Jest |
| `ts-loader` | ^9.4.3 | TypeScript loader for webpack |
| `ts-node` | ^10.9.1 | TypeScript execution for Node.js (used in development) |
| `tsconfig-paths` | ^4.2.0 | Module path aliases for TypeScript |
| `typescript` | ^5.1.3 | TypeScript compiler |

---

## External Tools

These tools are required but not managed by `npm`. They must be installed separately.

| Tool | Min Version | Purpose |
|------|------------|---------|
| Node.js | v18+ | JavaScript runtime for the MCP server |
| npm | v9+ | Bundled with Node.js — manages project dependencies |
| Go | v1.21+ | Required to install MCPHost via `go install` |
| Git | Any | Version control + provides Git Bash on Windows |
| Git Bash | (part of Git) | Windows: Unix-compatible shell for `ls` commands |
| Ollama | v0.11+ | Local LLM runtime — hosts Llama 3.2:1b |
| MCPHost | latest | Go-based MCP client that connects Ollama to MCP servers |

---

## Windows Setup

### 1. Install Node.js (v18+)

```powershell
# Download from https://nodejs.org or use winget
winget install OpenJS.NodeJS

# Verify
node --version  # Should show v18.x.x or higher
npm --version
```

### 2. Install Git (includes Git Bash)

```powershell
winget install Git.Git

# Verify Git Bash is available
Test-Path "C:\Program Files\Git\bin\bash.exe"  # Should return True
```

### 3. Install Go (required for MCPHost)

```powershell
winget install GoLang.Go

# Verify
go version  # Should show go version 1.21+

# Add Go bin to PATH if not already done
$env:PATH += ";$env:USERPROFILE\go\bin"
[Environment]::SetEnvironmentVariable("PATH", $env:PATH, "User")
```

### 4. Install MCPHost

```powershell
go install github.com/mark3labs/mcphost@latest

# Verify (restart PowerShell if "command not found")
mcphost --version
```

### 5. Install Ollama

```powershell
# Download from https://ollama.ai/download/windows and run the installer
# Or via PowerShell:
Invoke-WebRequest -Uri "https://ollama.ai/download/windows" -OutFile "OllamaSetup.exe"
Start-Process -FilePath "OllamaSetup.exe" -Wait

ollama --version
```

### 6. Download Llama 3.2:1b Model

```powershell
# Start Ollama service (usually auto-starts after installation)
ollama serve

# In another PowerShell window
ollama pull llama3.2:1b
ollama list  # Should show llama3.2:1b
```

---

## Linux Setup

### 1. Install Node.js (v18+)

```bash
# Using NodeSource repository
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

node --version
npm --version
```

### 2. Install Git

```bash
sudo apt-get update && sudo apt-get install -y git
git --version
```

### 3. Install Go (required for MCPHost)

```bash
# Remove old installation if present
sudo rm -rf /usr/local/go

# Download and install
wget https://go.dev/dl/go1.21.5.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.21.5.linux-amd64.tar.gz

# Add to PATH
echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> ~/.bashrc
source ~/.bashrc

go version
```

### 4. Install MCPHost

```bash
go install github.com/mark3labs/mcphost@latest

# If "command not found", ensure $HOME/go/bin is in PATH
mcphost --version
```

### 5. Install Ollama

```bash
curl -fsSL https://ollama.ai/install.sh | sh
ollama --version
ollama serve &
```

### 6. Download Llama 3.2:1b Model

```bash
ollama pull llama3.2:1b
ollama list
```

---

## macOS Setup

### 1. Install Node.js (v18+)

```bash
# Using Homebrew (install from https://brew.sh first)
brew install node
node --version
```

### 2. Install Git

```bash
brew install git
git --version
```

### 3. Install Go

```bash
brew install go
go version
```

### 4. Install MCPHost

```bash
go install github.com/mark3labs/mcphost@latest
mcphost --version
```

### 5. Install Ollama

```bash
brew install ollama
# Or download from https://ollama.ai
ollama --version
ollama serve &
```

### 6. Download Llama 3.2:1b Model

```bash
ollama pull llama3.2:1b
ollama list
```

---

## Build and Verification

### Install Project Dependencies

```bash
# From the project root
npm install
```

### Build the Project

```bash
npm run build
# Compiles TypeScript → dist/
```

### Verify the Build

```bash
# Linux/macOS
ls -la dist/main.js       # Stdio entry point
ls -la dist/main-http.js  # HTTP entry point

# Windows PowerShell
Test-Path "dist/main.js"       # Should return True
Test-Path "dist/main-http.js"  # Should return True
```

### Available npm Scripts

| Script | Command | Description |
|--------|---------|-------------|
| Build | `npm run build` | Compile TypeScript to `dist/` |
| Start (stdio) | `npm run start:stdio` | Start the stdio MCP server |
| Start (HTTP) | `npm run start:http` | Start the HTTP MCP server on port 3000 |
| Dev mode | `npm run start:dev` | Start with file watching |
| Test | `npm test` | Run Jest test suite |
| Lint | `npm run lint` | Run ESLint with auto-fix |

---

*See also: [Configuration Reference](configuration-reference.md) | [Testing Guide](testing-guide.md)*
