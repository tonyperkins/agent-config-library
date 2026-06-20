# agent-config-library

A personal reference repo for AI coding agent configuration: `CLAUDE.md` / `AGENTS.md` templates,
composable rule snippets, skills, slash commands, settings, and MCP config examples.

**This is not used at runtime.** Nothing here is symlinked or loaded automatically by any project.
It's a swipe file you pull from when starting or improving a project's agent config, and a place
to capture lessons as you find what actually works.

## Layout

| Folder | Purpose |
|---|---|
| `claude-md/` | Complete `CLAUDE.md` templates, by project shape (simple, complex root, nested subsystem) |
| `agents-md/` | `AGENTS.md` templates (the cross-tool standard other agents also read) |
| `rules-snippets/` | Small composable rule fragments to paste into a CLAUDE.md you're already building |
| `skills/` | Reusable `SKILL.md` examples |
| `commands/` | Slash command templates (`.claude/commands/*.md`) |
| `settings/` | `settings.json` / permissions / hooks examples |
| `mcp/` | `.mcp.json` server config examples |
| `notes/` | Running log of lessons learned and where ideas came from |
| `init/` | Scripts to bootstrap a new project's agent config from this repo |

## Quick start: bootstrap a new project

```bash
curl -fsSL https://raw.githubusercontent.com/<you>/agent-config-library/main/init/init.sh | sh -s -- --type=simple
```

See `init/README.md` for available types and how to add new ones.

## Philosophy

- `claude-md/` = whole files you drop in wholesale for a given project shape.
- `rules-snippets/` = one rule each, for mixing into a CLAUDE.md you're already building.
- `notes/lessons-learned.md` is the part worth being disciplined about updating — that's the
  actual compounding value of this repo over time.
