# `noAgent`

Not a plugin: native Claude Code with `--disallowedTools Agent Task` (no subagents).

非插件：原生加 `--disallowedTools Agent Task`。

| | |
|---|---|
| Type | config |
| Status | not advanced |
| Composite score | **−8.9** (mean of 1 run); rank 35 of 40 in the [variant leaderboard](../../README.md#leaderboard-by-variant) |

Back to the [experiment library](../../README.md).

## Results

Each row compares this variant with native Claude Code in the same run (same model, effort, tasks and repetitions). Score = cost-per-resolved-task saving; see the [composite score](../../README.md#composite-score).

| Run | Model (effort) | Tasks × reps | Score | Cost vs. native (95% CI) | Resolved, native → variant | Δ pp | Evidence | Notes |
|---|---|---|---:|---|---|---:|---|---|
| [s1-haiku](../../runs/s1-haiku.md) | claude-haiku-5-5 (max) | 82 × 1 | −8.9 | 1.106 (0.977–1.267) | 65/82 → 66/82 | +1.2 | screen ×1 |  |

## Contents

No files: this arm is a command-line setting.

## Try it

```bash
claude --disallowedTools Agent Task
```
