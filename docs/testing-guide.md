# Testing Guide

Complete guide for testing the Simple MCP Server in all modes.

---

## Table of Contents

1. [Quick Start (3 Commands)](#quick-start-3-commands)
2. [Stdio Mode Testing](#stdio-mode-testing)
3. [HTTP Mode Testing](#http-mode-testing)
4. [Bruno Collection](#bruno-collection)
5. [Postman Collection](#postman-collection)
6. [MCPHost Interactive Commands](#mcphost-interactive-commands)
7. [Debugging Guide](#debugging-guide)
8. [Troubleshooting FAQ](#troubleshooting-faq)

---

## Quick Start (3 Commands)

```bash
# 1. Build the project
npm run build

# 2. Start the HTTP server
npm run start:http

# 3. Connect MCPHost (in a second terminal)
mcphost --config .mcphost-http.yml
```

For stdio mode replace steps 2–3 with:
```bash
mcphost --config .mcphost.yml
```

---

## Stdio Mode Testing

### With MCPHost

```bash
# Start MCPHost — it automatically spawns node dist/main.js as a subprocess
mcphost --config .mcphost.yml
```

You should see MCPHost start and the tool become available.

### Manual JSON-RPC via stdin

Start the server directly and type JSON-RPC commands:

```bash
node dist/main.js
```

Then type (and press Enter after each line):

```json
{"jsonrpc":"2.0","id":1,"method":"tools/list"}
```

Expected response:
```json
{"jsonrpc":"2.0","id":1,"result":{"tools":[{"name":"list_directory",...}]}}
```

Call the tool:
```json
{"jsonrpc":"2.0","id":2,"method":"tools/call","params":{"name":"list_directory","arguments":{"path":"."}}}
```

### Automated Startup Scripts

```powershell
# Windows — rebuild and start
.\restart.ps1
```

```bash
# Linux/macOS
./restart.sh
```

---

## HTTP Mode Testing

### Start the HTTP Server

```bash
npm run start:http
# Server available at http://localhost:3000/mcp
```

### Test with curl

**Discover tools:**
```bash
curl -X POST http://localhost:3000/mcp \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}}}'
```

**Direct REST endpoint (no MCP needed):**
```bash
curl "http://localhost:3000/directory/list?path=."
```

### Test with MCPHost

```bash
# Terminal 1 — start server
npm run start:http

# Terminal 2 — connect MCPHost
mcphost --config .mcphost-http.yml
```

### Windows Scripts

```powershell
# Start HTTP server
.\start-http-server.ps1

# Start MCPHost with HTTP config (separate terminal)
.\start-http-mcphost.ps1   # Starts both server + MCPHost
```

---

## Bruno Collection

A Bruno API collection is included for testing the HTTP transport interactively.

**Location**: `src/bruno-collections/MCP HTTP StreamableTransport Collection/`

**Usage**:
1. Open [Bruno](https://www.usebruno.com/) (free API client)
2. Import the collection folder
3. Select the **MCP HTTP Local Development** environment
4. Run requests in order:
   - `01. Initialize MCP Session`
   - `02. List Available Tools`
   - `03. Execute List Directory Tool`
   - `04. Execute Tool with Root Path`
   - `05. Delete MCP Session`

**Prerequisites**: HTTP server must be running (`npm run start:http`) before running the collection.

---

## Postman Collection

A Postman collection is also included.

**Location**: `src/postmant-collections/`

Files:
- `MCP-HTTP-StreamableTransport.postman_collection.json` — collection
- `MCP-HTTP-Local.postman_environment.json` — local environment

**Usage**:
1. Open Postman
2. Import the collection JSON
3. Import the environment JSON and select it
4. Run requests following the numbered order

See `src/postmant-collections/README.md` for detailed notes.

---

## MCPHost Interactive Commands

Once MCPHost is running, use these built-in commands:

| Command | Description |
|---------|-------------|
| `/help` | Show all available commands |
| `/tools` | List available MCP tools |
| `/models` | Show available AI models |
| `/config` | Show current configuration |
| `/debug` | Toggle debug mode on/off |
| `/clear` | Clear conversation history |
| `/quit` | Exit MCPHost |

### Example Session

```
$ mcphost --config .mcphost-http.yml

You: /tools
Assistant: Available tools:
  - list_directory: List contents of a directory using Git Bash ls command

You: List the files in my home directory
Assistant: I'll check the contents of your home directory.
[calls list_directory with path: "C:/Users/lemys.lopez"]
Here are the files in your home directory:
drwxr-xr-x  Downloads
drwxr-xr-x  Projects
...

You: /quit
```

---

## Debugging Guide

### Enable Debug Mode

```powershell
# Windows
$env:DEBUG = "true"
$env:NODE_ENV = "development"
mcphost --debug --config .mcphost.yml
```

```bash
# Linux/macOS
DEBUG=true NODE_ENV=development mcphost --debug --config .mcphost.yml
```

### Log Locations

| Mode | Where to find logs |
|------|-------------------|
| Stdio mode | Directly in the MCPHost terminal output |
| HTTP mode | Terminal running `npm run start:http` |
| MCPHost protocol logs | Use `--debug` flag with MCPHost |

### Single-command Test (no interactive session)

```bash
mcphost --config .mcphost-http.yml -p "List files in ."
```

---

## Troubleshooting FAQ

**Q: MCPHost can't find our server**
```bash
# Verify the build exists
ls dist/main.js
# Rebuild if missing
npm run build
```

**Q: Git Bash not found (Windows)**
```powershell
# Check if Git Bash is installed
Test-Path "C:\Program Files\Git\bin\bash.exe"
# Install Git from https://git-scm.com if not found
```

**Q: Ollama connection problems**
```bash
# Check model is available
ollama list                 # Should show llama3.2:1b
ollama serve               # Start Ollama if not running
ollama run llama3.2:1b    # Quick test of the model
```

**Q: Path handling errors / unexpected paths**
```bash
# Enable debug to see path processing
DEBUG=true mcphost --debug --config .mcphost.yml
```

**Q: CORS errors when testing HTTP mode with curl/Postman**

Make sure the server started via `npm run start:http` (not `npm start`) — the HTTP entry point configures CORS correctly.

**Q: `mcphost` command not found after `go install`**
```bash
# Add Go bin directory to PATH
echo 'export PATH=$PATH:$HOME/go/bin' >> ~/.bashrc
source ~/.bashrc
```

**Q: Port 3000 already in use**
```bash
# Find what is using port 3000
lsof -i :3000          # Linux/macOS
netstat -ano | findstr 3000  # Windows
```

---

*See also: [Configuration Reference](configuration-reference.md) | [MCP Protocol Guide](mcp-protocol-guide.md)*
