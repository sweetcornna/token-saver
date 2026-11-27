# `001`

Cost preamble + F3 batch edits only.

成本引言 + 只有 F3 合并编辑。

| | |
|---|---|
| Type | plugin |
| Status | not advanced |
| Composite score | **+28.6** (mean of 1 run); rank 13 of 40 in the [variant leaderboard](../../README.md#leaderboard-by-variant) |

Back to the [experiment library](../../README.md).

## Results

Each row compares this variant with native Claude Code in the same run (same model, effort, tasks and repetitions). Score = cost-per-resolved-task saving; see the [composite score](../../README.md#composite-score).

| Run | Model (effort) | Tasks × reps | Score | Cost vs. native (95% CI) | Resolved, native → variant | Δ pp | Evidence | Notes |
|---|---|---|---:|---|---|---:|---|---|
| [s1b-ds](../../runs/s1b-ds.md) | deepseek-v4.1-flash (max) | 82 × 1 | +28.6 | 0.736 (0.635–0.844) | 65/82 → 67/82 | +2.4 | screen ×1 | [b] |

- [b] The native arm of this run had 4.9% of sessions with missing usage, above the 2% data-quality limit.

## Contents

- [`.claude-plugin/plugin.json`](.claude-plugin/plugin.json)
- [`output-styles/efficient.md`](output-styles/efficient.md)

Output-style text (front matter omitted):

```markdown
# Efficient tool use

Every tool call re-sends the whole conversation, so the number of round trips drives the cost of a task. Work the same way you normally would, with these habits:

- Batch edits. Once you know the changes you want, make them all in one response, including several edits to the same file and the edits to tests and docs, instead of one edit per response.
```

## Try it

```bash
claude --plugin-dir experiments/variants/001
```

The marketplace installs only the released `plugin/`. This directory is kept byte-for-byte as tested (tests and internal notes removed); the plugin name inside `plugin.json` may clash with an installed token-saver, so use `--plugin-dir` for a single session.
