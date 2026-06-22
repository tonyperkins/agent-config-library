# init

Bootstraps a new project's agent config by pulling files from this repo, following
the `curl | sh` install pattern. No local clone required.

## Usage

```bash
curl -fsSL https://raw.githubusercontent.com/tonyperkins/agent-config-library/main/init/init.sh \
  | sh -s -- --type=<simple|api|web-frontend|python|monorepo|design|fullstack> [--dest=.]
```

- `--type` picks a manifest from `manifests/`.
- `--dest` defaults to the current directory; pass a subdirectory path for monorepo packages.
- `--force` overwrites every conflicting file without prompting (the "nuclear" option).
- `--no-backup` skips the backup step when replacing files (pairs with `--force`).
- `--dry-run` prints what would happen without writing or backing up anything.

### Conflict handling

- A new file (not present locally) is always added.
- An existing file identical to the repo's current version is skipped silently.
- An existing file that differs is handled based on context:
  - **Interactive terminal, no `--force`:** prompts `[s]kip (default) / [r]eplace / [d]iff` per file.
  - **No terminal available (e.g. piped in a non-interactive context), no `--force`:** skipped with
    a warning telling you to rerun with `--force`.
  - **`--force`:** replaced unconditionally, no prompt.
- Any file that actually gets replaced (via `r` at the prompt, or `--force`) is backed up first to
  `DEST/.claude-init-backup/<UTC-timestamp>/<same-relative-path>`, unless `--no-backup` is set.

## Available types

| Type | Pulls in |
|---|---|
| `simple` | CLAUDE.md + AGENTS.md, full rule set, settings |
| `api` | Complex root CLAUDE.md + AGENTS.md, testing + security rules, MCP example |
| `web-frontend` | CLAUDE.md + AGENTS.md, TypeScript style + testing rules |
| `python` | CLAUDE.md + AGENTS.md, Python PEP 8 style + testing rules |
| `monorepo` | Complex root CLAUDE.md + AGENTS.md, full rule set, MCP example |
| `design` | CLAUDE.md + AGENTS.md + DESIGN.md, full rule set, subagent templates |
| `fullstack` | Complex root CLAUDE.md + AGENTS.md + DESIGN.md, full rule set, subagent templates, MCP example |

**All types deploy cross-tool by default.** init.sh syncs rules to every tool's expected location:

| Tool | Destination |
|---|---|
| Claude Code | `CLAUDE.md` + `.claude/rules/*.md` (auto-loaded) |
| Codex / shared | `AGENTS.md` |
| Gemini | `GEMINI.md` |
| Windsurf | `.windsurfrules` |
| GitHub Copilot | `.github/copilot-instructions.md` |
| Cursor | `.cursor/rules/project.mdc` (with YAML frontmatter) |

**Skills are not deployed by init.sh.** Install skills globally via `npx skills add`. See `skills/README.md`.

## Adding a new type

1. Create `manifests/<name>.manifest`.
2. Each line: `<repo-relative-src-path> -> <dest-path-relative-to-project-root>`. Lines starting
   with `#` are comments and ignored. Inline comments (after a ` #`) are also stripped.
3. Verify every source path in the manifest actually exists in the repo — `init.sh` will
   silently skip files it can't fetch. Run `sh init/test-init.sh` to catch this.
4. Add a test case to `init/test-init.sh` that runs the new manifest type and asserts
   the expected files are created.
5. Update the table above and this README.

## Local testing (before pushing to GitHub)

`init.sh` fetches from `REPO_RAW`, which points at GitHub. To test changes locally before
pushing, run it against the working copy instead:

```bash
REPO_RAW="file://$(pwd)/.." # adjust if running from a different cwd
# or simpler: temporarily edit REPO_RAW in init.sh to a local path for testing, then revert.
```
