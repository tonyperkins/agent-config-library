<!-- Drop into .claude/commands/test-gen.md -->

Generate tests for the current file or specified function:

1. **Detect the test setup** — Find the test framework, test directory, and naming convention by looking at existing tests. Match them.
2. **Cover these cases:**
   - Happy path — the normal expected input and output
   - Edge cases — empty input, null/undefined, boundary values (0, -1, max), single-element collections
   - Error paths — invalid input, missing required fields, failure responses
3. **Don't test:**
   - Framework internals (routing, ORM plumbing) — test your code, not the library
   - Trivial getters/setters with no logic
4. **Run the tests** — Execute the test command and confirm they pass before reporting done. If a test fails, fix the test (not the implementation) unless the test revealed a real bug.
5. **Report** — List the test cases added and the test command output.

Keep tests independent — no shared mutable state between tests. Each test should set up and tear down its own fixtures.
