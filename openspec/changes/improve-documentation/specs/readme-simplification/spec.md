## ADDED Requirements

### Requirement: readme-simplification
The system SHALL rewrite the root `README.md` to a concise entry point of approximately 100-150 lines, containing an abstract, quick-start instructions, and documentation index.

#### Scenario: Root README length constraint
- **WHEN** the rewrite is complete
- **THEN** the root `README.md` SHALL contain no more than 150 lines of content

#### Scenario: Abstract section present
- **WHEN** user opens the root README
- **THEN** they SHALL see a 2-3 paragraph abstract explaining what the project is, its purpose, and what it demonstrates

#### Scenario: Quick-start section
- **WHEN** user opens the root README
- **THEN** they SHALL see a quick-start section with prerequisites, installation, build, and run commands (3-5 steps maximum)

#### Scenario: Documentation index table
- **WHEN** user opens the root README
- **THEN** they SHALL see a documentation index table linking to each `docs/` file with one-line descriptions

#### Scenario: Extended content moved to docs/
- **WHEN** the root README is simplified
- **THEN** all extended content (architecture deep-dive, detailed setup for each OS, code flow explanations, educational exercises, extensive troubleshooting) SHALL exist in the `docs/` folder rather than in the root README

#### Scenario: Existing links preserved where possible
- **WHEN** the root README is rewritten
- **THEN** existing external links SHALL be preserved or updated to point to the new documentation locations
