## Context

The Simple MCP Server project is an educational resource demonstrating how Large Language Models interact with external tools via the Model Context Protocol (MCP). Currently, all documentation lives in two monolithic root files:

- `README.md` (1,494 lines, ~40KB) — overview, architecture deep-dive, setup for 3 OSes, code examples, educational exercises, troubleshooting
- `DEVELOPMENT_PROCESS.md` (869 lines, ~27KB) — development journey, challenges, production architecture, academic references

This structure causes cognitive overload for new readers and creates duplicated content (transport comparisons, JSON-RPC examples, architecture diagrams). There is no `docs/` folder for extended reference material, no git-history-based project timeline, and no consolidated dependency guide.

**Stakeholders**: New developers learning MCP, educators using this as a teaching resource, contributors looking to understand the codebase quickly.

## Goals / Non-Goals

**Goals:**

- Create a `docs/` folder with 9 focused markdown files, each covering a distinct topic (project overview, architecture, MCP protocol guide, design decisions, development process, git history, dependencies & setup, configuration reference, testing guide)
- Reduce root `README.md` to ~100-150 lines: concise abstract, quick-start, documentation index
- Document the project creation timeline by analyzing git commits
- Create a comprehensive dependency guide with versions, purposes, and cross-platform installation instructions
- Preserve and enhance all Mermaid diagrams
- Eliminate duplicated content through cross-references

**Non-Goals:**

- Adding new code features (this is documentation-only)
- Changing the project's technical architecture or dependencies
- Modifying the NestJS module structure or MCP implementation
- Creating API documentation (no public APIs to document)
- Adding internationalization support

## Decisions

### 1. docs/ Folder Structure over Inline Subdirectories

**Decision:** Flat `docs/` folder with prefixed filenames (`docs/project-overview.md`, `docs/architecture.md`, etc.) rather than nested subdirectories.

**Rationale:** Simpler navigation for a finite set of 9 files. Subdirectories would add unnecessary depth for this scale.

**Alternative Considered:** Nested folders like `docs/architecture/`, `docs/guides/setup.md`. Rejected — adds URL complexity and navigation overhead for a small number of files.

### 2. docs/README.md as Index File

**Decision:** Include a `docs/README.md` that serves as the table of contents for the entire docs folder.

**Rationale:** Provides a clear entry point when users navigate into `docs/`. Standard convention in documentation structures (e.g., Rust docs, Docusaurus).

### 3. Root README Rewriting Over Creation of NEW File

**Decision:** Rewrite the existing `README.md` in place rather than creating a new file like `QUICKSTART.md`.

**Rationale:** Existing README already has strong SEO/visibility. Rewriting maintains existing links and expectations. Users looking for "README" will find it at the root.

**Alternative Considered:** Create `QUICKSTART.md` and keep existing `README.md`. Rejected — perpetuates the problem of scattered documentation.

### 4. Content Migration Over Deletion

**Decision:** Migrate ALL content from `DEVELOPMENT_PROCESS.md` to appropriate `docs/` files rather than deleting content.

**Rationale:** Valuable information exists in DEVELOPMENT_PROCESS (challenges, solutions, AWS architecture, academic references). Deletion loses educational value.

**Mapping:**

- Challenges/solutions → `docs/development-process.md`
- Production architecture → `docs/development-process.md`
- Academic references → `docs/design-decisions.md` (or new `docs/references.md`)
- Transport comparison → `docs/mcp-protocol-guide.md`

### 5. Mermaid Diagram Preservation

**Decision:** Preserve all existing Mermaid diagrams in their original files, only enhancing where the diagram itself needs improvement.

**Rationale:** Diagrams are visual assets that already communicate architecture effectively. Rewriting would be time-consuming with no clear benefit.

### 6. Git History Analysis via CLI

**Decision:** Analyze git history using `git log` CLI to produce the timeline, rather than extracting from GitHub/GitLab web interface.

