# `F2only`

Heading + F2 (no re-reads; finish once verified), no cost sentence.

标题 + F2，无成本句。

| | |
|---|---|
| Type | plugin |
| Status | superseded by F2bOnly |
| Composite score | **+30.3** (mean of 1 run); rank 11 of 40 in the [variant leaderboard](../../README.md#leaderboard-by-variant) |

Back to the [experiment library](../../README.md).

## Results

Each row compares this variant with native Claude Code in the same run (same model, effort, tasks and repetitions). Score = cost-per-resolved-task saving; see the [composite score](../../README.md#composite-score).

| Run | Model (effort) | Tasks × reps | Score | Cost vs. native (95% CI) | Resolved, native → variant | Δ pp | Evidence | Notes |
|---|---|---|---:|---|---|---:|---|---|
| [s1c-ds](../../runs/s1c-ds.md) | deepseek-v4.1-flash (max) | 82 × 2 | +30.3 | 0.675 (0.591–0.760) | 126/160 → 122/160 | −2.5 | dev ×2 |  |

## Contents

- [`.claude-plugin/plugin.json`](.claude-plugin/plugin.json)
- [`output-styles/efficient.md`](output-styles/efficient.md)

Output-style text (front matter omitted):

```markdown
# Efficient tool use

- Don't re-read a file or re-run a command whose output you have already seen and that has not changed since. Refer back to the earlier output instead.
- Once the change is made and the relevant tests or reproduction pass, finish. Don't repeat checks that already passed or re-verify results that cannot have changed.
```

## Try it

```bash
claude --plugin-dir experiments/variants/F2only
```

The marketplace installs only the released `plugin/`. This directory is kept byte-for-byte as tested (tests and internal notes removed); the plugin name inside `plugin.json` may clash with an installed token-saver, so use `--plugin-dir` for a single session.
