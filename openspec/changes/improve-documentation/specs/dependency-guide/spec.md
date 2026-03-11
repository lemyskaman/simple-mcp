## ADDED Requirements

### Requirement: dependency-guide
The system SHALL create a comprehensive dependency guide covering all runtime dependencies, development dependencies, external tools (Ollama, MCPHost, Go, Git), with versions, purposes, and cross-platform installation instructions.

#### Scenario: Dependency guide file exists
- **WHEN** the documentation reorganization is complete
- **THEN** a file `docs/dependencies-and-setup.md` SHALL exist in the docs folder

#### Scenario: Runtime dependencies documented
- **WHEN** user reads the dependency guide
- **THEN** they SHALL see a table listing all runtime dependencies from package.json with columns: Name, Version, Purpose

#### Scenario: Development dependencies documented
- **WHEN** user reads the dependency guide
- **THEN** they SHALL see a table listing all development dependencies from package.json with columns: Name, Version, Purpose

#### Scenario: External tools documented
- **WHEN** user reads the dependency guide
- **THEN** they SHALL see documentation for external tools required: Node.js, Go, Git (with Git Bash), Ollama, MCPHost, each with installation instructions

#### Scenario: Cross-platform instructions for each tool
- **WHEN** user reads the dependency guide for a specific tool
- **THEN** they SHALL see installation instructions for Windows, Linux, and macOS as applicable

#### Scenario: Version requirements specified
- **WHEN** user reads the dependency guide
- **THEN** each dependency and tool SHALL list its minimum required version (e.g., Node.js v18+, Go 1.21+)

#### Scenario: Build and verification steps
- **WHEN** user follows the dependency guide
- **THEN** they SHALL see clear steps to: install dependencies (`npm install`), build the project (`npm run build`), and verify the build succeeded
