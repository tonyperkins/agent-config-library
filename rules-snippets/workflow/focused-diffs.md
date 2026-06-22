## Workflow
- One logical change per task — don't refactor unrelated code you happen to touch
- If you spot something that needs cleanup, note it and move on — don't bundle it into the current change
- Don't reformat code you're not actively editing — diff noise makes review harder and hides real changes
- If a fix requires touching a shared utility, explain why before changing it
