# `K_synth_m1`

`K_synth` + the M1 SessionStart hook.

K_synth + M1 SessionStart hook。

| | |
|---|---|
| Type | plugin |
| Status | screen only |
| Composite score | **+27.2** (mean of 2 runs, range +24.2 … +30.1); rank 15 of 40 in the [variant leaderboard](../../README.md#leaderboard-by-variant) |
| Same output-style text as | [`K_synth`](../K_synth/) |

Back to the [experiment library](../../README.md).

## Results

Each row compares this variant with native Claude Code in the same run (same model, effort, tasks and repetitions). Score = cost-per-resolved-task saving; see the [composite score](../../README.md#composite-score).

| Run | Model (effort) | Tasks × reps | Score | Cost vs. native (95% CI) | Resolved, native → variant | Δ pp | Evidence | Notes |
|---|---|---|---:|---|---|---:|---|---|
| [kimi-w1](../../runs/kimi-w1.md) | kimi-k3.1-pro (xhigh) | 28 × 1 | +30.1 | 0.734 (0.565–0.959) | 20/28 → 21/28 | +3.6 | screen ×1 |  |
| [kimi-w2](../../runs/kimi-w2.md) | kimi-k3.1-pro (xhigh) | 40 × 1 | +24.2 | 0.695 (0.423–1.012) | 36/40 → 33/40 | −7.5 | screen ×1 | [e] 10%-trimmed 0.61 |

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

- Minimize round trips: locate target symbols with search first, then read only the needed slices in parallel; batch related edits in one turn.
- Stay focused on the current codebase and issue: skip git history archaeology (`log`, `branch`, `tag`, `reflog`), changelogs, and unrelated built-in skills unless history is requested.
- Before editing, check closely related callers or sibling paths in the same module so the root cause is fixed once.
- Verify with existing targeted tests (never the full repository suite), or reuse one short `/tmp/repro.py` instead of repeated inline scripts; once the targeted verification passes, stop without redundant checks or speculative follow-up edits.
```

## Try it

```bash
claude --plugin-dir experiments/variants/K_synth_m1
```

The marketplace installs only the released `plugin/`. This directory is kept byte-for-byte as tested (tests and internal notes removed); the plugin name inside `plugin.json` may clash with an installed token-saver, so use `--plugin-dir` for a single session.
