# `v1a-brief`

"Brief reasoning" output style: think just enough to choose the next step. Lost 8.3 pp on a second task set (that run was later voided for a gateway cache fault) and failed the quality condition in a later screen on another harness.

“简短推理” output style；在另一题集上掉 8.3pp（该批后因网关缓存故障作废），后续另一宿主上的筛选也没过质量条件。

| | |
|---|---|
| Type | plugin |
| Status | rejected |
| Composite score | **+42.0** (mean of 1 run); rank 2 of 40 in the [variant leaderboard](../../README.md#leaderboard-by-variant) |

Back to the [experiment library](../../README.md).

## Results

Each row compares this variant with native Claude Code in the same run (same model, effort, tasks and repetitions). Score = cost-per-resolved-task saving; see the [composite score](../../README.md#composite-score).

| Run | Model (effort) | Tasks × reps | Score | Cost vs. native (95% CI) | Resolved, native → variant | Δ pp | Evidence | Notes |
|---|---|---|---:|---|---|---:|---|---|
| [ccb5](../../runs/2026-11-08-to-12.md#ccb5) | deepseek-v4.1-flash (max) | 97 × 2 | +42.0 | 0.568 (0.397–0.807) | 75.3% → 73.7% | −1.5 | dev ×2 | [h] |

- [h] Gateway list-price cost, not the fixed-price ledger.

## Contents

- [`.claude-plugin/plugin.json`](.claude-plugin/plugin.json)
- [`output-styles/brief.md`](output-styles/brief.md)

Output-style text (front matter omitted):

```markdown
# Brief reasoning

Thinking tokens are billed like output and are usually the largest part of the cost of a task. Keep your reasoning short and practical:

- Think just enough to choose the next step, then take it. Let tool results, not long deliberation, settle open questions.
- Don't weigh alternatives you are not going to pursue, and don't restate what a tool output already shows.
- When a plausible fix is clear, implement it and check it; reconsider only if the check fails.
```

## Try it

```bash
claude --plugin-dir experiments/variants/v1a-brief
```

The marketplace installs only the released `plugin/`. This directory is kept byte-for-byte as tested (tests and internal notes removed); the plugin name inside `plugin.json` may clash with an installed token-saver, so use `--plugin-dir` for a single session.
