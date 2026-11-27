# `K_explore`

Targeted search and sliced reads, no git-history archaeology, check sibling code paths before editing.

直达定位、切片读、不做 git 考古、改前查同模块兄弟路径。

| | |
|---|---|
| Type | plugin |
| Status | screen only |
| Composite score | **−2.8** (mean of 1 run); rank 32 of 40 in the [variant leaderboard](../../README.md#leaderboard-by-variant) |

Back to the [experiment library](../../README.md).

## Results

Each row compares this variant with native Claude Code in the same run (same model, effort, tasks and repetitions). Score = cost-per-resolved-task saving; see the [composite score](../../README.md#composite-score).

| Run | Model (effort) | Tasks × reps | Score | Cost vs. native (95% CI) | Resolved, native → variant | Δ pp | Evidence | Notes |
|---|---|---|---:|---|---|---:|---|---|
| [kimi-w1](../../runs/kimi-w1.md) | kimi-k3.1-pro (xhigh) | 28 × 1 | −2.8 | 0.874 (0.667–1.116) | 20/28 → 17/28 | −10.7 | screen ×1 |  |

## Contents

- [`.claude-plugin/plugin.json`](.claude-plugin/plugin.json)
- [`output-styles/efficient.md`](output-styles/efficient.md)

Output-style text (front matter omitted):

```markdown
# Efficient tool use

- Go straight to the relevant source and test files: locate target symbols with one search, then read only the needed functions or slices in parallel instead of paging whole files sequentially.
- Stay focused on the current codebase and issue. Skip git history archaeology (`log`, `branch`, `tag`, `reflog`), changelogs, and unrelated built-in skills unless the task explicitly asks about history.
- Keep edits scoped to the issue, and check closely related callers or sibling paths in the same module before editing so you fix the root cause completely.
```

## Try it

```bash
claude --plugin-dir experiments/variants/K_explore
```

The marketplace installs only the released `plugin/`. This directory is kept byte-for-byte as tested (tests and internal notes removed); the plugin name inside `plugin.json` may clash with an installed token-saver, so use `--plugin-dir` for a single session.
