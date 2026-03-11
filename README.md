# Simple MCP Server

An educational NestJS + TypeScript server demonstrating the **Model Context Protocol (MCP)** — how Large Language Models call external tools. Implements both **stdio** (local) and **StreamableHTTP** (remote/production) transports using Ollama + MCPHost + Llama 3.2:1b.

Extended documentation lives in the [`docs/`](docs/) folder.

---

## What This Project Demonstrates

The Simple MCP Server exposes a `list_directory` tool that allows an LLM (Llama 3.2:1b running locally via Ollama) to browse the filesystem on your behalf. The project covers the full development journey: starting with a local stdio server, migrating to a remote HTTP transport, and working through real integration challenges (session management, CORS, schema validation). Every architectural decision is documented.

This is a teaching resource — not a production system. It is designed for developers learning MCP, educators demonstrating AI tool integration, and engineers evaluating NestJS for MCP server implementation.

---

## Quick Start

**Prerequisites**: Node.js v18+, Go v1.21+, Git, Ollama with `llama3.2:1b` pulled, MCPHost installed.
See [docs/dependencies-and-setup.md](docs/dependencies-and-setup.md) for full installation instructions.

```bash
# 1. Install dependencies and build
npm install && npm run build

# 2a. Start in stdio mode (MCPHost manages the server process)
mcphost --config .mcphost.yml

# 2b. Or start in HTTP mode (two terminals)
npm run start:http              # Terminal 1 — starts server on :3000
mcphost --config .mcphost-http.yml  # Terminal 2 — connects MCPHost
```

---

## Usage

### Stdio Mode (Local Development)

MCPHost spawns the Node.js server as a subprocess and communicates via stdin/stdout:

```yaml
# .mcphost.yml
mcpServers:
  simple-directory-server:
    type: "local"
    command: ["node", "dist/main.js"]
```

```bash
mcphost --config .mcphost.yml
# You: List the files in my projects folder
# Assistant: [calls list_directory] ...
```

### HTTP Mode (Remote / Production)

Start the HTTP server independently; MCPHost connects to it via StreamableHTTP:

```yaml
# .mcphost-http.yml
mcpServers:
  simple-directory-server:
    type: "remote"
    url: "http://localhost:3000/mcp"
```

```bash
npm run start:http
mcphost --config .mcphost-http.yml
```

---

## Documentation

| Document | Description |
|----------|-------------|
| [Project Overview](docs/project-overview.md) | Abstract, target audience, learning objectives |
| [Architecture](docs/architecture.md) | NestJS module structure, entry points, design patterns |
| [MCP Protocol Guide](docs/mcp-protocol-guide.md) | Transports, request flow, JSON-RPC examples |
| [Design Decisions](docs/design-decisions.md) | ADRs: NestJS, StreamableHTTP, Llama 3.2:1b, MCPHost, Git Bash |
| [Development Process](docs/development-process.md) | Challenges solved, production AWS architecture |
| [Dependencies and Setup](docs/dependencies-and-setup.md) | All dependencies with versions; Windows/Linux/macOS setup |
| [Configuration Reference](docs/configuration-reference.md) | Annotated config files and environment variables |
| [Testing Guide](docs/testing-guide.md) | Quick start, curl/Bruno/Postman testing, debugging, FAQ |

---

## Project Structure

```
src/
├── app.module.ts              # Root NestJS module
├── main.ts                    # Stdio entry point
├── main-http.ts               # HTTP entry point (port 3000)
├── root-mcp.controller.ts     # POST/GET/DELETE /mcp handlers
├── directory/
│   ├── directory.module.ts
│   ├── directory.service.ts   # Git Bash ls -la logic
│   └── directory.controller.ts
└── mcp/
    ├── mcp.module.ts
    ├── mcp.service.ts         # StreamableHTTP session management
    └── mcp.controller.ts

.mcphost.yml                   # MCPHost config — stdio mode
.mcphost-http.yml              # MCPHost config — HTTP mode
docs/                          # Extended documentation
```

---

## License

MIT — free to use for learning and teaching.

## Contributing

Contributions welcome: improve documentation, fix bugs, add educational examples, or create additional learning exercises.
