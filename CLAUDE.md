# agent-config-library

## What this is
A personal reference repo for AI coding agent configuration templates, rule snippets,
slash commands, settings, and MCP config examples. Not used at runtime — it's a swipe
file to copy from when starting or improving a project's agent config.

## Commands
- Test init.sh: `sh init/test-init.sh`
- Local init test: `REPO_RAW="file://$(pwd)" sh init/init.sh --type=simple --dest=/tmp/test-init --dry-run`

## Repo conventions
- Manifest format: `<repo-relative-src> -> <dest-relative-to-project-root>` (see `init/manifests/`)
- Templates are examples, not runtime config — they use placeholders like `[name]` and `[command]`
- Rule snippets are one rule each, composable into a CLAUDE.md
- `notes/lessons-learned.md` is the compounding asset — update it when a config change
  actually moves the needle on a real project

## IMPORTANT
- Don't add runtime config to this repo — it's a reference library, not a live config
- When adding a new manifest type, also update `init/README.md` and add a test case to
  `init/test-init.sh`
