## Why

The project's documentation is concentrated in two massive root-level files — `README.md` (1,494 lines, ~40KB) and `DEVELOPMENT_PROCESS.md` (869 lines, ~27KB) — creating significant cognitive overload for new readers. Content is duplicated across both files (transport comparisons, JSON-RPC examples, architecture diagrams, troubleshooting), there is no `docs/` folder for extended reference material, and no git-history-based project timeline or consolidated dependency guide exists. Reorganizing into focused, cross-linked documents will make the project far more approachable as an educational resource.

## What Changes

- **Create a `docs/` folder** with focused markdown files covering: project overview, architecture, MCP protocol guide, design decisions, development process, git history timeline, dependencies & setup, configuration reference, and testing guide
- **Analyze git commit history** and produce a documented project creation timeline as a new markdown file in `docs/`
- **Create a comprehensive dependency and installation guide** covering all runtime/dev dependencies, external tools (Ollama, MCPHost, Go, Git), with cross-platform instructions (Windows, Linux, macOS)
- **Rewrite the root `README.md`** to ~100-150 lines: a concise abstract, quick-start instructions, and a documentation index table linking to `docs/` files
- **Remove `DEVELOPMENT_PROCESS.md` from root** — its content will be reorganized into `docs/development-process.md` and `docs/design-decisions.md`
- **Preserve all existing Mermaid diagrams** and enhance them where appropriate
- **Deduplicate content** — each concept explained once, referenced elsewhere via cross-links

## Capabilities

### New Capabilities

- `docs-folder-structure`: Creation of the `docs/` folder with an index README and organized markdown files covering all extended documentation topics
- `readme-simplification`: Rewriting the root `README.md` to a concise entry point with abstract, quick-start, and documentation links
- `git-history-analysis`: Analyzing git commits to produce a project creation timeline document
- `dependency-guide`: Comprehensive dependency manifest with versions, purposes, and cross-platform installation instructions

### Modified Capabilities

_(No existing specs to modify — `openspec/specs/` is currently empty)_

## Impact

- **Files created**: `docs/project-overview.md`, `docs/architecture.md`, `docs/mcp-protocol-guide.md`, `docs/design-decisions.md`, `docs/development-process.md`, `docs/git-history.md`, `docs/dependencies-and-setup.md`, `docs/configuration-reference.md`, `docs/testing-guide.md`
- **Files modified**: `README.md` (rewritten to ~100-150 lines)
- **Files removed**: `DEVELOPMENT_PROCESS.md` (content migrated to docs/)
- **No code changes** — this is a documentation-only change
- **No dependency changes** — no new packages or tool requirements
- **Git history**: requires read access to `git log` for the timeline document
