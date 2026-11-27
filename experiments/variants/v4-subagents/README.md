# `v4-subagents`

v0 + plugin subagents (scout, runner, tracer) at lower reasoning effort for search/read/run steps. 41.1% costlier than v0.

v0 + 低推理强度的子代理派发；比 v0 贵 41.1%。

| | |
|---|---|
| Type | plugin |
| Status | rejected |
| Composite score | **+10.4** (mean of 1 run); rank 26 of 40 in the [variant leaderboard](../../README.md#leaderboard-by-variant) |

Back to the [experiment library](../../README.md).

## Results

Each row compares this variant with native Claude Code in the same run (same model, effort, tasks and repetitions). Score = cost-per-resolved-task saving; see the [composite score](../../README.md#composite-score).

| Run | Model (effort) | Tasks × reps | Score | Cost vs. native (95% CI) | Resolved, native → variant | Δ pp | Evidence | Notes |
|---|---|---|---:|---|---|---:|---|---|
| [dt3](../../runs/2026-11-08-to-12.md#dt3) | deepseek-v4.1-flash (xhigh) | 60 × 2 | +10.4 | 0.964 (0.637–1.542) | 78.3% → 84.2% | +5.8 | dev ×2 | +41.1% vs v0 |

## Contents

- [`agents/runner.md`](agents/runner.md)
- [`agents/scout.md`](agents/scout.md)
- [`agents/tracer.md`](agents/tracer.md)
- [`.claude-plugin/plugin.json`](.claude-plugin/plugin.json)
- [`output-styles/efficient.md`](output-styles/efficient.md)

Output-style text (front matter omitted):

```markdown
# Efficient tool use

Every tool call re-sends the whole conversation, so the number of round trips drives the cost of a task. Work the same way you normally would, with these habits:

- Batch independent read-only steps. When several reads, searches, or checks don't depend on each other, issue them together: several tool calls in one response, or one shell command joined with `;` or `&&`.
- Don't re-read a file or re-run a command whose output you have already seen and that has not changed since. Refer back to the earlier output instead.
- Once the change is made and the relevant tests or reproduction pass, finish. Don't repeat checks that already passed or re-verify results that cannot have changed.

# Delegating routine steps to lower-effort helpers

You work at a high reasoning effort. That is worth paying for when you decide what the fix is and when you write it. Finding code, reading around it, and running commands to see what happens need less reasoning. Hand those steps to the token-saver helper agents (Agent tool). They run on the same model at a lower effort and report back briefly.

- `token-saver:scout` (low effort, read-only): locate where something is defined, raised, or handled; list callers or the tests that cover a module; summarize what a function does.
- `token-saver:runner` (low effort): run a reproduction, a test file, or a short script and report the outcome: pass/fail counts, the error and the few traceback lines that matter.
- `token-saver:tracer` (medium effort, read-only): follow a behaviour across several files, for example why an input takes a certain path or where two code paths diverge, and report the chain with locations.

When and how:
- A typical start: in one response, send a scout to find where the behaviour lives and which tests cover it, and a runner to reproduce the problem. Read the lines they point to, decide the fix, edit, then send a runner to run the closest tests.
- Delegate a step that would take you about four or more tool calls. Do it yourself when one or two calls would do: one search, one known file, one test command. Each delegation has a fixed cost.
- Pass `run_in_background: false`, since your next step depends on the answer. Independent questions go together: several Agent calls in one response run in parallel.
- A helper sees nothing of this conversation. Give it the repository path, one or two sentences of the task, exactly what to find or run, and what to return.
- Helpers report findings as `path:line` with the smallest snippet that matters. Read only those line ranges yourself before editing (a file must be read before it is edited).
- Keep the decision about the fix, the edits, and the judgement of the final verification to yourself. Don't repeat a helper's search unless its report lacks something you need.
```

## Try it

```bash
claude --plugin-dir experiments/variants/v4-subagents
```

The marketplace installs only the released `plugin/`. This directory is kept byte-for-byte as tested (tests and internal notes removed); the plugin name inside `plugin.json` may clash with an installed token-saver, so use `--plugin-dir` for a single session.
