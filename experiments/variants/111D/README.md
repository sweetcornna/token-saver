# `111D`

`111` + delegation rule D. No arm dispatched a subagent in its run; against `111` it cost 1.075 (0.973–1.164).

`111` + 委派纪律 D。

| | |
|---|---|
| Type | plugin |
| Status | not advanced |
| Composite score | **+37.5** (mean of 1 run); rank 5 of 40 in the [variant leaderboard](../../README.md#leaderboard-by-variant) |

Back to the [experiment library](../../README.md).

## Results

Each row compares this variant with native Claude Code in the same run (same model, effort, tasks and repetitions). Score = cost-per-resolved-task saving; see the [composite score](../../README.md#composite-score).

| Run | Model (effort) | Tasks × reps | Score | Cost vs. native (95% CI) | Resolved, native → variant | Δ pp | Evidence | Notes |
|---|---|---|---:|---|---|---:|---|---|
| [s1-haiku](../../runs/s1-haiku.md) | claude-haiku-5-5 (max) | 82 × 1 | +37.5 | 0.634 (0.565–0.706) | 65/82 → 66/82 | +1.2 | screen ×1 | [a] |

- [a] Computed for this table from the per-task data with the run's own method; not part of the run's pre-registered analysis.

## Contents

- [`.claude-plugin/plugin.json`](.claude-plugin/plugin.json)
- [`output-styles/efficient.md`](output-styles/efficient.md)

Output-style text (front matter omitted):

```markdown
# Efficient tool use

Every tool call re-sends the whole conversation, so the number of round trips drives the cost of a task. Work the same way you normally would, with these habits:

- Batch independent read-only steps. When several reads, searches, or checks don't depend on each other, issue them together: several tool calls in one response, or one shell command joined with `;` or `&&`.
- Batch edits. Once you know the changes you want, make them all in one response, including several edits to the same file and the edits to tests and docs, instead of one edit per response.
- Don't re-read a file or re-run a command whose output you have already seen and that has not changed since. Refer back to the earlier output instead.
- Once the change is made and the relevant tests or reproduction pass, finish. Don't repeat checks that already passed or re-verify results that cannot have changed.
- Work directly in the main session by default. Do not delegate routine reads, searches, test runs, or single-issue debugging to subagents—each subagent starts a fresh context and multiplies cost. Only delegate if there are multiple genuinely independent, self-contained investigations, and keep each delegated task tightly scoped.
```

## Try it

```bash
claude --plugin-dir experiments/variants/111D
```

The marketplace installs only the released `plugin/`. This directory is kept byte-for-byte as tested (tests and internal notes removed); the plugin name inside `plugin.json` may clash with an installed token-saver, so use `--plugin-dir` for a single session.
