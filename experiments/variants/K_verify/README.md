# `K_verify`

Verify with targeted existing tests (never the full suite), reuse one `/tmp/repro.py`, stop once verified.

只跑定向测试、复用一个复现脚本、验证即止。

| | |
|---|---|
| Type | plugin |
| Status | screen only |
| Composite score | **+25.1** (mean of 1 run); rank 16 of 40 in the [variant leaderboard](../../README.md#leaderboard-by-variant) |

Back to the [experiment library](../../README.md).

## Results

Each row compares this variant with native Claude Code in the same run (same model, effort, tasks and repetitions). Score = cost-per-resolved-task saving; see the [composite score](../../README.md#composite-score).

| Run | Model (effort) | Tasks × reps | Score | Cost vs. native (95% CI) | Resolved, native → variant | Δ pp | Evidence | Notes |
|---|---|---|---:|---|---|---:|---|---|
| [kimi-w1](../../runs/kimi-w1.md) | kimi-k3.1-pro (xhigh) | 28 × 1 | +25.1 | 0.824 (0.673–1.023) | 20/28 → 22/28 | +7.1 | screen ×1 |  |

## Contents

- [`.claude-plugin/plugin.json`](.claude-plugin/plugin.json)
- [`output-styles/efficient.md`](output-styles/efficient.md)

Output-style text (front matter omitted):

```markdown
# Efficient tool use

- Reproduce and verify with the repository's existing targeted tests whenever possible. If you need a custom reproduction script, write one short script (e.g. `/tmp/repro.py`) and reuse it instead of emitting repeated inline Python scripts.
- Run only the targeted test file or test case for the code you changed—never run the entire repository test suite unless explicitly requested.
- Once the fix is verified by the targeted tests or reproduction, stop. Do not repeat passing checks or make extra speculative edits afterward.
```

## Try it

```bash
claude --plugin-dir experiments/variants/K_verify
```

The marketplace installs only the released `plugin/`. This directory is kept byte-for-byte as tested (tests and internal notes removed); the plugin name inside `plugin.json` may clash with an installed token-saver, so use `--plugin-dir` for a single session.
