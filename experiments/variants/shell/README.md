# `shell`

Control: heading plus the one cost sentence ("Every tool call re-sends the whole conversation… Work the same way you normally would."), no habits.

对照：标题加一句成本提示，不含习惯。

| | |
|---|---|
| Type | plugin |
| Status | control |
| Composite score | **+27.4** (mean of 3 runs, range +19.7 … +36.0); rank 14 of 40 in the [variant leaderboard](../../README.md#leaderboard-by-variant) |

Back to the [experiment library](../../README.md).

## Results

Each row compares this variant with native Claude Code in the same run (same model, effort, tasks and repetitions). Score = cost-per-resolved-task saving; see the [composite score](../../README.md#composite-score).

| Run | Model (effort) | Tasks × reps | Score | Cost vs. native (95% CI) | Resolved, native → variant | Δ pp | Evidence | Notes |
|---|---|---|---:|---|---|---:|---|---|
| [s1-haiku](../../runs/s1-haiku.md) | claude-haiku-5-5 (max) | 82 × 1 | +36.0 | 0.660 (0.602–0.724) | 65/82 → 67/82 | +2.4 | screen ×1 |  |
| [s1c-ds](../../runs/s1c-ds.md) | deepseek-v4.1-flash (max) | 82 × 2 | +26.5 | 0.735 (0.648–0.825) | 125/160 → 125/160 | +0.0 | dev ×2 |  |
| [s1b-ds](../../runs/s1b-ds.md) | deepseek-v4.1-flash (max) | 82 × 1 | +19.7 | 0.766 (0.657–0.906) | 65/82 → 62/82 | −3.7 | screen ×1 | [b] |

- [b] The native arm of this run had 4.9% of sessions with missing usage, above the 2% data-quality limit.

## Contents

- [`.claude-plugin/plugin.json`](.claude-plugin/plugin.json)
- [`output-styles/efficient.md`](output-styles/efficient.md)

Output-style text (front matter omitted):

```markdown
# Efficient tool use

Every tool call re-sends the whole conversation, so the number of round trips drives the cost of a task. Work the same way you normally would.
```

## Try it

```bash
claude --plugin-dir experiments/variants/shell
```

The marketplace installs only the released `plugin/`. This directory is kept byte-for-byte as tested (tests and internal notes removed); the plugin name inside `plugin.json` may clash with an installed token-saver, so use `--plugin-dir` for a single session.
