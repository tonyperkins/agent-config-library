# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Added
- `rules-snippets/workflow/focused-diffs.md` — constrains agents to one logical change per task
- `rules-snippets/dependencies/ask-before-adding.md` — prevents unasked-for dependency additions
- `commands/debug.md` — systematic debugging slash command (reproduce, trace, test, fix, verify)
- `commands/test-gen.md` — test generation slash command with framework detection
- `init/test-init.sh` — test suite for `init.sh` (32 tests covering dry-run, real run,
  idempotent re-run, --force with backups, missing/unknown --type, manifest comment
  handling, and all manifest types)
- `CLAUDE.md` — agent config for working on this repo itself
- `mcp/README.md` — documentation for MCP config examples (replaces inline `_comment`)
- `rules-snippets/code-style/minimal.md` — language-agnostic code-style snippet for
  simple projects
- `skills/code-reviewer/SKILL.md` — example skill demonstrating the expected layout
- `init/manifests/python.manifest` — manifest type for Python projects
- `Makefile` — targets for testing and local development
- `LICENSE` — MIT license

### Changed
- `init/init.sh` — replaced fragile awk-based manifest parsing with explicit ` -> `
  delimiter split; added inline comment stripping and whitespace trimming
- `init/manifests/web-frontend.manifest` — added `deploy-checklist.md`
- `init/manifests/simple.manifest` — added `code-style/minimal.md`
- `settings/settings.json.example` — replaced hardcoded model name with placeholder
- `settings/hooks/pre-commit-lint.json` — expanded comment to note the command should
  be adapted per project
- `mcp/mcp-config-examples.json` — removed non-standard `_comment` key (moved to README.md)
- `README.md` — added table of contents
- `init/README.md` — added manifest validation guidance and `python` type

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
