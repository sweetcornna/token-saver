# `F2bSuite`

Heading + a stricter closing rule: finish once every case in the issue is handled and both the reproduction and the existing tests for the changed code pass.

标题 + 更严格的结束条件（覆盖全部情形且复现与相关测试都通过）。

| | |
|---|---|
| Type | plugin |
| Status | rejected |
| Composite score | **+35.3** (mean of 1 run); rank 7 of 40 in the [variant leaderboard](../../README.md#leaderboard-by-variant) |

Back to the [experiment library](../../README.md).

## Results

Each row compares this variant with native Claude Code in the same run (same model, effort, tasks and repetitions). Score = cost-per-resolved-task saving; see the [composite score](../../README.md#composite-score).

| Run | Model (effort) | Tasks × reps | Score | Cost vs. native (95% CI) | Resolved, native → variant | Δ pp | Evidence | Notes |
|---|---|---|---:|---|---|---:|---|---|
| [s1d-ds](../../runs/s1d-ds.md) | deepseek-v4.1-flash (max) | 82 × 3 | +35.3 | 0.623 (0.535–0.712) | 190/237 → 183/237 | −3.0 | dev ×3 |  |

## Contents

- [`.claude-plugin/plugin.json`](.claude-plugin/plugin.json)
- [`output-styles/efficient.md`](output-styles/efficient.md)

Output-style text (front matter omitted):

```markdown
# Efficient tool use

- Once the fix handles every case the issue describes, and both the reproduction and the existing tests for the code you changed pass, finish. Don't repeat checks that already passed or re-verify results that cannot have changed.
```

## Try it

```bash
claude --plugin-dir experiments/variants/F2bSuite
```

The marketplace installs only the released `plugin/`. This directory is kept byte-for-byte as tested (tests and internal notes removed); the plugin name inside `plugin.json` may clash with an installed token-saver, so use `--plugin-dir` for a single session.
