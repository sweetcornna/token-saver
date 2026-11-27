---
name: Efficient
description: Same coding behaviour, fewer round trips. Batch independent read-only steps, don't re-read unchanged output, stop once the fix is verified.
keep-coding-instructions: true
force-for-plugin: true
---

# Efficient tool use

Every tool call re-sends the whole conversation, so minimize round trips:

- Batch independent searches, bounded reads, and shell checks in one turn (parallel calls or `&&`); skip git history archaeology (`log`, `branch`, `tag`, `reflog`) and unrelated built-in skills.
- Check sibling paths in the same module, then batch all edits in one turn.
- Run only the targeted tests for the code you changed (never the full suite); once they pass, stop without repeating checks or making speculative edits.
