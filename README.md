# Simple MCP Server

An educational NestJS + TypeScript project teaching how to build a **distributed, production-grade MCP server** — where the AI client and the tool server run as independent processes over a network. Implements both **stdio** (local) and **StreamableHTTP** (remote/production) transports using Ollama + MCPHost + Llama 3.2:1b.

Extended documentation lives in the [`docs/`](docs/) folder.

---

## What This Project Teaches

The core lesson is **distributed MCP architecture**: using the StreamableHTTP transport, the MCP server and the AI client (MCPHost + Ollama) are completely decoupled processes. The server can run on a different machine, inside a Docker container, or behind a load balancer — the client connects to it over HTTP just like any other remote API. This is the foundation of production MCP deployments.

The project walks through the full journey: starting with a simple local stdio server (client and server in the same process), then migrating to the HTTP transport and solving the real distributed-systems challenges that come with it — session management across requests, CORS, host header validation, and schema-driven tool contracts. Every decision is documented with the reasoning behind it.

The tool exposed (`list_directory`) is intentionally simple so the focus stays on the protocol and architecture, not the business logic. The same patterns apply to any tool you build on top.

---

## What This Project Does

This server gives a local Ollama model the ability to **browse the filesystem** of the machine where the MCP server is running. When you ask a question that requires knowing what files exist somewhere, the model calls the server's tool, gets the directory listing back, and uses it to answer you — all transparently.

### Available Tools

| Tool | What it does | Input |
|------|-------------|-------|
| `list_directory` | Runs `ls` on the server's filesystem and returns the directory contents as text | `path` — the directory path to list |

### Example Interaction

```
You:       What's inside my projects folder?
Ollama:    [calls list_directory with path="/home/youruser/projects"]
Server:    simple-mcp/  other-project/  notes.txt
Ollama:    Your projects folder contains: simple-mcp, other-project, and notes.txt.
```

The key point: the model **never sees the filesystem directly** — it only sees what the tool returns. The server controls what is exposed and how. This is the MCP security boundary in action.

> New tools (read file, write file, search, run commands, etc.) can be added by registering them in `src/mcp/mcp.service.ts`. See [docs/architecture.md](docs/architecture.md) for how tool registration works.

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
