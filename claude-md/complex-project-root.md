# Project: [name]

## What this is
[Purpose, the "why" — same as simple template]

## Architecture (WHAT)
- [High-level map, e.g. "apps/web is the frontend, apps/api is the backend, packages/shared is types/utils"]
- Pointer: see `docs/architecture.md` for the full diagram

## Stack
- [Language/framework + version]
- [Key libraries that matter for how code should be written]

## Commands
- Test: `[root-level test command]`
- Lint: `[root-level lint command]`
- Build: `[root-level build command]`

## Cross-cutting rules (apply everywhere)
- Read `AGENTS.md` first for cross-tool project context
- See `.claude/rules/` for code style, workflow, security, and dependency rules
- [Things that are true no matter what part of the repo you're in]

## Subagent note
- Custom subagents (`.claude/agents/*.md`) inherit this CLAUDE.md and all `.claude/rules/` by default
- For read-only review subagents that don't need full context, keep their instructions minimal

## IMPORTANT
- [1-2 critical, repo-wide rules]

## Subsystem-specific guidance
- See `apps/web/CLAUDE.md` for frontend conventions
- See `apps/api/CLAUDE.md` for backend/API conventions
- See `infra/CLAUDE.md` for deployment rules

<!--
Keep this root file under ~100 lines even as the project grows. Depth goes into
nested, path-scoped CLAUDE.md files (see nested-subsystem-example.md), not into
this file getting longer.
-->
