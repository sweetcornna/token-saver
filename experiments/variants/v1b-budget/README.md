# `v1b-budget`

PostToolUse hook that adds a budget reminder at the 50th and 90th tool call. No valid follow-up confirmation.

第 50、90 次工具调用时追加预算提醒的 hook；没有有效的后续确认。

| | |
|---|---|
| Type | plugin |
| Status | not confirmed |
| Composite score | **+34.2** (mean of 1 run); rank 9 of 40 in the [variant leaderboard](../../README.md#leaderboard-by-variant) |

Back to the [experiment library](../../README.md).

## Results

Each row compares this variant with native Claude Code in the same run (same model, effort, tasks and repetitions). Score = cost-per-resolved-task saving; see the [composite score](../../README.md#composite-score).

| Run | Model (effort) | Tasks × reps | Score | Cost vs. native (95% CI) | Resolved, native → variant | Δ pp | Evidence | Notes |
|---|---|---|---:|---|---|---:|---|---|
| [ccb5](../../runs/2026-11-08-to-12.md#ccb5) | deepseek-v4.1-flash (max) | 97 × 2 | +34.2 | 0.675 (0.566–0.809) | 75.3% → 77.3% | +2.1 | dev ×2 | [h] |

- [h] Gateway list-price cost, not the fixed-price ledger.

## Contents

- [`.claude-plugin/plugin.json`](.claude-plugin/plugin.json)
- [`hooks/budget.py`](hooks/budget.py)
- [`hooks/hooks.json`](hooks/hooks.json)

## Try it

```bash
claude --plugin-dir experiments/variants/v1b-budget
```

The marketplace installs only the released `plugin/`. This directory is kept byte-for-byte as tested (tests and internal notes removed); the plugin name inside `plugin.json` may clash with an installed token-saver, so use `--plugin-dir` for a single session.
