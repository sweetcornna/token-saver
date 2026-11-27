# `K_synth`

Distilled `K_explore` + `K_batch` + `K_verify` (4 rules, no hook).

K_explore + K_batch + K_verify 蒸馏为 4 条，无 hook。

| | |
|---|---|
| Type | plugin |
| Status | screen only |
| Composite score | **+19.1** (mean of 1 run); rank 21 of 40 in the [variant leaderboard](../../README.md#leaderboard-by-variant) |
| Same output-style text as | [`K_synth_m1`](../K_synth_m1/) |

Back to the [experiment library](../../README.md).

## Results

Each row compares this variant with native Claude Code in the same run (same model, effort, tasks and repetitions). Score = cost-per-resolved-task saving; see the [composite score](../../README.md#composite-score).

| Run | Model (effort) | Tasks × reps | Score | Cost vs. native (95% CI) | Resolved, native → variant | Δ pp | Evidence | Notes |
|---|---|---|---:|---|---|---:|---|---|
| [kimi-w1](../../runs/kimi-w1.md) | kimi-k3.1-pro (xhigh) | 28 × 1 | +19.1 | 0.768 (0.586–1.015) | 20/28 → 19/28 | −3.6 | screen ×1 |  |

## Contents

- [`.claude-plugin/plugin.json`](.claude-plugin/plugin.json)
- [`output-styles/efficient.md`](output-styles/efficient.md)

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
claude --plugin-dir experiments/variants/K_synth
```

The marketplace installs only the released `plugin/`. This directory is kept byte-for-byte as tested (tests and internal notes removed); the plugin name inside `plugin.json` may clash with an installed token-saver, so use `--plugin-dir` for a single session.
