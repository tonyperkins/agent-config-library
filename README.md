# agent-config-library

A personal reference repo for AI coding agent configuration: `CLAUDE.md` / `AGENTS.md` templates,
composable rule snippets, skills, subagent definitions, settings, and MCP config examples.
Deploy cross-tool — works with Claude Code, Cursor, Copilot, Gemini, Windsurf, and Codex.

**This is not used at runtime.** Nothing here is symlinked or loaded automatically by any project.
It's a swipe file you pull from when starting or improving a project's agent config, and a place
to capture lessons as you find what actually works.

## Table of contents

- [Layout](#layout)
- [Quick start: bootstrap a new project](#quick-start-bootstrap-a-new-project)
- [Philosophy](#philosophy)
- [Testing](#testing)
- [Changelog](#changelog)
- [License](#license)

## Layout

| Folder | Purpose |
|---|---|
| `claude-md/` | Complete `CLAUDE.md` templates, by project shape (simple, complex root, nested subsystem, agents-md-first) |
| `agents-md/` | `AGENTS.md` templates (the cross-tool standard other agents also read) |
| `rules-snippets/` | Small composable rule fragments to paste into a CLAUDE.md you're already building |
| `skills/` | Reference `SKILL.md` templates — installed via package manager, not deployed by init.sh |
| `commands/` | Legacy slash command templates — kept for backward compat |
| `agents/` | Subagent definition templates (`.claude/agents/*.md`) — read-only reviewer, planner |
| `settings/` | `settings.json` / permissions / hooks examples (session persistence, auto-test, lint) |
| `mcp/` | `.mcp.json` server config examples |
| `design-md/` | `DESIGN.md` templates — design systems as agent-readable config |
| `output-styles/` | Output style configs (placeholder — format still emerging) |
| `notes/` | Running log of lessons learned and where ideas came from |
| `init/` | Scripts to bootstrap a new project's agent config from this repo |

## Quick start: bootstrap a new project

```bash
curl -fsSL https://raw.githubusercontent.com/tonyperkins/agent-config-library/main/init/init.sh | sh -s -- --type=simple
```

See `init/README.md` for available types and how to add new ones.

For reproducible installs, pin to a tagged release:

```bash
curl -fsSL https://raw.githubusercontent.com/tonyperkins/agent-config-library/refs/tags/v1.0.0/init/init.sh | sh -s -- --type=simple
```

## Philosophy

- `init.sh` deploys cross-tool by default: AGENTS.md + CLAUDE.md + `.claude/rules/` +
  synced to GEMINI.md, `.windsurfrules`, `.github/copilot-instructions.md`, `.cursor/rules/project.mdc`
- `skills/` are installed globally via package manager (`npx skills add`), not deployed per-project
- `rules-snippets/` = one rule each, for mixing into a CLAUDE.md you're already building
- `agents-md/` provides cross-tool templates that work with Cursor, Copilot, Codex, and others
- `notes/lessons-learned.md` is the part worth being disciplined about updating — that's the
  actual compounding value of this repo over time

## Testing

```bash
make test        # run the init.sh test suite
make local-init  # quick dry-run smoke test against the working copy
```

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for notable changes.

## License

MIT — see [LICENSE](LICENSE).
