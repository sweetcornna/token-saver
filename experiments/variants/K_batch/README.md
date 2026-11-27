# `K_batch`

Parallel independent reads, line-range slices, batched edits, verify once and finish.

并行只读、按行切片、合并编辑、验证一次后结束。

| | |
|---|---|
| Type | plugin |
| Status | screen only |
| Composite score | **+9.2** (mean of 1 run); rank 27 of 40 in the [variant leaderboard](../../README.md#leaderboard-by-variant) |

Back to the [experiment library](../../README.md).

## Results

Each row compares this variant with native Claude Code in the same run (same model, effort, tasks and repetitions). Score = cost-per-resolved-task saving; see the [composite score](../../README.md#composite-score).

| Run | Model (effort) | Tasks × reps | Score | Cost vs. native (95% CI) | Resolved, native → variant | Δ pp | Evidence | Notes |
|---|---|---|---:|---|---|---:|---|---|
| [kimi-w1](../../runs/kimi-w1.md) | kimi-k3.1-pro (xhigh) | 28 × 1 | +9.2 | 0.817 (0.614–1.065) | 20/28 → 18/28 | −7.1 | screen ×1 |  |

## Contents

- [`.claude-plugin/plugin.json`](.claude-plugin/plugin.json)
- [`output-styles/efficient.md`](output-styles/efficient.md)

Output-style text (front matter omitted):

```markdown
# Efficient tool use

- Minimize round trips: whenever multiple searches, file reads, or shell checks are independent, issue them in parallel in a single turn (or chain quick read-only checks with `&&`).
- Pinpoint exact line ranges with search before reading, and read only the relevant slices rather than full files.
- Batch related edits together in one turn once you know the fix, then verify once with targeted tests and finish.
```

## Try it

```bash
claude --plugin-dir experiments/variants/K_batch
```

The marketplace installs only the released `plugin/`. This directory is kept byte-for-byte as tested (tests and internal notes removed); the plugin name inside `plugin.json` may clash with an installed token-saver, so use `--plugin-dir` for a single session.
