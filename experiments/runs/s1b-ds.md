# S1b — deepseek-v4.1-flash (max)

deepseek 上拆分投递方式、成本句与单个原子：8 臂 × 82 题 × 1 次。

Run `20261125-plugin-s1b-ds`, 2026-11-25 (UTC). Back to the [experiment library](../README.md).

## Setup

| Item | Value |
|---|---|
| Model / effort | `deepseek-v4.1-flash`, `max` |
| Harness | Claude Code 2.1.323; one fresh session per task × arm × repetition; arms interleaved task by task |
| Tasks | SWE-bench Verified, task set `dev-82` (82 tasks); task IDs are in the data file |
| Repetitions | 1 |
| Limits | 80 turns and 2,400 s per attempt; up to 3 attempts on infrastructure errors only |
| Tools | WebSearch and WebFetch disabled; sandbox without internet access |
| Environment | `ENABLE_TOOL_SEARCH=false`; subagents (if any) use the tested model |
| Scoring | official SWE-bench evaluation of the final patch |
| Cost | fixed price from the per-request usage ledger, all attempts, cache warm-up normalised; deepseek-v4.1-flash (off-peak list): uncached 1, cache read 0.02, cache write 1, output 4 CNY per 1M tokens. Not an invoice. |
| Cells | 656 / 656 valid |

## Arms

| Arm | Files | Content |
|---|---|---|
| `000` | — | native Claude Code, no plugin |
| `001` | [`variants/001`](../variants/001/) | Cost preamble + F3 batch edits only. |
| `010` | [`variants/010`](../variants/010/) | Cost preamble + F2 only (no re-reads; finish once verified). Same text as the 2026-11-11 `abl-nobatch` arm. |
| `111` | [`plugin/`](../../plugin/) | Cost preamble + batch read-only steps (F1) + no re-reads and finish once verified (F2) + batch edits (F3). This is `plugin/`. |
| `shell` | [`variants/shell`](../variants/shell/) | Control: heading plus the one cost sentence ("Every tool call re-sends the whole conversation… Work the same way you normally would."), no habits. |
| `styleEmpty` | [`variants/styleEmpty`](../variants/styleEmpty/) | Control: an output style that contains only the heading line. Measures the effect of delivering any output style. |
| `100` | [`variants/100`](../variants/100/) | Cost preamble + F1 batch read-only steps only. Same text as the 2026-11-11 `abl-batchonly` arm. |
| `appendCost` | [`variants/appendCost`](../variants/appendCost/) | Not a plugin: the `shell` cost sentence passed with `--append-system-prompt` instead of an output style. |

## Results against native (`000`)

Score = cost-per-resolved-task saving (see the [library README](../README.md#composite-score)). Requests and output per request are descriptive, computed from the data file over the paired tasks.

| Arm | Score | Paired tasks | Cost vs. native (95% CI) | Resolved, native → arm | Δ pp | Main-thread requests | Output per request |
|---|---:|---:|---|---|---:|---:|---:|
| `001` | +28.6 | 82 | 0.736 (0.635–0.844) | 65/82 → 67/82 | +2.4 | 0.80× | 0.87× |
| `010` | +27.1 | 82 | 0.718 (0.619–0.858) | 65/82 → 64/82 | −1.2 | 0.79× | 0.86× |
| `111` | +20.6 | 82 | 0.757 (0.653–0.894) | 65/82 → 62/82 | −3.7 | 0.77× | 0.96× |
| `shell` | +19.7 | 82 | 0.766 (0.657–0.906) | 65/82 → 62/82 | −3.7 | 0.84× | 0.85× |
| `styleEmpty` | +14.5 | 82 | 0.855 (0.737–0.979) | 65/82 → 65/82 | +0.0 | 0.93× | 0.88× |
| `100` | +13.5 | 82 | 0.838 (0.722–0.994) | 65/82 → 63/82 | −2.4 | 0.87× | 0.93× |
| `appendCost` | −3.5 | 82 | 1.019 (0.907–1.163) | 65/82 → 64/82 | −1.2 | 1.05× | 0.95× |

- [b] The native arm of this run had 4.9% of sessions with missing usage, above the 2% data-quality limit.

## Other comparisons

| Comparison | Cost ratio (95% CI) | Resolved |
|---|---|---|
| `shell` vs `styleEmpty` (cost sentence inside a style) | 0.895 (0.804–1.003) | 65 → 62 |
| `100` vs `shell` (F1) | 1.094 (0.971–1.257) | 62 → 63 |
| `010` vs `shell` (F2) | 0.938 (0.846–1.044) | 62 → 64 |
| `001` vs `shell` (F3) | 0.961 (0.869–1.079) | 62 → 67 |
| `111` vs `shell` (all atoms) | 0.989 (0.877–1.122) | 62 → 62 |

## Outcome

- Delivering an output style at all saves money on deepseek (`styleEmpty` 0.855, upper bound < 1).
- The same cost sentence passed with `--append-system-prompt` does nothing (`appendCost` 1.019).
- Of the single habits on top of `shell`, only F2 shows a hint; F1 is slightly costlier. The habits' effects differ from haiku (`111` vs `shell` 0.894 on haiku, 0.989 here).
- Next run (S1c) split F2 into F2a (no re-reads) and F2b (finish once verified).

## Data

[`../data/s1b-ds.csv`](../data/s1b-ds.csv): one row per task × arm × repetition (validity, resolution, end state, requests, output tokens, final-attempt token breakdown, fixed-price cost). Session logs, request ledgers and server details are not published.
