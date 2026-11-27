# `111_m1`

`111` (0.2.0) + the M1 hook.

111（0.2.0）+ M1 hook。

| | |
|---|---|
| Type | plugin |
| Status | screen only |
| Composite score | **+23.0** (mean of 1 run); rank 19 of 40 in the [variant leaderboard](../../README.md#leaderboard-by-variant) |
| Same output-style text as | `111` (`plugin/`, 0.2.0) |

Back to the [experiment library](../../README.md).

## Results

Each row compares this variant with native Claude Code in the same run (same model, effort, tasks and repetitions). Score = cost-per-resolved-task saving; see the [composite score](../../README.md#composite-score).

| Run | Model (effort) | Tasks × reps | Score | Cost vs. native (95% CI) | Resolved, native → variant | Δ pp | Evidence | Notes |
|---|---|---|---:|---|---|---:|---|---|
| [kimi-w2](../../runs/kimi-w2.md) | kimi-k3.1-pro (xhigh) | 40 × 1 | +23.0 | 0.706 (0.455–1.062) | 36/40 → 33/40 | −7.5 | screen ×1 | [e] 10%-trimmed 0.62 |

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

- Batch independent read-only steps. When several reads, searches, or checks don't depend on each other, issue them together: several tool calls in one response, or one shell command joined with `;` or `&&`.
- Batch edits. Once you know the changes you want, make them all in one response, including several edits to the same file and the edits to tests and docs, instead of one edit per response.
- Don't re-read a file or re-run a command whose output you have already seen and that has not changed since. Refer back to the earlier output instead.
- Once the change is made and the relevant tests or reproduction pass, finish. Don't repeat checks that already passed or re-verify results that cannot have changed.
```

## Try it

```bash
claude --plugin-dir experiments/variants/111_m1
```

The marketplace installs only the released `plugin/`. This directory is kept byte-for-byte as tested (tests and internal notes removed); the plugin name inside `plugin.json` may clash with an installed token-saver, so use `--plugin-dir` for a single session.
