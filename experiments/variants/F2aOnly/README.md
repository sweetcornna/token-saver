# `F2aOnly`

Heading + F2a only: don't re-read unchanged files or re-run unchanged commands.

标题 + 只有 F2a 不重读。

| | |
|---|---|
| Type | plugin |
| Status | not advanced |
| Composite score | **+24.0** (mean of 1 run); rank 18 of 40 in the [variant leaderboard](../../README.md#leaderboard-by-variant) |

Back to the [experiment library](../../README.md).

## Results

Each row compares this variant with native Claude Code in the same run (same model, effort, tasks and repetitions). Score = cost-per-resolved-task saving; see the [composite score](../../README.md#composite-score).

| Run | Model (effort) | Tasks × reps | Score | Cost vs. native (95% CI) | Resolved, native → variant | Δ pp | Evidence | Notes |
|---|---|---|---:|---|---|---:|---|---|
| [s1c-ds](../../runs/s1c-ds.md) | deepseek-v4.1-flash (max) | 82 × 2 | +24.0 | 0.766 (0.687–0.852) | 125/160 → 126/160 | +0.6 | dev ×2 |  |

## Contents

- [`.claude-plugin/plugin.json`](.claude-plugin/plugin.json)
- [`output-styles/efficient.md`](output-styles/efficient.md)

Output-style text (front matter omitted):

```markdown
# Efficient tool use

- Don't re-read a file or re-run a command whose output you have already seen and that has not changed since. Refer back to the earlier output instead.
```

## Try it

```bash
claude --plugin-dir experiments/variants/F2aOnly
```

The marketplace installs only the released `plugin/`. This directory is kept byte-for-byte as tested (tests and internal notes removed); the plugin name inside `plugin.json` may clash with an installed token-saver, so use `--plugin-dir` for a single session.
