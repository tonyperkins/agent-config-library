<!--
AGENTS.md-first approach: lead with a minimal cross-tool AGENTS.md,
then CLAUDE.md is a one-liner that points to it. This is the pattern
adopted by uv and other repos that want cross-tool compatibility
without maintaining two full files.

Use this when:
- Your team uses multiple AI coding tools (Claude Code, Cursor, Copilot, etc.)
- You want a single source of truth for project context
- You want CLAUDE.md to be as small as possible
-->

# Project: [name]

This file adds Claude Code-specific settings on top of `AGENTS.md`.
Read `AGENTS.md` first for project setup, build commands, and conventions.

## Claude Code specifics
- Skills: see `.claude/skills/` for available slash commands
- Rules: see `.claude/rules/` for code style, workflow, and security rules
- Settings: see `.claude/settings.json` for permissions and hooks
