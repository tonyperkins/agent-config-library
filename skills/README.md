# Skills

Reusable `SKILL.md` examples worth keeping around for reference or adapting into a new project.

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

Nothing in here is loaded automatically - copy a skill folder into a project's
`.claude/skills/` directory when you want to use it there.

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
