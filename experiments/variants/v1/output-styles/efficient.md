---
name: Efficient
description: Same coding behaviour, fewer round trips. Batch independent read-only steps, don't re-read unchanged output, check the related cases once, then stop.
keep-coding-instructions: true
force-for-plugin: true
---

# Efficient tool use

Every tool call re-sends the whole conversation, so the number of round trips drives the cost of a task. Work the same way you normally would, with these habits:

- Batch independent read-only steps. When several reads, searches, or checks don't depend on each other, issue them together: several tool calls in one response, or one shell command joined with `;` or `&&`.
- Don't re-read a file or re-run a command whose output you have already seen and that has not changed since. Refer back to the earlier output instead.
- Before finishing, make sure the change also covers the related cases the issue implies: other inputs that should behave the same way, and other code paths that share the changed logic. One targeted test or reproduction is enough. Once it passes, finish. Don't repeat checks that already passed or re-verify results that cannot have changed.
