# `010`

Cost preamble + F2 only (no re-reads; finish once verified). Same text as the 2026-11-11 `abl-nobatch` arm.

成本引言 + 只有 F2（与 11-11 的 abl-nobatch 同文）。

| | |
|---|---|
| Type | plugin |
| Status | superseded by F2bOnly |
| Composite score | **+16.2** (mean of 3 runs, range −11.3 … +32.7); rank 24 of 40 in the [variant leaderboard](../../README.md#leaderboard-by-variant) |

Back to the [experiment library](../../README.md).

## Results

Each row compares this variant with native Claude Code in the same run (same model, effort, tasks and repetitions). Score = cost-per-resolved-task saving; see the [composite score](../../README.md#composite-score).

| Run | Model (effort) | Tasks × reps | Score | Cost vs. native (95% CI) | Resolved, native → variant | Δ pp | Evidence | Notes |
|---|---|---|---:|---|---|---:|---|---|
| [s1c-ds](../../runs/s1c-ds.md) | deepseek-v4.1-flash (max) | 82 × 2 | +32.7 | 0.679 (0.601–0.761) | 127/162 → 128/162 | +0.6 | dev ×2 |  |
| [s1b-ds](../../runs/s1b-ds.md) | deepseek-v4.1-flash (max) | 82 × 1 | +27.1 | 0.718 (0.619–0.858) | 65/82 → 64/82 | −1.2 | screen ×1 | [b] |
| [sc1](../../runs/2026-11-08-to-12.md#sc1) | deepseek-v4.1-flash (xhigh) | 30 × 1 | −11.3 | 1.062 (0.632–1.919) | 22/30 → 21/30 | −3.3 | screen ×1 | as abl-nobatch |

- [b] The native arm of this run had 4.9% of sessions with missing usage, above the 2% data-quality limit.

## Contents

- [`.claude-plugin/plugin.json`](.claude-plugin/plugin.json)
- [`output-styles/efficient.md`](output-styles/efficient.md)

Output-style text (front matter omitted):

```markdown
# Efficient tool use

Every tool call re-sends the whole conversation, so the number of round trips drives the cost of a task. Work the same way you normally would, with these habits:

- Don't re-read a file or re-run a command whose output you have already seen and that has not changed since. Refer back to the earlier output instead.
- Once the change is made and the relevant tests or reproduction pass, finish. Don't repeat checks that already passed or re-verify results that cannot have changed.
```

## Try it

```bash
claude --plugin-dir experiments/variants/010
```

The marketplace installs only the released `plugin/`. This directory is kept byte-for-byte as tested (tests and internal notes removed); the plugin name inside `plugin.json` may clash with an installed token-saver, so use `--plugin-dir` for a single session.
