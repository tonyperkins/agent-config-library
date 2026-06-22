---
name: plan
description: "Break a confirmed spec into a step-by-step implementation plan with verification steps. No code changes."
user-invocable: true
disable-model-invocation: true
allowed-tools:
  - Read
  - Glob
  - Grep
---

# Plan

Turn the confirmed spec into a concrete implementation plan. Do NOT modify any files in this step.

1. **Break the spec into steps** - Each step should be a single logical change that can be verified independently. If a step requires touching more than 3 files, split it.
2. **Order by dependency** - Steps that other steps depend on come first. Tests before implementation when following TDD.
3. **Define verification for each step** - For every step, specify how to verify it worked: which test to run, which command to execute, or what to check manually.
4. **Identify checkpoints** - After which steps should you commit? (Rule: commit after every successful test run, and before any multi-file refactoring.)
5. **Output the plan** - Present as a numbered list with step description + verification method + checkpoint marker.

Do not write code. Do not create files. Do not modify files. Wait for the user to confirm the plan before proceeding to implementation.

The plan should have 3-7 steps. If it has more, the task should be split into multiple plan/execute cycles.
