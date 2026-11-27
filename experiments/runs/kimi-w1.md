# Kimi W1 — kimi-k3.1-pro (xhigh), 10-arm screen

Kimi 十臂筛选：28 题 × 10 臂 × 1 次（题目只取自调优折）。

Run `20261126-kimi-w1-screen`, 2026-11-26 (UTC). Back to the [experiment library](../README.md).

## Setup

| Item | Value |
|---|---|
| Model / effort | `kimi-k3.1-pro`, `xhigh` |
| Harness | Claude Code 2.1.323; one fresh session per task × arm × repetition; arms interleaved task by task |
| Tasks | SWE-bench Verified, task set `kimi-screen-28` (28 tasks); task IDs are in the data file |
| Repetitions | 1 |
| Limits | 80 turns and 2,400 s per attempt; up to 3 attempts on infrastructure errors only |
| Tools | WebSearch and WebFetch disabled; sandbox without internet access |
| Environment | default ToolSearch; `CLAUDE_CODE_AUTO_COMPACT_WINDOW=1000000`, `CLAUDE_CODE_MAX_OUTPUT_TOKENS=64000` (aligns the output cap for a non-Claude model); subagents use the tested model |
| Scoring | official SWE-bench evaluation of the final patch |
| Cost | fixed price from the per-request usage ledger, all attempts, cache warm-up normalised; kimi-k3.1-pro: uncached 13, cache read 1.3, cache write 13, output 68 CNY per 1M tokens. Not an invoice. |
| Cells | 280 / 280 valid, usage complete |

## Arms

| Arm | Files | Content |
|---|---|---|
| `000` | — | native Claude Code, no plugin |
| `K_synth_m1` | [`variants/K_synth_m1`](../variants/K_synth_m1/) | `K_synth` + the M1 SessionStart hook. |
| `K_verify` | [`variants/K_verify`](../variants/K_verify/) | Verify with targeted existing tests (never the full suite), reuse one `/tmp/repro.py`, stop once verified. |
| `F2bOnly` | [`variants/F2bOnly`](../variants/F2bOnly/) | Heading + F2b only: "Once the change is made and the relevant tests or reproduction pass, finish." Best arm on deepseek; held-out cost confirmed, quality not established. |
| `111` | [`plugin/`](../../plugin/) | Cost preamble + batch read-only steps (F1) + no re-reads and finish once verified (F2) + batch edits (F3). This is `plugin/`. |
| `K_synth` | [`variants/K_synth`](../variants/K_synth/) | Distilled `K_explore` + `K_batch` + `K_verify` (4 rules, no hook). |
| `K_batch` | [`variants/K_batch`](../variants/K_batch/) | Parallel independent reads, line-range slices, batched edits, verify once and finish. |
| `styleEmpty` | [`variants/styleEmpty`](../variants/styleEmpty/) | Control: an output style that contains only the heading line. Measures the effect of delivering any output style. |
| `K_explore` | [`variants/K_explore`](../variants/K_explore/) | Targeted search and sliced reads, no git-history archaeology, check sibling code paths before editing. |
| `H_m1` | [`variants/H_m1`](../variants/H_m1/) | Only the M1 SessionStart hook (prints Python version, top-level entries and the targeted test command; about 45 tokens), no output style. |

## Results against native (`000`)

Score = cost-per-resolved-task saving (see the [library README](../README.md#composite-score)). Requests and output per request are descriptive, computed from the data file over the paired tasks.

| Arm | Score | Paired tasks | Cost vs. native (95% CI) | Resolved, native → arm | Δ pp | Main-thread requests | Output per request |
|---|---:|---:|---|---|---:|---:|---:|
| `K_synth_m1` | +30.1 | 28 | 0.734 (0.565–0.959) | 20/28 → 21/28 | +3.6 | 0.99× | 0.73× |
| `K_verify` | +25.1 | 28 | 0.824 (0.673–1.023) | 20/28 → 22/28 | +7.1 | 1.14× | 0.71× |
| `F2bOnly` | +21.0 | 28 | 0.750 (0.605–0.934) | 20/28 → 19/28 | −3.6 | 0.95× | 0.77× |
| `111` | +20.6 | 28 | 0.754 (0.616–0.912) | 20/28 → 19/28 | −3.6 | 0.83× | 1.02× |
| `K_synth` | +19.1 | 28 | 0.768 (0.586–1.015) | 20/28 → 19/28 | −3.6 | 0.99× | 0.80× |
| `K_batch` | +9.2 | 28 | 0.817 (0.614–1.065) | 20/28 → 18/28 | −7.1 | 0.96× | 0.93× |
| `styleEmpty` | +5.9 | 28 | 0.847 (0.659–1.039) | 20/28 → 18/28 | −7.1 | 1.02× | 0.91× |
| `K_explore` | −2.8 | 28 | 0.874 (0.667–1.116) | 20/28 → 17/28 | −10.7 | 1.10× | 0.83× |
| `H_m1` | −13.9 | 28 | 1.025 (0.785–1.299) | 20/28 → 18/28 | −7.1 | 1.16× | 0.93× |

## Outcome

- Three arms had upper bounds below 1: `K_synth_m1` (0.734, 21/28 vs 20/28), `F2bOnly` (0.750) and `111` (0.754).
- `K_synth_m1` removed git-history archaeology (69 → 0 commands) and cut inline scripts (78 → 18), but its `/tmp/repro.py` hint made simple tasks create many temporary scripts.
- Next: a 3×2 factorial (W2) crossing three style families with the M1 hook. The Tango interval field of this run's analysis is empty because of a function-name bug; it was fixed for W2 and this run's file was not rewritten.

## Data

[`../data/kimi-w1.csv`](../data/kimi-w1.csv): one row per task × arm × repetition (validity, resolution, end state, requests, output tokens, final-attempt token breakdown, fixed-price cost). Session logs, request ledgers and server details are not published.
