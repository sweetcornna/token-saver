# `v0-notes`

v0 + a SessionStart hook that injects notes learned from earlier tasks in the same repository. Versus v0: 0.917 (0.752–1.115); indistinguishable from mismatched notes.

v0 + 注入同仓库先前题目学到的笔记；对 v0 为 0.917（区间跨 1），与错配笔记分不开。

| | |
|---|---|
| Type | plugin |
| Status | inconclusive |
| Composite score | **+40.6** (mean of 1 run); rank 3 of 40 in the [variant leaderboard](../../README.md#leaderboard-by-variant) |
| Same output-style text as | [`v2-env`](../v2-env/), [`v2-stop-gate`](../v2-stop-gate/), [`v0`](../v0/) |

Back to the [experiment library](../../README.md).

## Results

Each row compares this variant with native Claude Code in the same run (same model, effort, tasks and repetitions). Score = cost-per-resolved-task saving; see the [composite score](../../README.md#composite-score).

| Run | Model (effort) | Tasks × reps | Score | Cost vs. native (95% CI) | Resolved, native → variant | Δ pp | Evidence | Notes |
|---|---|---|---:|---|---|---:|---|---|
| [seq1](../../runs/2026-11-08-to-12.md#seq1) | deepseek-v4.1-flash (max) | 61 × 2 | +40.6 | 0.571 | 84.4% → 81.1% | −3.3 | dev ×2 | vs v0: 0.917 (0.752–1.115) |

## Contents

- [`blocks/filler.txt`](blocks/filler.txt)
- [`blocks/mismatched_sympy.txt`](blocks/mismatched_sympy.txt)
- [`.claude-plugin/plugin.json`](.claude-plugin/plugin.json)
- [`hooks/hooks.json`](hooks/hooks.json)
- [`hooks/notes.py`](hooks/notes.py)
- [`output-styles/efficient.md`](output-styles/efficient.md)

Output-style text (front matter omitted):

```markdown
# Efficient tool use

Every tool call re-sends the whole conversation, so the number of round trips drives the cost of a task. Work the same way you normally would, with these habits:

- Batch independent read-only steps. When several reads, searches, or checks don't depend on each other, issue them together: several tool calls in one response, or one shell command joined with `;` or `&&`.
- Don't re-read a file or re-run a command whose output you have already seen and that has not changed since. Refer back to the earlier output instead.
- Once the change is made and the relevant tests or reproduction pass, finish. Don't repeat checks that already passed or re-verify results that cannot have changed.
```

## Try it

```bash
claude --plugin-dir experiments/variants/v0-notes
```

The marketplace installs only the released `plugin/`. This directory is kept byte-for-byte as tested (tests and internal notes removed); the plugin name inside `plugin.json` may clash with an installed token-saver, so use `--plugin-dir` for a single session.
