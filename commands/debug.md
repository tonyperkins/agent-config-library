<!-- Drop into .claude/commands/debug.md -->

Debug the reported issue systematically:

1. **Reproduce** — Run the failing command or test. Confirm the error happens before changing anything.
2. **Read the stack trace** — Identify the exact file, line, and error type. Don't guess.
3. **Find the root cause** — Trace backward from the error to the actual source. Don't patch the symptom.
4. **Write a failing test** — Add a test that fails for the same reason as the bug. This proves you understand the cause.
5. **Fix it** — Make the minimal change that fixes the root cause. Don't refactor while fixing.
6. **Verify** — Run the test suite. The new test passes, and nothing else broke.
7. **Report** — Summarize: what was the root cause, what changed, and how the test confirms the fix.

Do not add try/catch to suppress the error. Do not comment out the failing code. Fix it or say you're stuck.
