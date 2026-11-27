# `F2bOnly`

Heading + F2b only: "Once the change is made and the relevant tests or reproduction pass, finish." Best arm on deepseek; held-out cost confirmed, quality not established.

标题 + 只有 F2b 验证后结束；deepseek 最佳臂，留出集费用确认、质量未定。

| | |
|---|---|
| Type | plugin |
| Status | candidate (deepseek) |
| Composite score | **+29.9** (mean of 5 runs, range +21.0 … +42.7); rank 12 of 40 in the [variant leaderboard](../../README.md#leaderboard-by-variant) |
| Same output-style text as | [`F2b_m1`](../F2b_m1/) |

Back to the [experiment library](../../README.md).

## Results

Each row compares this variant with native Claude Code in the same run (same model, effort, tasks and repetitions). Score = cost-per-resolved-task saving; see the [composite score](../../README.md#composite-score).

| Run | Model (effort) | Tasks × reps | Score | Cost vs. native (95% CI) | Resolved, native → variant | Δ pp | Evidence | Notes |
|---|---|---|---:|---|---|---:|---|---|
| [s1d-ds](../../runs/s1d-ds.md) | deepseek-v4.1-flash (max) | 82 × 3 | +42.7 | 0.585 (0.521–0.653) | 193/240 → 197/240 | +1.7 | dev ×3 |  |
| [s1c-ds](../../runs/s1c-ds.md) | deepseek-v4.1-flash (max) | 82 × 2 | +35.4 | 0.631 (0.559–0.708) | 127/160 → 124/160 | −1.9 | dev ×2 |  |
| [c1-ds](../../runs/c1-ds.md) | deepseek-v4.1-flash (max) | 98 × 4 | +28.1 | 0.696 (0.616–0.776) | 313/388 → 303/388 | −2.6 | held-out ×4 | held-out confirmation |
| [kimi-w2](../../runs/kimi-w2.md) | kimi-k3.1-pro (xhigh) | 40 × 1 | +22.2 | 0.691 (0.444–1.014) | 36/40 → 32/40 | −10.0 | screen ×1 | [e] 10%-trimmed 0.66 |
| [kimi-w1](../../runs/kimi-w1.md) | kimi-k3.1-pro (xhigh) | 28 × 1 | +21.0 | 0.750 (0.605–0.934) | 20/28 → 19/28 | −3.6 | screen ×1 |  |

- [e] Seven long tasks that hit turn or time limits dominate the totals, and per-request uncached input rose about 17× between this run and the previous Kimi run for every arm, native included. Arms in this run could not be separated from each other.

## Contents

- [`.claude-plugin/plugin.json`](.claude-plugin/plugin.json)
- [`output-styles/efficient.md`](output-styles/efficient.md)

Output-style text (front matter omitted):

```markdown
# Efficient tool use

- Once the change is made and the relevant tests or reproduction pass, finish. Don't repeat checks that already passed or re-verify results that cannot have changed.
```

## Try it

```bash
claude --plugin-dir experiments/variants/F2bOnly
```

The marketplace installs only the released `plugin/`. This directory is kept byte-for-byte as tested (tests and internal notes removed); the plugin name inside `plugin.json` may clash with an installed token-saver, so use `--plugin-dir` for a single session.
