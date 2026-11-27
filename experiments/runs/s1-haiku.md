# S1 — claude-haiku-5-5 (max)

haiku 上的第一批方向检验：6 臂 × 82 题 × 1 次。

Run `20261125-plugin-s1-haiku`, 2026-11-25 (UTC). Back to the [experiment library](../README.md).

## Setup

| Item | Value |
|---|---|
| Model / effort | `claude-haiku-5-5`, `max` |
| Harness | Claude Code 2.1.323; one fresh session per task × arm × repetition; arms interleaved task by task |
| Tasks | SWE-bench Verified, task set `dev-82` (82 tasks); task IDs are in the data file |
| Repetitions | 1 |
| Limits | 80 turns and 2,400 s per attempt; up to 3 attempts on infrastructure errors only |
| Tools | WebSearch and WebFetch disabled; sandbox without internet access |
| Environment | `ENABLE_TOOL_SEARCH=false`; subagents (if any) use the tested model |
| Scoring | official SWE-bench evaluation of the final patch |
| Cost | fixed price from the per-request usage ledger, all attempts, cache warm-up normalised; claude-haiku-5-5: uncached 0.72, cache read 0.072, cache write 0.9 (1 h: 1.44), output 3.6 CNY per 1M tokens. Not an invoice. |
| Cells | 492 / 492 valid |

## Arms

| Arm | Files | Content |
|---|---|---|
| `000` | — | native Claude Code, no plugin |
| `111` | [`plugin/`](../../plugin/) | Cost preamble + batch read-only steps (F1) + no re-reads and finish once verified (F2) + batch edits (F3). This is `plugin/`. |
| `111D` | [`variants/111D`](../variants/111D/) | `111` + delegation rule D. No arm dispatched a subagent in its run; against `111` it cost 1.075 (0.973–1.164). |
| `000D` | [`variants/000D`](../variants/000D/) | Cost preamble + delegation rule D ("work in the main session; delegate only independent investigations"). No arm dispatched a subagent in its run, so D had nothing to act on. |
| `shell` | [`variants/shell`](../variants/shell/) | Control: heading plus the one cost sentence ("Every tool call re-sends the whole conversation… Work the same way you normally would."), no habits. |
| `noAgent` | [`variants/noAgent`](../variants/noAgent/) | Not a plugin: native Claude Code with `--disallowedTools Agent Task` (no subagents). |

## Results against native (`000`)

Score = cost-per-resolved-task saving (see the [library README](../README.md#composite-score)). Requests and output per request are descriptive, computed from the data file over the paired tasks.

| Arm | Score | Paired tasks | Cost vs. native (95% CI) | Resolved, native → arm | Δ pp | Main-thread requests | Output per request |
|---|---:|---:|---|---|---:|---:|---:|
| `111` | +42.8 | 81 | 0.590 (0.537–0.652) | 64/81 → 66/81 | +2.5 | 0.44× | 1.74× |
| `111D` | +37.5 | 82 | 0.634 (0.565–0.706) | 65/82 → 66/82 | +1.2 | 0.42× | 2.03× |
| `000D` | +36.4 | 82 | 0.675 (0.603–0.757) | 65/82 → 69/82 | +4.9 | 0.62× | 1.29× |
| `shell` | +36.0 | 82 | 0.660 (0.602–0.724) | 65/82 → 67/82 | +2.4 | 0.55× | 1.45× |
| `noAgent` | −8.9 | 82 | 1.106 (0.977–1.267) | 65/82 → 66/82 | +1.2 | 1.14× | 0.92× |

- [c] 2 of 81 sessions of this arm had missing usage (2.47%), above the 2% limit. The run's pre-registered mechanism gate failed (output per request 1.74× native, limit 1.15×).
- [a] Computed for this table from the per-task data with the run's own method; not part of the run's pre-registered analysis.

## Other comparisons

| Comparison | Cost ratio (95% CI) | Resolved |
|---|---|---|
| `111` vs `shell` | 0.894 (0.83–0.97) | 66/81 → 66/81 |
| `111D` vs `111` | 1.075 (0.973–1.164) | 66/81 → 65/81 |
| `000D` vs `shell` | 1.023 (0.908–1.150) | 67/82 → 69/82 |

## Outcome

- Pre-registered mechanism gate for `111` vs native **failed**: main-thread requests fell to 0.441× (upper bound 0.466), but output per request rose to 1.742× (limit 1.15×), and 2.47% of the arm's sessions had missing usage (limit 2%). Not advanced.
- About two thirds of the cost drop already appears with the `shell` control. `shell` and every output style also swap one identity sentence in Claude Code's system prompt, so this run cannot separate the swap from the cost sentence.
- No arm dispatched a subagent, so the delegation rule `D` and `noAgent` had nothing to act on; their rows are descriptive.

## Data

[`../data/s1-haiku.csv`](../data/s1-haiku.csv): one row per task × arm × repetition (validity, resolution, end state, requests, output tokens, final-attempt token breakdown, fixed-price cost). Session logs, request ledgers and server details are not published.
