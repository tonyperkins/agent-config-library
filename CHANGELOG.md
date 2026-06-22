# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Added
- `skills/spec/SKILL.md` — define a task before coding (restate goal, list files, identify risks)
- `skills/plan/SKILL.md` — break a confirmed spec into a step-by-step implementation plan
- `skills/ship/SKILL.md` — final verification before merge (tests, lint, secrets, changelog, PR)
- `skills/review/SKILL.md` — code review skill with YAML frontmatter and allowed-tools
- `skills/debug/SKILL.md` — systematic debugging skill with frontmatter
- `skills/test-gen/SKILL.md` — test generation skill with frontmatter
- `skills/deploy-checklist/SKILL.md` — deploy verification skill with frontmatter
- `rules-snippets/workflow/read-before-write.md` — agent must restate goal and plan before modifying files
- `rules-snippets/workflow/zero-placeholders.md` — no TODO comments, no stubs, no incomplete functions
- `rules-snippets/workflow/defensive-commits.md` — checkpoint commits, max 3 files per intermediate commit
- `rules-snippets/workflow/interface-first.md` — define types first, get approval, then implement
- `rules-snippets/dependencies/verify-before-import.md` — verify packages exist before importing
- `rules-snippets/security/agent-boundaries.md` — never commit without review, never delete config files
- `rules-snippets/code-style/no-style-in-claude-md.md` — meta-rule: don't put style rules in CLAUDE.md
- `claude-md/agents-md-first.md` — CLAUDE.md template that leads with AGENTS.md as the source of truth
- `agents-md/minimal-agents-md.md` — minimal 15-line cross-tool AGENTS.md template
- `agents/reviewer.md` — read-only code reviewer subagent definition
- `agents/planner.md` — read-only planning subagent definition
- `agents/README.md` — documentation for subagent templates
- `design-md/design-system-template.md` — DESIGN.md template for agent-readable design systems
- `design-md/README.md` — documentation for DESIGN.md config type
- `output-styles/README.md` — placeholder for emerging output style config type
- `settings/hooks/session-start-restore.json` — SessionStart hook for context persistence
- `settings/hooks/post-tool-save-state.json` — PostToolUse hook to save session state after edits
- `settings/hooks/auto-test.json` — PostToolUse hook to run tests after file edits
- `init/manifests/design.manifest` — manifest type for design-focused projects
- `init/manifests/fullstack.manifest` — manifest type for fullstack projects (frontend + API + design)
- `notes/lessons-learned.md` — expanded with research findings from 3 last30days searches (127 items)
- `notes/sources.md` — expanded with all research sources and references

### Changed
- All 5 existing manifests now deploy skills to `.claude/skills/` instead of `.claude/commands/`
- All manifests now include the 7 new rule snippets
- `claude-md/simple-project.md` — removed code style section (goes in rules), added delegation
  pointers to `.claude/rules/` and `.claude/skills/`, added architecture pointers section
- `claude-md/complex-project-root.md` — added delegation language for rules/skills, added
  subagent context inheritance note
- `skills/README.md` — expanded with frontmatter docs, skills vs commands explanation,
  spec/plan/ship pipeline docs, cross-tool compatibility note, available skills table
- `settings/settings.json.example` — expanded permissions (git branch, git show, tsc, build),
  expanded deny list (DROP TABLE, DROP DATABASE), added hooks section
- `settings/permissions-allowlist.example.json` — expanded with git branch/show/remote,
  typecheck, ruff, cargo, and go commands
- `init/init.sh` — updated usage text to include `design` and `fullstack` types
- `init/README.md` — updated available types table with design and fullstack, added skills
  vs commands note, updated type descriptions
- `README.md` — updated layout table with 4 new directories (agents, design-md, output-styles,
  commands marked as legacy), updated philosophy with skills > commands and cross-tool notes
- `CLAUDE.md` — updated to reflect new directory structure and conventions
- `init/test-init.sh` — expanded from 32 to 71 tests covering all new skills, rules, and
  manifest types

### Previous
- `rules-snippets/workflow/focused-diffs.md` — constrains agents to one logical change per task
- `rules-snippets/dependencies/ask-before-adding.md` — prevents unasked-for dependency additions
- `commands/debug.md` — systematic debugging slash command (reproduce, trace, test, fix, verify)
- `commands/test-gen.md` — test generation slash command with framework detection
- `init/test-init.sh` — test suite for `init.sh`
- `CLAUDE.md` — agent config for working on this repo itself
- `mcp/README.md` — documentation for MCP config examples (replaces inline `_comment`)
- `rules-snippets/code-style/minimal.md` — language-agnostic code-style snippet for simple projects
- `skills/code-reviewer/SKILL.md` — example skill demonstrating the expected layout
- `init/manifests/python.manifest` — manifest type for Python projects
- `Makefile` — targets for testing and local development
- `LICENSE` — MIT license

### Fixed
- `init/init.sh` — manifest parsing now handles paths with spaces and inline comments
  correctly (previously used positional awk fields that would break on unexpected input)
- `init/init.sh` — `REPO_RAW` is now respected from the environment (was hardcoded,
  breaking the documented `REPO_RAW="file://..."` local testing workflow)

## Versioning

This repo follows a simple versioning scheme. The `curl | sh` URL in the README points
at `main` for convenience, but for reproducibility you can pin to a tagged release:

```bash
curl -fsSL https://raw.githubusercontent.com/tonyperkins/agent-config-library/refs/tags/v1.0.0/init/init.sh \
  | sh -s -- --type=simple
```

Tags follow `v<major>.<minor>` — bump minor for new manifest types or features,
major for breaking changes to `init.sh` or the manifest format.