**Rationale:** Reliable, local, scriptable. The project has an active git repo we can query directly.

## Risks / Trade-offs

### Risk 1: Content Loss During Migration → Mitigation

**[Risk]** During the process of splitting content from `README.md` and `DEVELOPMENT_PROCESS.md` into `docs/` files, some information could be accidentally omitted or miscategorized.

**[Mitigation]** Create a checklist mapping every major section from both source files to destination files. Before marking tasks complete, verify each source section has a corresponding destination with equivalent content.

### Risk 2: Broken Cross-References After Rewrite → Mitigation

**[Risk]** Existing external links to `#section-anchor` in the root `README.md` will break after rewriting.

**[Mitigation]** Document all known external links before rewriting. After completing the rewrite, update any internal references to point to new `docs/` locations. For external users who may have bookmarked sections, consider adding a redirect note in the new README.

### Risk 3: Duplicate Information Persists → Mitigation

**[Risk]** Without careful deduplication, similar content (e.g., JSON-RPC examples appearing in both `docs/mcp-protocol-guide.md` and `docs/testing-guide.md`) could persist.

**[Mitigation]** Establish a single-source-of-truth rule: each conceptual topic lives in exactly one file. Other files that need to reference it should link rather than duplicate. Use the docs/README.md index to verify no obvious overlaps.

### Risk 4: Scope Creep → Mitigation

**[Risk]** The desire to "improve" documentation could expand into rewriting code comments, adding new examples, or other changes beyond the stated goal of reorganization.

**[Mitigation]** Strictly limit changes to: (1) file restructuring, (2) content migration, (3) deduplication, (4) cross-linking. Any additional improvements (new examples, better code comments) should be logged as separate follow-up tasks.

### Risk 5: Test Collection Changes → Mitigation

**[Risk]** Moving from architect to code mode to implement changes could introduce test failures if the openspec CLI or workflow is affected.

**[Mitigation]** This is a documentation-only change with no code modifications. No test failures expected. If openspec artifacts fail validation, address them as they arise.

## Migration Plan

This is a documentation-only change with no deployment. The "migration" is the process of content transformation:

1. **Phase 1: Create docs/ folder structure** — Create empty markdown files for all 9 planned documents
2. **Phase 2: Migrate DEVELOPMENT_PROCESS.md** — Split into appropriate docs/ files
3. **Phase 3: Migrate README.md sections** — Move extended content to docs/, keep abstract/quick-start in root
4. **Phase 4: Deduplicate and cross-link** — Audit for duplicate content, add cross-references
5. **Phase 5: Git history analysis** — Run git log analysis, create `docs/git-history.md`
6. **Phase 6: Create dependency guide** — Extract from package.json and README setup sections
7. **Phase 7: Rewrite root README** — Final concise version with docs/ links
8. **Phase 8: Verify** — Check all links work, no content lost, cross-references valid

**Rollback:** If issues arise, git provides full history. Revert to previous state via `git checkout`.

## Open Questions

1. **Should academic references from DEVELOPMENT_PROCESS.md go into their own file?** The proposal maps them to `docs/design-decisions.md`, but they could also be a standalone `docs/references.md` for clarity. Decision needed: keep in design-decisions or split out?

2. **Exact content boundaries for each docs/ file** — While the proposal lists the 9 files, some content (e.g., where does "configuration reference" end and "architecture" begin?) may need clarification during implementation. These will be resolved as content is migrated.

3. **Should the existing Mermaid diagrams be re-rendered or just?** The copied proposal says "preserve" but doesn't specify whether we should re-export them or leave them as raw markdown. Leaving as raw markdown is simpler and less error-prone.

4. **Postman/Bruno collection docs** — These currently live in `src/postmant-collections/README.md` and as `.bru` files in `src/bruno-collections/`. Should these move to `docs/testing-guide.md` or stay where they are? Recommendation: keep in `src/` (they're part of the testing tooling) but link from `docs/testing-guide.md`.
