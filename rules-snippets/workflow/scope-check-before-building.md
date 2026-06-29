## Workflow — scope check before building

- Before implementing, state in one line: what problem this solves, and the simplest approach that solves it.
- Before adding any new component, service, abstraction, or dependency, justify why the task can't be done without it. If you can't, don't add it.
- If a simpler approach exists that you're choosing not to take, say why you're rejecting it — don't pass over it silently.
- Match the solution's complexity to the problem's actual size, not to where the project might go. A demo, a single-user tool, and a multi-tenant product are three different problems; build for the one in front of you.
- If you find yourself designing for scale, multi-user, extensibility, or reuse the task didn't request, stop and ask whether that's in scope.
- Prefer one change that fully solves the stated problem over a framework that solves a class of problems you don't have yet.
