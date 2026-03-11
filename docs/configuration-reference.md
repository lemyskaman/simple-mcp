# Configuration Reference

Complete reference for all configuration files in the Simple MCP Server project.

---

## Table of Contents

1. [`.mcphost.yml` — Local Stdio Mode](#mcphostyml--local-stdio-mode)
2. [`.mcphost-http.yml` — Remote HTTP Mode](#mcphost-httyyml--remote-http-mode)
3. [`nest-cli.json` — NestJS Compiler Options](#nest-clifson--nestjs-compiler-options)
4. [`tsconfig.json` — TypeScript Configuration](#tsconfigjson--typescript-configuration)
5. [Environment Variables](#environment-variables)
6. [Custom System Prompts Guide](#custom-system-prompts-guide)

---

## `.mcphost.yml` — Local Stdio Mode

Used when running the MCP server locally as a stdio subprocess. MCPHost starts the Node.js process and communicates via stdin/stdout.

```yaml
# MCPHost configuration — Stdio (local) mode

# AI model to use (format: provider:model-name)
model: "ollama:llama3.2:1b"

# MCP Servers
mcpServers:
  simple-directory-server:
    type: "local"                          # Run as a local subprocess
    command: ["node", "dist/main.js"]      # Command to start our server
    environment:
      NODE_ENV: "production"
      DEBUG: "${env://DEBUG:-false}"       # Read from env with default

# Application settings
max-steps: 0      # 0 = unlimited tool call steps per conversation turn
debug: false      # Set to true for protocol-level debug output
stream: true      # Enable streaming responses

# Model generation parameters (tuned for Llama 3.2:1b)
max-tokens: 2048
temperature: 0.7   # 0.0 = deterministic, 1.0 = very creative
top-p: 0.95        # Nucleus sampling threshold
top-k: 40          # Top-k sampling

# System prompt
system-prompt: |
  You are a helpful assistant with access to directory listing tools.
  When asked about files or directories, use the list_directory tool.
  Always use forward slashes (/) in paths, even on Windows systems.
  current directory path is C:/Users/lemys.lopez/
```

**Key fields**:
- `type: "local"` — MCPHost spawns `node dist/main.js` as a subprocess
- `command` — the array form is preferred (avoids shell injection)
- `environment` — passed as environment variables to the subprocess
- `${env://VAR:-default}` — MCPHost's syntax for env variable with fallback

---

## `.mcphost-http.yml` — Remote HTTP Mode

Used when running the MCP server as an HTTP service (e.g., `npm run start:http`). MCPHost connects to the running server via HTTP.

```yaml
# MCPHost configuration — StreamableHTTP (remote) mode

model: "ollama:llama3.2:1b"

mcpServers:
  simple-directory-server:
    type: "remote"                         # Connect to external HTTP server
    url: "http://localhost:3000/mcp"       # HTTP endpoint
    # Optional authentication headers:
    # headers: ["Authorization: Bearer your-token-here"]

# Same application settings as local mode
max-steps: 0
debug: false
stream: true

max-tokens: 2048
temperature: 0.7
top-p: 0.95
top-k: 40

system-prompt: |
  You are a helpful assistant with access to directory listing tools.
  Always use Windows-style paths with drive letters (e.g., C:/Users/lemys.lopez).
  Current user directory is C:/Users/lemys.lopez
  Common folders:
  - Projects: C:/Users/lemys.lopez/projects
  - Desktop:  C:/Users/lemys.lopez/Desktop
  - Documents: C:/Users/lemys.lopez/Documents
  - Downloads: C:/Users/lemys.lopez/Downloads
```

**Key fields**:
- `type: "remote"` — MCPHost connects via HTTP (no subprocess)
- `url` — must point to the `/mcp` endpoint of your running HTTP server
- `headers` — optional list of HTTP headers (e.g., for Bearer auth in production)

---

## `nest-cli.json` — NestJS Compiler Options

```json
{
  "$schema": "https://json.schemastore.org/nest-cli",
  "collection": "@nestjs/schematics",
  "sourceRoot": "src",
  "compilerOptions": {
    "deleteOutDir": true
  }
}
```

| Field | Value | Description |
|-------|-------|-------------|
| `collection` | `@nestjs/schematics` | Schematics package for `nest generate` commands |
| `sourceRoot` | `src` | Root directory for TypeScript source files |
| `deleteOutDir` | `true` | Clears `dist/` before every build (clean build) |

---

## `tsconfig.json` — TypeScript Configuration

```json
{
  "compilerOptions": {
    "module": "commonjs",
    "declaration": true,
    "removeComments": true,
    "emitDecoratorMetadata": true,
    "experimentalDecorators": true,
    "allowSyntheticDefaultImports": true,
    "target": "ES2020",
    "sourceMap": true,
    "outDir": "./dist",
    "baseUrl": "./",
    "incremental": true,
    "skipLibCheck": true,
    "strictNullChecks": false,
    "noImplicitAny": false,
    "strictBindCallApply": false,
    "forceConsistentCasingInFileNames": false,
    "noFallthroughCasesInSwitch": false
  }
}
```

| Option | Value | Description |
|--------|-------|-------------|
| `module` | `commonjs` | Output CommonJS modules (required for Node.js) |
| `target` | `ES2020` | Compile to ES2020 (async/await, optional chaining, etc.) |
| `outDir` | `./dist` | Compiled output directory |
| `emitDecoratorMetadata` | `true` | Required for NestJS dependency injection |
| `experimentalDecorators` | `true` | Required for NestJS `@Module()`, `@Injectable()`, etc. |
| `sourceMap` | `true` | Generate source maps for debugging |
| `incremental` | `true` | Faster rebuilds using build cache |
| `skipLibCheck` | `true` | Skip type checking of `.d.ts` declaration files |
| `strictNullChecks` | `false` | Permissive null handling (educational project) |

---

## Environment Variables

Variables that affect application behavior at runtime:

| Variable | Default | Description |
|----------|---------|-------------|
| `NODE_ENV` | `development` | `development` or `production` — affects logging verbosity |
| `DEBUG` | `false` | Set to `true` to enable verbose service-level debug output |
| `PORT` | `3000` | HTTP server port (not yet parameterized; hardcoded in `main-http.ts`) |

**Setting in MCPHost config** (`.mcphost.yml`):
```yaml
environment:
  NODE_ENV: "production"
  DEBUG: "${env://DEBUG:-false}"  # Reads from shell env, falls back to "false"
```

**Setting manually before starting**:
```bash
# Linux/macOS
export DEBUG=true
npm run start:http

# Windows PowerShell
$env:DEBUG = "true"
npm run start:http
```

---

## Custom System Prompts Guide

The `system-prompt` field in MCPHost config files controls how Llama 3.2:1b behaves during a session. Tips for customization:

### Path Guidance
Always tell the model the current working directory and path conventions:
```yaml
system-prompt: |
  Current directory: /home/user/projects
  Use forward slashes (/) for all paths.
```

### Tool Usage Instructions
Explicitly instruct the model when to call tools:
```yaml
system-prompt: |
  When asked about files or directories, always use the list_directory tool.
  Do not guess directory contents — use the tool for accurate information.
```

### Verbosity Control
Control how much the model explains about its tool calls:
```yaml
system-prompt: |
  Be concise. When listing a directory, show the raw output without extra commentary.
```

### Development vs Production Prompts
```yaml
# Development — verbose explanations for learning
system-prompt: |
  You are an educational AI assistant demonstrating MCP.
  Explain each tool call before making it.
  Describe the path normalization steps.

# Production — minimal, task-focused
system-prompt: |
  You are a helpful assistant. Use the list_directory tool when asked about files.
  Be concise.
```

---

*See also: [Dependencies and Setup](dependencies-and-setup.md) | [Testing Guide](testing-guide.md)*
