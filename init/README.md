# init

Bootstraps a new project's agent config by pulling files from this repo, following
the `curl | sh` install pattern. No local clone required.

## Usage

```bash
curl -fsSL https://raw.githubusercontent.com/<you>/agent-config-library/main/init/init.sh \
  | sh -s -- --type=<simple|api|web-frontend|monorepo> [--dest=.]
```

- `--type` picks a manifest from `manifests/`.
- `--dest` defaults to the current directory; pass a subdirectory path for monorepo packages.
- Existing files are never overwritten — re-running it after adding a new manifest entry
  only adds what's missing.

## Available types

| Type | Pulls in |
|---|---|
| `simple` | Minimal CLAUDE.md, git rules, review command, default settings |
| `api` | Complex root CLAUDE.md, testing + security rules, deploy checklist, MCP example |
| `web-frontend` | Simple CLAUDE.md, TypeScript style + testing rules |
| `monorepo` | Complex root CLAUDE.md + AGENTS.md, full rule set, MCP example |

## Adding a new type

1. Create `manifests/<name>.manifest`.
2. Each line: `<repo-relative-src-path> -> <dest-path-relative-to-project-root>`. Lines starting
   with `#` are comments and ignored.
3. Update the table above and this README.

## Local testing (before pushing to GitHub)

`init.sh` fetches from `REPO_RAW`, which points at GitHub. To test changes locally before
pushing, run it against the working copy instead:

```bash
REPO_RAW="file://$(pwd)/.." # adjust if running from a different cwd
# or simpler: temporarily edit REPO_RAW in init.sh to a local path for testing, then revert.
```
