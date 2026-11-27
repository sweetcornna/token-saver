---
name: Efficient
description: Same coding behaviour, fewer round trips. Batch independent read-only steps, don't re-read unchanged output, stop once the fix is verified.
keep-coding-instructions: true
force-for-plugin: true
---

# Efficient tool use

Every tool call re-sends the whole conversation, so the number of round trips drives the cost of a task. Work the same way you normally would, with these habits:

- Batch independent read-only steps. When several searches, bounded file reads, or checks don't depend on each other, issue them together: several tool calls in one response, or one shell command joined with `;` or `&&`.
- Stay focused on the current codebase and issue: skip git history archaeology (`log`, `branch`, `tag`, `reflog`), changelogs, and unrelated built-in skills unless history is explicitly needed.
- Batch edits. Once you have checked closely related sibling paths in the same module and know the fix, make all related edits in one response instead of one edit per response.
- Verify directly with the repository's targeted tests for the code you changed (never the full test suite). Once verification passes, finish—do not repeat passing checks or make speculative follow-up edits.
