---
name: spec
description: "Define a task before coding: restate goal, list relevant files, identify risks, output a spec document. No code changes."
user-invocable: true
disable-model-invocation: true
allowed-tools:
  - Read
  - Glob
  - Grep
---

# Spec

Define the task before any code is written. Do NOT modify any files in this step.

1. **Restate the goal** - In your own words, describe what the user is asking for. If you're unsure, ask clarifying questions before proceeding.
2. **List relevant files** - Identify every file that will need to be read, modified, or created. Include test files.
3. **Identify the top 3 risks** - What are the most likely ways this task goes wrong? Think about: breaking existing behavior, missing edge cases, unintended side effects on other parts of the codebase.
4. **Note constraints** - List any files that must NOT be touched, behaviors that must NOT change, and dependencies that should NOT be added.
5. **Output a spec** - Write the above as a structured document. Present it to the user for confirmation.

Do not write code. Do not create files. Do not modify files. Wait for the user to confirm the spec before proceeding to `/plan`.

The spec should be concise - no more than 30 lines. If it's longer, the task is probably too broad and should be split.
