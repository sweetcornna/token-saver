# `v0`

Cost preamble + F1 + F2 (no F3). The first release (0.1.0); same text as the `110` atom combination.

成本引言 + F1 + F2（无 F3），首个发布版 0.1.0。

| | |
|---|---|
| Type | plugin |
| Status | previous release 0.1.0 |
| Composite score | **+30.7** (mean of 10 runs, range +17.7 … +40.3); rank 10 of 40 in the [variant leaderboard](../../README.md#leaderboard-by-variant) |
| Same output-style text as | [`v2-env`](../v2-env/), [`v0-notes`](../v0-notes/), [`v2-stop-gate`](../v2-stop-gate/) |

Back to the [experiment library](../../README.md).

## Results

Each row compares this variant with native Claude Code in the same run (same model, effort, tasks and repetitions). Score = cost-per-resolved-task saving; see the [composite score](../../README.md#composite-score).

| Run | Model (effort) | Tasks × reps | Score | Cost vs. native (95% CI) | Resolved, native → variant | Δ pp | Evidence | Notes |
|---|---|---|---:|---|---|---:|---|---|
| [lunamax1](../../runs/2026-11-08-to-12.md#lunamax1) | gpt-6-luna (max) | 60 × 2 | +40.3 | 0.624 (0.419–0.971) | 72.5% → 75.8% | +3.3 | dev ×2 | [d] |
| [ccb4](../../runs/2026-11-08-to-12.md#ccb4) | deepseek-v4.1-flash (max) | 97 × 2 | +37.2 | 0.640 (0.517–0.793) | 75.3% → 76.8% | +1.5 | dev ×2 | [h] |
| [seq1](../../runs/2026-11-08-to-12.md#seq1) | deepseek-v4.1-flash (max) | 61 × 2 | +37.2 | 0.622 (0.532–0.719) | 84.4% → 83.6% | −0.8 | dev ×2 |  |
| [dt3](../../runs/2026-11-08-to-12.md#dt3) | deepseek-v4.1-flash (xhigh) | 60 × 2 | +34.5 | 0.683 (0.552–0.869) | 78.3% → 81.7% | +3.3 | dev ×2 |  |
| [dt1](../../runs/2026-11-08-to-12.md#dt1) | deepseek-v4.1-flash (xhigh) | 60 × 2 | +32.3 | 0.677 (0.546–0.805) | 80.0% → 80.0% | +0.0 | dev ×2 |  |
| [ccb8](../../runs/2026-11-08-to-12.md#ccb8) | deepseek-v4.1-flash (max) | 97 × 2 | +32.1 | 0.669 (0.562–0.769) | 75.8% → 74.7% | −1.0 | dev ×2 |  |
| [cf1](../../runs/2026-11-08-to-12.md#cf1) | deepseek-v4.1-flash (xhigh) | 174 × 2 | +27.3 | 0.727 (0.647–0.823) | 75.0% → 75.0% | +0.0 | held-out ×2 | held-out confirmation; NI lower bound −3.16pp |
| [ccb7d](../../runs/2026-11-08-to-12.md#ccb7d) | deepseek-v4.1-flash (max) | 60 × 2 | +24.9 | 0.729 | 84.2% → 81.7% | −2.5 | dev ×2 |  |
| [sc1-medium](../../runs/2026-11-08-to-12.md#sc1-medium) | deepseek-v4.1-flash (medium) | 30 × 1 | +23.3 | 0.732 (0.597–0.895) | 22/30 → 21/30 | −3.3 | screen ×1 | vs medium-effort native |
| [sc1](../../runs/2026-11-08-to-12.md#sc1) | deepseek-v4.1-flash (xhigh) | 30 × 1 | +17.7 | 0.786 (0.630–0.968) | 22/30 → 21/30 | −3.3 | screen ×1 |  |

- [d] The run failed its procedural checks (usage gaps), so it is descriptive only.
- [h] Gateway list-price cost, not the fixed-price ledger.

## Contents

- [`.claude-plugin/plugin.json`](.claude-plugin/plugin.json)
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
claude --plugin-dir experiments/variants/v0
```

The marketplace installs only the released `plugin/`. This directory is kept byte-for-byte as tested (tests and internal notes removed); the plugin name inside `plugin.json` may clash with an installed token-saver, so use `--plugin-dir` for a single session.
