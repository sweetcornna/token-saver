# S1c — deepseek-v4.1-flash (max)

把 F2 拆成 F2a 不重读、F2b 验证后结束：7 臂 × 82 题 × 2 次。

Run `20261125-plugin-s1c-ds`, 2026-11-26 (UTC). Back to the [experiment library](../README.md).

## Setup

| Item | Value |
|---|---|
| Model / effort | `deepseek-v4.1-flash`, `max` |
| Harness | Claude Code 2.1.323; one fresh session per task × arm × repetition; arms interleaved task by task |
| Tasks | SWE-bench Verified, task set `dev-82` (82 tasks); task IDs are in the data file |
| Repetitions | 2 |
| Limits | 80 turns and 2,400 s per attempt; up to 3 attempts on infrastructure errors only |
| Tools | WebSearch and WebFetch disabled; sandbox without internet access |
| Environment | `ENABLE_TOOL_SEARCH=false`; subagents (if any) use the tested model |
| Scoring | official SWE-bench evaluation of the final patch |
| Cost | fixed price from the per-request usage ledger, all attempts, cache warm-up normalised; deepseek-v4.1-flash (off-peak list): uncached 1, cache read 0.02, cache write 1, output 4 CNY per 1M tokens. Not an invoice. |
| Cells | 1,148 / 1,148 valid, 0% missing usage |

## Arms

| Arm | Files | Content |
|---|---|---|
| `000` | — | native Claude Code, no plugin |
| `F2bOnly` | [`variants/F2bOnly`](../variants/F2bOnly/) | Heading + F2b only: "Once the change is made and the relevant tests or reproduction pass, finish." Best arm on deepseek; held-out cost confirmed, quality not established. |
| `010` | [`variants/010`](../variants/010/) | Cost preamble + F2 only (no re-reads; finish once verified). Same text as the 2026-11-11 `abl-nobatch` arm. |
| `F2only` | [`variants/F2only`](../variants/F2only/) | Heading + F2 (no re-reads; finish once verified), no cost sentence. |
| `shell` | [`variants/shell`](../variants/shell/) | Control: heading plus the one cost sentence ("Every tool call re-sends the whole conversation… Work the same way you normally would."), no habits. |
| `F2aOnly` | [`variants/F2aOnly`](../variants/F2aOnly/) | Heading + F2a only: don't re-read unchanged files or re-run unchanged commands. |
| `styleEmpty` | [`variants/styleEmpty`](../variants/styleEmpty/) | Control: an output style that contains only the heading line. Measures the effect of delivering any output style. |

## Results against native (`000`)

Score = cost-per-resolved-task saving (see the [library README](../README.md#composite-score)). Requests and output per request are descriptive, computed from the data file over the paired tasks.

| Arm | Score | Paired tasks | Cost vs. native (95% CI) | Resolved, native → arm | Δ pp | Main-thread requests | Output per request |
|---|---:|---:|---|---|---:|---:|---:|
| `F2bOnly` | +35.4 | 80 | 0.631 (0.559–0.708) | 127/160 → 124/160 | −1.9 | 0.70× | 0.82× |
| `010` | +32.7 | 81 | 0.679 (0.601–0.761) | 127/162 → 128/162 | +0.6 | 0.73× | 0.88× |
| `F2only` | +30.3 | 80 | 0.675 (0.591–0.760) | 126/160 → 122/160 | −2.5 | 0.71× | 0.90× |
| `shell` | +26.5 | 80 | 0.735 (0.648–0.825) | 125/160 → 125/160 | +0.0 | 0.78× | 0.91× |
| `F2aOnly` | +24.0 | 80 | 0.766 (0.687–0.852) | 125/160 → 126/160 | +0.6 | 0.81× | 0.91× |
| `styleEmpty` | +22.2 | 81 | 0.760 (0.677–0.844) | 127/162 → 124/162 | −1.9 | 0.80× | 0.91× |

## Other comparisons

| Comparison | Cost ratio (95% CI) | Resolved |
|---|---|---|
| cost sentence: `shell` vs `styleEmpty` | 0.969 (0.886–1.063) | 124/162 → 127/162 |
| cost sentence: `010` vs `F2only` | 0.997 (0.921–1.088) | 124/162 → 128/162 |
| F2: `F2only` vs `styleEmpty` | 0.894 (0.804–0.989) | 126/162 → 124/162 |
| F2a: `F2aOnly` vs `styleEmpty` | 0.996 (0.911–1.095) | 124/162 → 128/162 |
| F2b: `F2bOnly` vs `styleEmpty` | 0.831 (0.756–0.916) | 126/162 → 126/162 |

## Outcome

- All six arms were cheaper than native with upper bounds below 1.
- Marginal effects: the cost sentence and F2a have none; **F2b (finish once verified) does** (0.831 on top of `styleEmpty`).
- By the pre-registered rule `F2bOnly` (lowest, 0.631) was selected for the held-out confirmation C1. The dev set had been used three times, so 0.631 is optimistic.

## Data

[`../data/s1c-ds.csv`](../data/s1c-ds.csv): one row per task × arm × repetition (validity, resolution, end state, requests, output tokens, final-attempt token breakdown, fixed-price cost). Session logs, request ledgers and server details are not published.
