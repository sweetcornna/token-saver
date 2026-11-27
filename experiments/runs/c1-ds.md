# C1 — held-out confirmation, deepseek-v4.1-flash (max)

留出确认批：98 道开发期未用过的题 × 2 臂 × 4 次。

Run `20261126-plugin-c1-ds`, 2026-11-26 (UTC). Back to the [experiment library](../README.md).

## Setup

| Item | Value |
|---|---|
| Model / effort | `deepseek-v4.1-flash`, `max` |
| Harness | Claude Code 2.1.323; one fresh session per task × arm × repetition; arms interleaved task by task |
| Tasks | SWE-bench Verified, task set `held-out-98` (98 tasks); task IDs are in the data file |
| Repetitions | 4 |
| Limits | 80 turns and 2,400 s per attempt; up to 3 attempts on infrastructure errors only |
| Tools | WebSearch and WebFetch disabled; sandbox without internet access |
| Environment | `ENABLE_TOOL_SEARCH=false`; subagents (if any) use the tested model |
| Scoring | official SWE-bench evaluation of the final patch |
| Cost | fixed price from the per-request usage ledger, all attempts, cache warm-up normalised; deepseek-v4.1-flash (off-peak list): uncached 1, cache read 0.02, cache write 1, output 4 CNY per 1M tokens. Not an invoice. |
| Cells | 784 / 784 valid, 0% missing usage, 1% excluded |

## Arms

| Arm | Files | Content |
|---|---|---|
| `000` | — | native Claude Code, no plugin |
| `F2bOnly` | [`variants/F2bOnly`](../variants/F2bOnly/) | Heading + F2b only: "Once the change is made and the relevant tests or reproduction pass, finish." Best arm on deepseek; held-out cost confirmed, quality not established. |

## Results against native (`000`)

Score = cost-per-resolved-task saving (see the [library README](../README.md#composite-score)). Requests and output per request are descriptive, computed from the data file over the paired tasks.

| Arm | Score | Paired tasks | Cost vs. native (95% CI) | Resolved, native → arm | Δ pp | Main-thread requests | Output per request |
|---|---:|---:|---|---|---:|---:|---:|
| `F2bOnly` | +28.1 | 97 | 0.696 (0.616–0.776) | 313/388 → 303/388 | −2.6 | 0.80× | 0.85× |

## Outcome

- Cost **confirmed**: `F2bOnly` / native 0.696 (0.616–0.776), upper bound < 1 and point estimate ≤ 0.80.
- Quality **not established**: resolved 80.7% → 78.1% (−2.6 pp; one-sided 95% lower bound −6.9 pp, cluster-adjusted). Non-inferiority at 3 pp and at 5 pp both fail (p_worse 0.14).
- The loss is concentrated in 4 tasks (django-11532 4→0, django-15629 4→0, matplotlib-20859 4→1, sympy-14248 3→0; −14 in total), while the other 93 tasks net +4. On the two Django tasks the agent stopped as soon as the reported reproduction passed and missed sibling code paths.
- The released plugin was not replaced. The 98 tasks are now used and no longer count as held-out.

## Data

[`../data/c1-ds.csv`](../data/c1-ds.csv): one row per task × arm × repetition (validity, resolution, end state, requests, output tokens, final-attempt token breakdown, fixed-price cost). Session logs, request ledgers and server details are not published.
