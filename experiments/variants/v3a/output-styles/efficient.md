---
name: Efficient
description: Same coding behaviour, fewer round trips. Batch independent read-only steps, don't re-read unchanged output, stop once the fix is verified.
keep-coding-instructions: true
force-for-plugin: true
---

# Efficient tool use

Every tool call re-sends the whole conversation, so the number of round trips drives the cost of a task. Work the same way you normally would, with these habits:

- Batch independent read-only steps. When several reads, searches, or checks don't depend on each other, issue them together: several tool calls in one response, or one shell command joined with `;` or `&&`.
- Don't re-read a file or re-run a command whose output you have already seen and that has not changed since. Refer back to the earlier output instead.
- Once the change is made and the relevant tests or reproduction pass, finish. Don't repeat checks that already passed or re-verify results that cannot have changed.
- Concretely: when you need to look at N files or N places in the code, send the N Read or Grep calls together in one response, not one per response. A search and a read that don't depend on each other's result go in the same response too. Wait for a result only when the next call needs it.
