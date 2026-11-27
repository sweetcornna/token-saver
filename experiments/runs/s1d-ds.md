# S1d — deepseek-v4.1-flash (max)

尝试保住质量的两种 F2b 改写：5 臂 × 82 题 × 3 次。

Run `20261126-plugin-s1d-ds`, 2026-11-26 (UTC). Back to the [experiment library](../README.md).

## Setup

| Item | Value |
|---|---|
| Model / effort | `deepseek-v4.1-flash`, `max` |
| Harness | Claude Code 2.1.323; one fresh session per task × arm × repetition; arms interleaved task by task |
| Tasks | SWE-bench Verified, task set `dev-82` (82 tasks); task IDs are in the data file |
| Repetitions | 3 |
| Limits | 80 turns and 2,400 s per attempt; up to 3 attempts on infrastructure errors only |
| Tools | WebSearch and WebFetch disabled; sandbox without internet access |
| Environment | `ENABLE_TOOL_SEARCH=false`; subagents (if any) use the tested model |
| Scoring | official SWE-bench evaluation of the final patch |
| Cost | fixed price from the per-request usage ledger, all attempts, cache warm-up normalised; deepseek-v4.1-flash (off-peak list): uncached 1, cache read 0.02, cache write 1, output 4 CNY per 1M tokens. Not an invoice. |
| Cells | 1,230 / 1,230 valid, 0% missing usage |

## Arms

| Arm | Files | Content |
|---|---|---|
| `000` | — | native Claude Code, no plugin |
| `F2bOnly` | [`variants/F2bOnly`](../variants/F2bOnly/) | Heading + F2b only: "Once the change is made and the relevant tests or reproduction pass, finish." Best arm on deepseek; held-out cost confirmed, quality not established. |
| `F2bSuite` | [`variants/F2bSuite`](../variants/F2bSuite/) | Heading + a stricter closing rule: finish once every case in the issue is handled and both the reproduction and the existing tests for the changed code pass. |
| `F2bTail` | [`variants/F2bTail`](../variants/F2bTail/) | Heading + only the second half of F2b ("don't repeat checks that already passed"), without "finish". |
| `styleEmpty` | [`variants/styleEmpty`](../variants/styleEmpty/) | Control: an output style that contains only the heading line. Measures the effect of delivering any output style. |

## Results against native (`000`)

Score = cost-per-resolved-task saving (see the [library README](../README.md#composite-score)). Requests and output per request are descriptive, computed from the data file over the paired tasks.

| Arm | Score | Paired tasks | Cost vs. native (95% CI) | Resolved, native → arm | Δ pp | Main-thread requests | Output per request |
|---|---:|---:|---|---|---:|---:|---:|
| `F2bOnly` | +42.7 | 80 | 0.585 (0.521–0.653) | 193/240 → 197/240 | +1.7 | 0.66× | 0.88× |
| `F2bSuite` | +35.3 | 79 | 0.623 (0.535–0.712) | 190/237 → 183/237 | −3.0 | 0.66× | 0.93× |
| `F2bTail` | +34.4 | 80 | 0.659 (0.601–0.715) | 193/240 → 194/240 | +0.4 | 0.72× | 0.90× |
| `styleEmpty` | +28.6 | 79 | 0.703 (0.637–0.785) | 191/237 → 188/237 | −1.3 | 0.77× | 0.91× |

## Other comparisons

| Comparison | Cost ratio (95% CI) | Resolved |
|---|---|---|
| `F2bTail` vs `F2bOnly` | 1.137 (1.025–1.263) | 82.1% → 80.4% |
| `F2bSuite` vs `F2bOnly` | 1.071 (0.923–1.229) | 81.9% → 76.8% (p_worse 0.002) |

## Outcome

- Neither rewording helped: `F2bTail` is costlier than `F2bOnly` without better quality, and `F2bSuite` loses 5.1 pp against it.
- `F2bOnly` stays the deepseek candidate. Its effect on resolution across three runs: −1.9 pp (S1c), −2.6 pp (C1), +1.7 pp (S1d).
- On deepseek, the only factors with a measurable cost effect are delivering an output style and the F2b closing rule.

## Data

[`../data/s1d-ds.csv`](../data/s1d-ds.csv): one row per task × arm × repetition (validity, resolution, end state, requests, output tokens, final-attempt token breakdown, fixed-price cost). Session logs, request ledgers and server details are not published.
