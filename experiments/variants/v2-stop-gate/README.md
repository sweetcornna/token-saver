# `v2-stop-gate`

v0 + a Stop hook closing gate. The gate changed code after firing in only 2 of 120 sessions, so its gain is run-to-run noise.

v0 + Stop hook 收尾闸门；触发后真正再改代码的只有 2/120 个会话。

| | |
|---|---|
| Type | plugin |
| Status | rejected |
| Composite score | **+38.6** (mean of 1 run); rank 4 of 40 in the [variant leaderboard](../../README.md#leaderboard-by-variant) |
| Same output-style text as | [`v2-env`](../v2-env/), [`v0-notes`](../v0-notes/), [`v0`](../v0/) |

Back to the [experiment library](../../README.md).

## Results

Each row compares this variant with native Claude Code in the same run (same model, effort, tasks and repetitions). Score = cost-per-resolved-task saving; see the [composite score](../../README.md#composite-score).

| Run | Model (effort) | Tasks × reps | Score | Cost vs. native (95% CI) | Resolved, native → variant | Δ pp | Evidence | Notes |
|---|---|---|---:|---|---|---:|---|---|
| [dt1](../../runs/2026-11-08-to-12.md#dt1) | deepseek-v4.1-flash (xhigh) | 60 × 2 | +38.6 | 0.646 (0.521–0.786) | 80.0% → 84.2% | +4.2 | dev ×2 | gate changed code after firing in 2/120 sessions |

## Contents

- [`.claude-plugin/plugin.json`](.claude-plugin/plugin.json)
- [`hooks/gate.sh`](hooks/gate.sh)
- [`hooks/hooks.json`](hooks/hooks.json)
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
claude --plugin-dir experiments/variants/v2-stop-gate
```

The marketplace installs only the released `plugin/`. This directory is kept byte-for-byte as tested (tests and internal notes removed); the plugin name inside `plugin.json` may clash with an installed token-saver, so use `--plugin-dir` for a single session.
