# `v1`

v0 with the closing rule replaced by "cover the related cases, one targeted test, then finish".

v0 的收尾条改为“覆盖相关情形、一个定向测试后结束”。

| | |
|---|---|
| Type | plugin |
| Status | rejected |
| Composite score | **+25.0** (mean of 1 run); rank 17 of 40 in the [variant leaderboard](../../README.md#leaderboard-by-variant) |

Back to the [experiment library](../../README.md).

## Results

Each row compares this variant with native Claude Code in the same run (same model, effort, tasks and repetitions). Score = cost-per-resolved-task saving; see the [composite score](../../README.md#composite-score).

| Run | Model (effort) | Tasks × reps | Score | Cost vs. native (95% CI) | Resolved, native → variant | Δ pp | Evidence | Notes |
|---|---|---|---:|---|---|---:|---|---|
| [ccb8](../../runs/2026-11-08-to-12.md#ccb8) | deepseek-v4.1-flash (max) | 97 × 2 | +25.0 | 0.739 | 75.8% → 74.7% | −1.0 | dev ×2 | +10.5% vs v0 |

## Contents

- [`.claude-plugin/plugin.json`](.claude-plugin/plugin.json)
- [`output-styles/efficient.md`](output-styles/efficient.md)

Output-style text (front matter omitted):

```markdown
# Efficient tool use

Every tool call re-sends the whole conversation, so the number of round trips drives the cost of a task. Work the same way you normally would, with these habits:

- Batch independent read-only steps. When several reads, searches, or checks don't depend on each other, issue them together: several tool calls in one response, or one shell command joined with `;` or `&&`.
- Don't re-read a file or re-run a command whose output you have already seen and that has not changed since. Refer back to the earlier output instead.
- Before finishing, make sure the change also covers the related cases the issue implies: other inputs that should behave the same way, and other code paths that share the changed logic. One targeted test or reproduction is enough. Once it passes, finish. Don't repeat checks that already passed or re-verify results that cannot have changed.
```

## Try it

```bash
claude --plugin-dir experiments/variants/v1
```

The marketplace installs only the released `plugin/`. This directory is kept byte-for-byte as tested (tests and internal notes removed); the plugin name inside `plugin.json` may clash with an installed token-saver, so use `--plugin-dir` for a single session.
