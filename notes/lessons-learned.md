# Lessons learned

Running log of what's worked, what hasn't, and why. Update this whenever a CLAUDE.md
change actually moves the needle (good or bad) on a real project.

## 2026-06-20
- Shorter, rule-numbered CLAUDE.md files reportedly cut Claude's error rate sharply
  (41% no-file -> 11% basic rules -> 3% mature ~12-rule version), per community research.
  Takeaway: favor concrete numbered rules over long prose explanations.
- Claude reads CLAUDE.md sequentially — rules near the top get more consistent
  attention. Put highest-stakes constraints first, not buried at the bottom.
- Runnable-command instructions ("Run `npm test` before marking done") are followed
  more reliably than vague descriptions ("make sure tests pass") because Claude can
  actually execute and verify them.
- For complex/grown repos: keep the root CLAUDE.md under ~100 lines and push depth into
  path-scoped nested CLAUDE.md files (e.g. `apps/api/CLAUDE.md`) instead of growing the root file.
