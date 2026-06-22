# agent-config-library

A personal reference repo for AI coding agent configuration: `CLAUDE.md` / `AGENTS.md` templates,
composable rule snippets, skills, slash commands, settings, and MCP config examples.

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
curl -fsSL https://raw.githubusercontent.com/tonyperkins/agent-config-library/main/init/init.sh | sh -s -- --type=simple
```

See `init/README.md` for available types and how to add new ones.

For reproducible installs, pin to a tagged release:

```bash
curl -fsSL https://raw.githubusercontent.com/tonyperkins/agent-config-library/refs/tags/v1.0.0/init/init.sh | sh -s -- --type=simple
```

## Philosophy

- `claude-md/` = whole files you drop in wholesale for a given project shape.
- `rules-snippets/` = one rule each, for mixing into a CLAUDE.md you're already building.
- `notes/lessons-learned.md` is the part worth being disciplined about updating — that's the
  actual compounding value of this repo over time.

## Testing

```bash
make test        # run the init.sh test suite
make local-init  # quick dry-run smoke test against the working copy
```

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for notable changes.

## License

MIT — see [LICENSE](LICENSE).
