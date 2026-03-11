# Git History

Project creation timeline derived from `git log --oneline --all`.

*Author*: lemys Lopez — September 2025

---

## Chronological Timeline

| Date | Commit | Branch | Message |
|------|--------|--------|---------|
| 2025-09-09 10:56 | `d49f0ec` | `main` | first commit |
| 2025-09-09 12:26 | `5cadd56` | `feature/stedio-transport` | styating script for windows ready |
| 2025-09-09 12:39 | `325363b` | `feature/stedio-transport` | working example |
| 2025-09-09 12:40 | `61fd027` | `feature/stedio-transport` | pdf add to process |
| 2025-09-11 15:40 | `fde43fb` | `feature/http-streamable-transport` | done with remote |
| 2025-09-11 18:14 | `8cfb2c4` | `feature/http-streamable-transport` | all the information |
| 2025-09-15 16:59 | `e8477f2` | `feature/postman-collection` | adding postman collection to test |
| 2025-09-17 06:58 | `6ed39cd` | `docs/improoving` | .update |

---

## Development Phases

### Phase 1 — Foundation (2025-09-09)

**Branch**: `main` → `feature/stedio-transport`
**Commits**: `d49f0ec`, `5cadd56`, `325363b`, `61fd027`

The project started with a single commit establishing the basic NestJS structure and then immediately moved into the stdio transport feature branch. Key milestones in this phase:

- **`first commit`**: Initial NestJS project scaffold with `DirectoryModule`, `McpModule`, and `AppModule`. Stdio entry point (`src/main.ts`) connecting to Llama 3.2:1b via MCPHost and Ollama.
- **`styating script for windows ready`**: Added `restart.ps1` and `restart.sh` automation scripts for Windows and Linux setup. MCPHost configuration files (`.mcphost.yml`) added.
- **`working example`**: Fully working stdio MCP server — MCPHost can start the Node.js process and call `list_directory` tool using Git Bash.
- **`pdf add to process`**: Added `DEVELOPMENT_PROCESS.md` documenting the development journey and architectural decisions.

---

### Phase 2 — StreamableHTTP Transport (2025-09-11)

**Branch**: `feature/http-streamable-transport`
**Commits**: `fde43fb`, `8cfb2c4`

Migration from local stdio to remote StreamableHTTP transport. Key milestones:

- **`done with remote`**: Working HTTP MCP server (`src/main-http.ts`) using `StreamableHTTPServerTransport`. Session management added to `McpService`. `RootMcpController` handling `POST/GET/DELETE /mcp`. `.mcphost-http.yml` configuration for remote mode. Added `start-http-server.ps1` and `start-http-mcphost.ps1` scripts.
- **`all the information`**: Complete documentation pass — `README.md` expanded to full educational guide covering MCP protocol concepts, dual transport modes, NestJS architecture deep-dive, cross-platform setup instructions (Windows, Linux, macOS), and detailed troubleshooting. `DEVELOPMENT_PROCESS.md` updated with all 4 challenges and solutions (Host header validation, schema validation, CORS, session management). Production AWS deployment architecture (EC2 + ECS + ALB) documented.

---

### Phase 3 — Testing Infrastructure (2025-09-15)

**Branch**: `feature/postman-collection`
**Commit**: `e8477f2`

- **`adding postman collection to test`**: Added Postman collection (`src/postmant-collections/`) with 5 numbered requests covering the full MCP HTTP workflow: initialize session → list tools → execute tool → cleanup. Also added Bruno collection (`src/bruno-collections/`) as an alternative API testing client.

---

### Phase 4 — Documentation Reorganization (Current)

**Branch**: `docs/improoving`
**Commit**: `6ed39cd` (and ongoing)

- **`.update`**: Initial commit on documentation improvement branch — openspec change tracking files added to prepare for the documentation reorganization described in this work.
- **Ongoing**: Creating `docs/` folder with 10 focused markdown files, rewriting the root `README.md` to ~100-150 lines, and preserving all content from `README.md` and `DEVELOPMENT_PROCESS.md` in organized documentation.

---

## Key Statistics

| Metric | Value |
|--------|-------|
| Total commits | 8 |
| Development duration | 8 days (Sep 9–17, 2025) |
| Branches | 5 (`main`, `feature/stedio-transport`, `feature/http-streamable-transport`, `feature/postman-collection`, `docs/improoving`) |
| Primary author | lemys Lopez |

---

*See also: [Development Process](development-process.md) | [Architecture](architecture.md)*
