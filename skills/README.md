# Skills

Reference `SKILL.md` templates for AI coding agent skills. These are **not deployed by `init.sh`** — skills are installed globally via package manager and work across all your projects.

## How Skills Are Installed

Skills follow the Agent Skills open standard. They're installed globally (not per-project) using a package manager like `npx skills`:

```bash
npx skills add tonyperkins/agent-config-library      # install all skills from this repo
npx skills add tonyperkins/agent-config-library@spec  # install a specific skill
```

Installed skills work across Claude Code, GitHub Copilot, Cursor, Windsurf, Gemini CLI, and other supported tools. You install once, and they're available in every project.

**This is different from rules and configs**, which are project-specific and deployed by `init.sh`.

## Skills vs Rules vs Configs

| Content | Distributed by | Scope | How |
|---|---|---|---|
| Skills | Package manager (`npx skills add`) | Global (all projects) | Install once, use everywhere |
| Rules | `init.sh` | Per-project | Deployed to `.claude/rules/` + synced to each tool's rules location |
| AGENTS.md / CLAUDE.md | `init.sh` | Per-project | Deployed to project root |
| Settings / MCP / Subagents | `init.sh` | Per-project | Deployed to `.claude/` |

## Skills vs Commands

As of Claude Code v2.1.3, custom commands (`.claude/commands/*.md`) have been merged into the skills system. Both formats create slash commands and work the same way. Skills are the recommended format because they support:

- A dedicated directory for supporting files (templates, examples, scripts)
- YAML frontmatter for auto-invocation control
- Context injection via the `context` field
- Subagent execution

The `commands/` directory in this repo is kept for backward compatibility, but all new commands should be created as skills. If a skill and a command share the same name, the skill takes precedence.

## Layout

```
skills/
└── [skill-name]/
    └── SKILL.md
    └── (any supporting scripts/references the skill needs)
```

## SKILL.md Format

Every skill needs a `SKILL.md` file with two parts: YAML frontmatter between `---` markers, and markdown content with instructions.

```yaml
---
name: my-skill              # Slash command name (defaults to directory name)
description: "What it does" # Used for auto-trigger matching
user-invocable: true        # Can users call this directly (default: true)
disable-model-invocation: false  # If true, manual-only - no auto-trigger
allowed-tools:              # Restrict tool access
  - Read
  - Bash(git:*)
context:                    # Inject files or shell output into context
  - type: file
    path: ".eslintrc.json"
  - type: shell
    command: "git diff --staged --stat"
---

# My Skill

Instructions for the agent to follow when this skill runs.
```

### Frontmatter Fields

| Field | Type | Default | Purpose |
|---|---|---|---|
| `name` | string | directory name | Slash command name |
| `description` | string | - | Used for auto-trigger matching |
| `user-invocable` | boolean | `true` | Whether users can invoke directly |
| `disable-model-invocation` | boolean | `false` | Disable auto-trigger, manual only |
| `allowed-tools` | string[] | all | Whitelist of available tools |
| `context` | object[] | - | Context injection (file or shell) |

## Available Skills

| Skill | Command | Description |
|---|---|---|
| `spec/` | `/spec` | Define a task before coding: restate goal, list files, identify risks |
| `plan/` | `/plan` | Break a confirmed spec into a step-by-step implementation plan |
| `review/` | `/review` | Review the current diff for bugs, security issues, and reuse opportunities |
| `debug/` | `/debug` | Systematically debug: reproduce, trace root cause, write failing test, fix |
| `test-gen/` | `/test-gen` | Generate tests with framework detection and edge case coverage |
| `ship/` | `/ship` | Final verification before merge: tests, lint, secrets, changelog, PR |
| `deploy-checklist/` | `/deploy-checklist` | Verify a change is ready to deploy |
| `code-reviewer/` | `/code-reviewer` | Example skill demonstrating the expected layout |

## The Spec/Plan/Ship Pipeline

The recommended workflow is `/spec` -> `/plan` -> (implement) -> `/test-gen` -> `/review` -> `/ship`.

1. **`/spec`** - Define what you're building before touching code
2. **`/plan`** - Break it into verifiable steps
3. **Implement** - Write the code following the plan
4. **`/test-gen`** - Generate tests for the new code
5. **`/review`** - Review the diff for bugs and cleanup opportunities
6. **`/ship`** - Final checks and create PR

## Cross-Tool Compatibility

Agent Skills follow an open standard that works across multiple AI tools, including Claude Code, GitHub Copilot, Cursor, Windsurf, and others. A single `SKILL.md` can serve multiple tools.
