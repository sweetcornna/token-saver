# `appendCost`

Not a plugin: the `shell` cost sentence passed with `--append-system-prompt` instead of an output style.

非插件：同一句成本提示经 `--append-system-prompt` 投递。

| | |
|---|---|
| Type | config |
| Status | not advanced |
| Composite score | **−3.5** (mean of 1 run); rank 33 of 40 in the [variant leaderboard](../../README.md#leaderboard-by-variant) |

Back to the [experiment library](../../README.md).

## Results

Each row compares this variant with native Claude Code in the same run (same model, effort, tasks and repetitions). Score = cost-per-resolved-task saving; see the [composite score](../../README.md#composite-score).

| Run | Model (effort) | Tasks × reps | Score | Cost vs. native (95% CI) | Resolved, native → variant | Δ pp | Evidence | Notes |
|---|---|---|---:|---|---|---:|---|---|
| [s1b-ds](../../runs/s1b-ds.md) | deepseek-v4.1-flash (max) | 82 × 1 | −3.5 | 1.019 (0.907–1.163) | 65/82 → 64/82 | −1.2 | screen ×1 | [b] |

- [b] The native arm of this run had 4.9% of sessions with missing usage, above the 2% data-quality limit.

## Contents

- [`cost.txt`](cost.txt)

Text:

```text
Every tool call re-sends the whole conversation, so the number of round trips drives the cost of a task. Work the same way you normally would.
```

## Try it

```bash
claude --append-system-prompt "$(cat experiments/variants/appendCost/cost.txt)"
```
