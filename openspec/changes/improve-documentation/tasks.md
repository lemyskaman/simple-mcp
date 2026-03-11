## 1. Create docs/ folder structure

- [ ] 1.1 Create empty `docs/` folder in project root
- [ ] 1.2 Create placeholder `docs/README.md` with temporary "to be written" content
- [ ] 1.3 Create placeholder files: `docs/project-overview.md`, `docs/architecture.md`, `docs/mcp-protocol-guide.md`, `docs/design-decisions.md`, `docs/development-process.md`, `docs/git-history.md`, `docs/dependencies-and-setup.md`, `docs/configuration-reference.md`, `docs/testing-guide.md`

## 2. Migrate DEVELOPMENT_PROCESS.md content

- [ ] 2.1 Extract challenges and solutions section → `docs/development-process.md`
- [ ] 2.2 Extract production architecture (AWS diagrams) → `docs/development-process.md`
- [ ] 2.3 Extract academic references → `docs/design-decisions.md`
- [ ] 2.4 Extract transport protocol migration details → `docs/mcp-protocol-guide.md`
- [ ] 2.5 Delete `DEVELOPMENT_PROCESS.md` from root after migration verified

## 3. Migrate README.md extended content

- [ ] 3.1 Extract "NestJS Architecture Deep Dive" section → `docs/architecture.md`
- [ ] 3.2 Extract "Understanding MCP" and "Transport Modes" sections → `docs/mcp-protocol-guide.md`
- [ ] 3.3 Extract "Why Use MCPHost with Ollama?" section → `docs/design-decisions.md`
- [ ] 3.4 Extract "Complete Setup Guide" sections → `docs/dependencies-and-setup.md`
- [ ] 3.5 Extract "Configuration Files Explained" section → `docs/configuration-reference.md`
- [ ] 3.6 Extract "Testing and Usage" section → `docs/testing-guide.md`
- [ ] 3.7 Extract "Educational Extensions" and "Learning Resources" → `docs/project-overview.md` or remove as redundant

## 4. Create git history document

- [ ] 4.1 Run `git log --oneline --all` to get commit timeline
- [ ] 4.2 Analyze commits and identify major milestones
- [ ] 4.3 Write `docs/git-history.md` with chronological timeline and phases

## 5. Create dependency guide

- [ ] 5.1 Extract runtime dependencies from `package.json` with versions and purposes
- [ ] 5.2 Extract development dependencies from `package.json` with versions and purposes
- [ ] 5.3 Document external tools: Node.js, Go, Git, Git Bash, Ollama, MCPHost
- [ ] 5.4 Add cross-platform installation instructions for each tool (Windows, Linux, macOS)
- [ ] 5.5 Add build and verification steps (`npm install`, `npm run build`)
- [ ] 5.6 Finalize `docs/dependencies-and-setup.md`

## 6. Create architecture document

- [ ] 6.1 Write `docs/architecture.md` with system overview diagram
- [ ] 6.2 Document NestJS module structure (AppModule, DirectoryModule, McpModule)
- [ ] 6.3 Document entry points (`main.ts` for stdio, `main-http.ts` for HTTP)
- [ ] 6.4 Document design patterns (DI, encapsulation, SRP, scalability)
- [ ] 6.5 Preserve and integrate existing Mermaid diagrams

## 7. Create MCP protocol guide

- [ ] 7.1 Write `docs/mcp-protocol-guide.md` with MCP overview
- [ ] 7.2 Document key components: Host, Server, Transport
- [ ] 7.3 Add Stdio transport sequence diagram and code snippets
- [ ] 7.4 Add StreamableHTTP transport sequence diagram and code snippets
- [ ] 7.5 Include transport comparison table
- [ ] 7.6 Document complete request flow
- [ ] 7.7 Include JSON-RPC message examples (deduplicated)

## 8. Create design decisions document

- [ ] 8.1 Write `docs/design-decisions.md` with ADR format
- [ ] 8.2 Document: NestJS over Express/Fastify/Koa
- [ ] 8.3 Document: StreamableHTTP over SSE/Stdio
- [ ] 8.4 Document: Llama 3.2:1b model selection
- [ ] 8.5 Document: MCPHost over custom client / Claude Desktop
- [ ] 8.6 Document: Git Bash for directory listing
- [ ] 8.7 Include comparison tables

## 9. Create project overview document

- [ ] 9.1 Write `docs/project-overview.md` with 2-3 paragraph abstract
- [ ] 9.2 Document target audience (who this is for)
- [ ] 9.3 List what users will learn
- [ ] 9.4 Include high-level architecture diagram

## 10. Create configuration reference

- [ ] 10.1 Document `.mcphost.yml` with annotated configuration
- [ ] 10.2 Document `.mcphost-http.yml` with annotated configuration
- [ ] 10.3 Document `nest-cli.json` compiler options
- [ ] 10.4 Document `tsconfig.json` configuration
- [ ] 10.5 Add environment variables reference
- [ ] 10.6 Add custom system prompts guide

## 11. Create testing guide

- [ ] 11.1 Write `docs/testing-guide.md` with quick start (3 commands)
- [ ] 11.2 Document stdio mode testing (manual JSON-RPC)
- [ ] 11.3 Document HTTP mode testing (curl examples)
- [ ] 11.4 Document Bruno collection usage
- [ ] 11.5 Document Postman collection usage
- [ ] 11.6 Document MCPHost interactive commands
- [ ] 11.7 Add debugging guide (debug mode, logs, environment variables)
- [ ] 11.8 Add troubleshooting FAQ

## 12. Create docs/index README

- [ ] 12.1 Write `docs/README.md` as table of contents
- [ ] 12.2 Link to each docs/ file with one-line description
- [ ] 12.3 Ensure quick navigation from index to each document

## 13. Rewrite root README.md

- [ ] 13.1 Write abstract (2-3 paragraphs)
- [ ] 13.2 Write quick-start section (prerequisites + 3-5 steps)
- [ ] 13.3 Add usage section (stdio mode, HTTP mode)
- [ ] 13.4 Add documentation index table linking to docs/ files
- [ ] 13.5 Add compact project structure tree
- [ ] 13.6 Add license and contributing sections
- [ ] 13.7 Verify total length is ~100-150 lines

## 14. Deduplicate and cross-link

- [ ] 14.1 Audit all docs/ files for duplicate content
- [ ] 14.2 Replace duplicates with cross-references (markdown links)
- [ ] 14.3 Verify each concept exists in exactly one file (single source of truth)

## 15. Verify and finalize

- [ ] 15.1 Check all links work (no broken links)
- [ ] 15.2 Verify no content lost from original files
- [ ] 15.3 Verify cross-references are valid
- [ ] 15.4 Review for consistency and formatting
- [ ] 15.5 Final verification against specs requirements
