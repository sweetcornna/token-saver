# `100`

Cost preamble + F1 batch read-only steps only. Same text as the 2026-11-11 `abl-batchonly` arm.

成本引言 + 只有 F1 合并只读（与 11-11 的 abl-batchonly 同文）。

| | |
|---|---|
| Type | plugin |
| Status | not advanced |
| Composite score | **+18.3** (mean of 2 runs, range +13.5 … +23.0); rank 22 of 40 in the [variant leaderboard](../../README.md#leaderboard-by-variant) |

Back to the [experiment library](../../README.md).

## Results

Each row compares this variant with native Claude Code in the same run (same model, effort, tasks and repetitions). Score = cost-per-resolved-task saving; see the [composite score](../../README.md#composite-score).

| Run | Model (effort) | Tasks × reps | Score | Cost vs. native (95% CI) | Resolved, native → variant | Δ pp | Evidence | Notes |
|---|---|---|---:|---|---|---:|---|---|
| [sc1](../../runs/2026-11-08-to-12.md#sc1) | deepseek-v4.1-flash (xhigh) | 30 × 1 | +23.0 | 0.735 (0.594–0.937) | 22/30 → 21/30 | −3.3 | screen ×1 | as abl-batchonly |
| [s1b-ds](../../runs/s1b-ds.md) | deepseek-v4.1-flash (max) | 82 × 1 | +13.5 | 0.838 (0.722–0.994) | 65/82 → 63/82 | −2.4 | screen ×1 | [b] |

- [b] The native arm of this run had 4.9% of sessions with missing usage, above the 2% data-quality limit.

## Contents

- [`.claude-plugin/plugin.json`](.claude-plugin/plugin.json)
- [`output-styles/efficient.md`](output-styles/efficient.md)

Output-style text (front matter omitted):

```markdown
# Efficient tool use

Every tool call re-sends the whole conversation, so the number of round trips drives the cost of a task. Work the same way you normally would, with these habits:

- Batch independent read-only steps. When several reads, searches, or checks don't depend on each other, issue them together: several tool calls in one response, or one shell command joined with `;` or `&&`.
```

## Try it

```bash
claude --plugin-dir experiments/variants/100
```

The marketplace installs only the released `plugin/`. This directory is kept byte-for-byte as tested (tests and internal notes removed); the plugin name inside `plugin.json` may clash with an installed token-saver, so use `--plugin-dir` for a single session.
