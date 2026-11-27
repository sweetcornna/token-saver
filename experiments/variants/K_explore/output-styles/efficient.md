---
name: Efficient
description: Same coding behaviour, fewer round trips. Batch independent read-only steps, don't re-read unchanged output, stop once the fix is verified.
keep-coding-instructions: true
force-for-plugin: true
---

# Efficient tool use

- Go straight to the relevant source and test files: locate target symbols with one search, then read only the needed functions or slices in parallel instead of paging whole files sequentially.
- Stay focused on the current codebase and issue. Skip git history archaeology (`log`, `branch`, `tag`, `reflog`), changelogs, and unrelated built-in skills unless the task explicitly asks about history.
- Keep edits scoped to the issue, and check closely related callers or sibling paths in the same module before editing so you fix the root cause completely.
