## Workflow — scope (YAGNI)

- Build the smallest thing that satisfies the requirement as stated. Not the anticipated future one.
- "We might need X later" is not a reason to build X now. Solve today's problem; note the future need and move on.
- When a more general/capable solution and a simpler one both work, default to the simpler one and name the tradeoff out loud.
- Don't add a layer (service, abstraction, queue, cache, framework, config system) unless the task fails without it. Reaching for the capable tool when the simple one suffices is the most common over-build.
- Escalation order — stop at the first that works: do nothing → existing code → stdlib → native platform feature → an installed dependency → a new dependency → a new service/component.
- Flag speculative generality explicitly. If you're building for extensibility/scale/reuse the task didn't ask for, say so and let the human decide — don't bake it in silently.
