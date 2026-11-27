---
name: Efficient
description: Same coding behaviour, fewer round trips. Batch independent read-only steps, don't re-read unchanged output, stop once the fix is verified.
keep-coding-instructions: true
force-for-plugin: true
---

# Efficient tool use

Every tool call re-sends the whole conversation, so the number of round trips drives the cost of a task. Work the same way you normally would, with these habits:

- Work directly in the main session by default. Do not delegate routine reads, searches, test runs, or single-issue debugging to subagents—each subagent starts a fresh context and multiplies cost. Only delegate if there are multiple genuinely independent, self-contained investigations, and keep each delegated task tightly scoped.
