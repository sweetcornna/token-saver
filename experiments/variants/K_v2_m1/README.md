# `K_v2_m1`

`K_v2` + the M1 hook.

K_v2 + M1 hook。

| | |
|---|---|
| Type | plugin |
| Status | screen only |
| Composite score | **+15.7** (mean of 1 run); rank 25 of 40 in the [variant leaderboard](../../README.md#leaderboard-by-variant) |
| Same output-style text as | [`K_v2`](../K_v2/) |

Back to the [experiment library](../../README.md).

## Results

Each row compares this variant with native Claude Code in the same run (same model, effort, tasks and repetitions). Score = cost-per-resolved-task saving; see the [composite score](../../README.md#composite-score).

| Run | Model (effort) | Tasks × reps | Score | Cost vs. native (95% CI) | Resolved, native → variant | Δ pp | Evidence | Notes |
|---|---|---|---:|---|---|---:|---|---|
| [kimi-w2](../../runs/kimi-w2.md) | kimi-k3.1-pro (xhigh) | 40 × 1 | +15.7 | 0.773 (0.538–1.014) | 36/40 → 33/40 | −7.5 | screen ×1 | [e] 10%-trimmed 0.63 |

- [e] Seven long tasks that hit turn or time limits dominate the totals, and per-request uncached input rose about 17× between this run and the previous Kimi run for every arm, native included. Arms in this run could not be separated from each other.

## Contents

- [`.claude-plugin/plugin.json`](.claude-plugin/plugin.json)
- [`hooks/hooks.json`](hooks/hooks.json)
- [`hooks/m1_env_probe.py`](hooks/m1_env_probe.py)
- [`output-styles/efficient.md`](output-styles/efficient.md)

The M1 hook (`hooks/m1_env_probe.py`) is a `SessionStart` hook that prints about 45 tokens of workspace facts: the Python version, top-level entries and the repository's targeted test command (for example Django's `tests/runtests.py`). It makes no model calls and reads nothing outside the working directory.

Output-style text (front matter omitted):

```markdown
# Efficient tool use

Every tool call re-sends the whole conversation, so the number of round trips drives the cost of a task. Work the same way you normally would, with these habits:

- Batch independent read-only steps. When several searches, bounded file reads, or checks don't depend on each other, issue them together: several tool calls in one response, or one shell command joined with `;` or `&&`.
- Stay focused on the current codebase and issue: skip git history archaeology (`log`, `branch`, `tag`, `reflog`), changelogs, and unrelated built-in skills unless history is explicitly needed.
- Batch edits. Once you have checked closely related sibling paths in the same module and know the fix, make all related edits in one response instead of one edit per response.
- Verify directly with the repository's targeted tests for the code you changed (never the full test suite). Once verification passes, finish—do not repeat passing checks or make speculative follow-up edits.
```

## Try it

```bash
claude --plugin-dir experiments/variants/K_v2_m1
```

The marketplace installs only the released `plugin/`. This directory is kept byte-for-byte as tested (tests and internal notes removed); the plugin name inside `plugin.json` may clash with an installed token-saver, so use `--plugin-dir` for a single session.
