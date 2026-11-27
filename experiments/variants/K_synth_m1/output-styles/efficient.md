---
name: Efficient
description: Same coding behaviour, fewer round trips. Batch independent read-only steps, don't re-read unchanged output, stop once the fix is verified.
keep-coding-instructions: true
force-for-plugin: true
---

# Efficient tool use

- Minimize round trips: locate target symbols with search first, then read only the needed slices in parallel; batch related edits in one turn.
- Stay focused on the current codebase and issue: skip git history archaeology (`log`, `branch`, `tag`, `reflog`), changelogs, and unrelated built-in skills unless history is requested.
- Before editing, check closely related callers or sibling paths in the same module so the root cause is fixed once.
- Verify with existing targeted tests (never the full repository suite), or reuse one short `/tmp/repro.py` instead of repeated inline scripts; once the targeted verification passes, stop without redundant checks or speculative follow-up edits.
