# `000D`

Cost preamble + delegation rule D ("work in the main session; delegate only independent investigations"). No arm dispatched a subagent in its run, so D had nothing to act on.

成本引言 + 委派纪律 D。

| | |
|---|---|
| Type | plugin |
| Status | not advanced |
| Composite score | **+36.4** (mean of 1 run); rank 6 of 40 in the [variant leaderboard](../../README.md#leaderboard-by-variant) |

Back to the [experiment library](../../README.md).

## Results

Each row compares this variant with native Claude Code in the same run (same model, effort, tasks and repetitions). Score = cost-per-resolved-task saving; see the [composite score](../../README.md#composite-score).

| Run | Model (effort) | Tasks × reps | Score | Cost vs. native (95% CI) | Resolved, native → variant | Δ pp | Evidence | Notes |
|---|---|---|---:|---|---|---:|---|---|
| [s1-haiku](../../runs/s1-haiku.md) | claude-haiku-5-5 (max) | 82 × 1 | +36.4 | 0.675 (0.603–0.757) | 65/82 → 69/82 | +4.9 | screen ×1 | [a] |

- [a] Computed for this table from the per-task data with the run's own method; not part of the run's pre-registered analysis.

## Contents

- [`.claude-plugin/plugin.json`](.claude-plugin/plugin.json)
- [`output-styles/efficient.md`](output-styles/efficient.md)

Output-style text (front matter omitted):

```markdown
# Efficient tool use

Every tool call re-sends the whole conversation, so the number of round trips drives the cost of a task. Work the same way you normally would, with these habits:

- Work directly in the main session by default. Do not delegate routine reads, searches, test runs, or single-issue debugging to subagents—each subagent starts a fresh context and multiplies cost. Only delegate if there are multiple genuinely independent, self-contained investigations, and keep each delegated task tightly scoped.
```

## Try it

```bash
claude --plugin-dir experiments/variants/000D
```

The marketplace installs only the released `plugin/`. This directory is kept byte-for-byte as tested (tests and internal notes removed); the plugin name inside `plugin.json` may clash with an installed token-saver, so use `--plugin-dir` for a single session.
