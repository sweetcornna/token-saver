# `H_m1`

Only the M1 SessionStart hook (prints Python version, top-level entries and the targeted test command; about 45 tokens), no output style.

只有 M1 hook（约 45 token 的工作区与测试命令），无 output style。

| | |
|---|---|
| Type | plugin |
| Status | screen only |
| Composite score | **−13.9** (mean of 1 run); rank 36 of 40 in the [variant leaderboard](../../README.md#leaderboard-by-variant) |

Back to the [experiment library](../../README.md).

## Results

Each row compares this variant with native Claude Code in the same run (same model, effort, tasks and repetitions). Score = cost-per-resolved-task saving; see the [composite score](../../README.md#composite-score).

| Run | Model (effort) | Tasks × reps | Score | Cost vs. native (95% CI) | Resolved, native → variant | Δ pp | Evidence | Notes |
|---|---|---|---:|---|---|---:|---|---|
| [kimi-w1](../../runs/kimi-w1.md) | kimi-k3.1-pro (xhigh) | 28 × 1 | −13.9 | 1.025 (0.785–1.299) | 20/28 → 18/28 | −7.1 | screen ×1 |  |

## Contents

- [`.claude-plugin/plugin.json`](.claude-plugin/plugin.json)
- [`hooks/hooks.json`](hooks/hooks.json)
- [`hooks/m1_env_probe.py`](hooks/m1_env_probe.py)

The M1 hook (`hooks/m1_env_probe.py`) is a `SessionStart` hook that prints about 45 tokens of workspace facts: the Python version, top-level entries and the repository's targeted test command (for example Django's `tests/runtests.py`). It makes no model calls and reads nothing outside the working directory.

## Try it

```bash
claude --plugin-dir experiments/variants/H_m1
```

The marketplace installs only the released `plugin/`. This directory is kept byte-for-byte as tested (tests and internal notes removed); the plugin name inside `plugin.json` may clash with an installed token-saver, so use `--plugin-dir` for a single session.
