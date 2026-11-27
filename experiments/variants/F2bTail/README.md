# `F2bTail`

Heading + only the second half of F2b ("don't repeat checks that already passed"), without "finish".

标题 + 只保留“不重复已过的检查”。

| | |
|---|---|
| Type | plugin |
| Status | rejected |
| Composite score | **+34.4** (mean of 1 run); rank 8 of 40 in the [variant leaderboard](../../README.md#leaderboard-by-variant) |

Back to the [experiment library](../../README.md).

## Results

Each row compares this variant with native Claude Code in the same run (same model, effort, tasks and repetitions). Score = cost-per-resolved-task saving; see the [composite score](../../README.md#composite-score).

| Run | Model (effort) | Tasks × reps | Score | Cost vs. native (95% CI) | Resolved, native → variant | Δ pp | Evidence | Notes |
|---|---|---|---:|---|---|---:|---|---|
| [s1d-ds](../../runs/s1d-ds.md) | deepseek-v4.1-flash (max) | 82 × 3 | +34.4 | 0.659 (0.601–0.715) | 193/240 → 194/240 | +0.4 | dev ×3 |  |

## Contents

- [`.claude-plugin/plugin.json`](.claude-plugin/plugin.json)
- [`output-styles/efficient.md`](output-styles/efficient.md)

Output-style text (front matter omitted):

```markdown
# Efficient tool use

- Don't repeat checks that already passed or re-verify results that cannot have changed.
```

## Try it

```bash
claude --plugin-dir experiments/variants/F2bTail
```

The marketplace installs only the released `plugin/`. This directory is kept byte-for-byte as tested (tests and internal notes removed); the plugin name inside `plugin.json` may clash with an installed token-saver, so use `--plugin-dir` for a single session.
