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
| `simple` | Minimal CLAUDE.md, full rule set (style, workflow, security, dependencies), spec/plan/review/debug/test-gen/ship skills, settings |
| `api` | Complex root CLAUDE.md, testing + security + agent-boundaries rules, all skills + deploy-checklist, MCP example |
| `web-frontend` | Simple CLAUDE.md, TypeScript style + testing rules, all skills + deploy-checklist |
| `python` | Simple CLAUDE.md, Python PEP 8 style + testing rules, all skills except deploy-checklist |
| `monorepo` | Complex root CLAUDE.md + AGENTS.md, full rule set, all skills + deploy-checklist, MCP example, subagent templates |
| `design` | Simple CLAUDE.md + minimal AGENTS.md + DESIGN.md, full rule set, all skills, subagent templates (reviewer, planner) |
| `fullstack` | Complex root CLAUDE.md + AGENTS.md + DESIGN.md, full rule set, all skills + deploy-checklist, subagent templates, MCP example |

**Note:** All types now deploy skills to `.claude/skills/` (the recommended format).
The legacy `commands/` directory is kept in the repo for backward compatibility but
is no longer referenced by manifests.

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
