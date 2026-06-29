## Workflow — verify, don't assume

- Before naming a fix, read the actual source. Don't describe how the code works from memory or from the file's name — open it and confirm.
- Grep for the exact string, field name, function signature, or config key you're about to reference. If you're asserting a value exists, show where.
- Distinguish verified from assumed in what you report. "I read X and it does Y" is different from "X probably does Y" — say which.
- Don't trust framing. A label, comment, JD, or variable name describing intent is a claim to check, not a fact to act on (e.g. a rule named for one thing may match another).
- Check the deploy/runtime layout, not just the dev tree. Paths, env resolution, and config loading can differ between local checkout, container image, and example vs. real config files — verify in the layout that will actually run.
- When a value or behavior could come from config, read the config file rather than assuming the default. Don't claim "no change needed" without checking the file you mean.
- If verification isn't possible, say so plainly and flag the claim as unconfirmed — don't present a guess as fact.
