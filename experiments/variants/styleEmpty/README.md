# `styleEmpty`

Control: an output style that contains only the heading line. Measures the effect of delivering any output style.

对照：只有标题行的 output style，量投递方式本身。

| | |
|---|---|
| Type | plugin |
| Status | control |
| Composite score | **+17.8** (mean of 4 runs, range +5.9 … +28.6); rank 23 of 40 in the [variant leaderboard](../../README.md#leaderboard-by-variant) |

Back to the [experiment library](../../README.md).

## Results

Each row compares this variant with native Claude Code in the same run (same model, effort, tasks and repetitions). Score = cost-per-resolved-task saving; see the [composite score](../../README.md#composite-score).

| Run | Model (effort) | Tasks × reps | Score | Cost vs. native (95% CI) | Resolved, native → variant | Δ pp | Evidence | Notes |
|---|---|---|---:|---|---|---:|---|---|
| [s1d-ds](../../runs/s1d-ds.md) | deepseek-v4.1-flash (max) | 82 × 3 | +28.6 | 0.703 (0.637–0.785) | 191/237 → 188/237 | −1.3 | dev ×3 |  |
| [s1c-ds](../../runs/s1c-ds.md) | deepseek-v4.1-flash (max) | 82 × 2 | +22.2 | 0.760 (0.677–0.844) | 127/162 → 124/162 | −1.9 | dev ×2 |  |
| [s1b-ds](../../runs/s1b-ds.md) | deepseek-v4.1-flash (max) | 82 × 1 | +14.5 | 0.855 (0.737–0.979) | 65/82 → 65/82 | +0.0 | screen ×1 | [b] |
| [kimi-w1](../../runs/kimi-w1.md) | kimi-k3.1-pro (xhigh) | 28 × 1 | +5.9 | 0.847 (0.659–1.039) | 20/28 → 18/28 | −7.1 | screen ×1 |  |

- [b] The native arm of this run had 4.9% of sessions with missing usage, above the 2% data-quality limit.

## Contents

- [`.claude-plugin/plugin.json`](.claude-plugin/plugin.json)
- [`output-styles/efficient.md`](output-styles/efficient.md)

Output-style text (front matter omitted):

```markdown
# Efficient tool use
```

## Try it

```bash
claude --plugin-dir experiments/variants/styleEmpty
```

The marketplace installs only the released `plugin/`. This directory is kept byte-for-byte as tested (tests and internal notes removed); the plugin name inside `plugin.json` may clash with an installed token-saver, so use `--plugin-dir` for a single session.
