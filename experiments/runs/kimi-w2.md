# Kimi W2 — kimi-k3.1-pro (xhigh), 3×2 factorial

Kimi 3×2 因子融合：40 题 × 9 臂 × 1 次。

Run `20261126-kimi-w2-factorial`, 2026-11-27 (UTC). Back to the [experiment library](../README.md).

## Setup

| Item | Value |
|---|---|
| Model / effort | `kimi-k3.1-pro`, `xhigh` |
| Harness | Claude Code 2.1.323; one fresh session per task × arm × repetition; arms interleaved task by task |
| Tasks | SWE-bench Verified, task set `kimi-factorial-40` (40 tasks); task IDs are in the data file |
| Repetitions | 1 |
| Limits | 80 turns and 2,400 s per attempt; up to 3 attempts on infrastructure errors only |
| Tools | WebSearch and WebFetch disabled; sandbox without internet access |
| Environment | default ToolSearch; `CLAUDE_CODE_AUTO_COMPACT_WINDOW=1000000`, `CLAUDE_CODE_MAX_OUTPUT_TOKENS=64000` (aligns the output cap for a non-Claude model); subagents use the tested model |
| Scoring | official SWE-bench evaluation of the final patch |
| Cost | fixed price from the per-request usage ledger, all attempts, cache warm-up normalised; kimi-k3.1-pro: uncached 13, cache read 1.3, cache write 13, output 68 CNY per 1M tokens. Not an invoice. |
| Cells | 360 / 360 valid, usage complete; 23 cells hit a turn or time limit (`000` the most, 4) |

## Arms

| Arm | Files | Content |
|---|---|---|
| `000` | — | native Claude Code, no plugin |
| `F2b_m1` | [`variants/F2b_m1`](../variants/F2b_m1/) | `F2bOnly` + the M1 hook. |
| `K_synth_m1` | [`variants/K_synth_m1`](../variants/K_synth_m1/) | `K_synth` + the M1 SessionStart hook. |
| `111_m1` | [`variants/111_m1`](../variants/111_m1/) | `111` (0.2.0) + the M1 hook. |
| `F2bOnly` | [`variants/F2bOnly`](../variants/F2bOnly/) | Heading + F2b only: "Once the change is made and the relevant tests or reproduction pass, finish." Best arm on deepseek; held-out cost confirmed, quality not established. |
| `K_v2_m1` | [`variants/K_v2_m1`](../variants/K_v2_m1/) | `K_v2` + the M1 hook. |
| `K_v2` | [`variants/K_v2`](../variants/K_v2/) | 0.2.0's batching habits merged with the `K_synth` focus rules (no `/tmp/repro.py`). The only Kimi W2 arm inside the −5 pp quality guard. |
| `K_lean_m1` | [`variants/K_lean_m1`](../variants/K_lean_m1/) | A three-line compression of `K_v2` + the M1 hook. |
| `111` | [`plugin/`](../../plugin/) | Cost preamble + batch read-only steps (F1) + no re-reads and finish once verified (F2) + batch edits (F3). This is `plugin/`. |

## Results against native (`000`)

Score = cost-per-resolved-task saving (see the [library README](../README.md#composite-score)). Requests and output per request are descriptive, computed from the data file over the paired tasks.

| Arm | Score | Paired tasks | Cost vs. native (95% CI) | Resolved, native → arm | Δ pp | Main-thread requests | Output per request |
|---|---:|---:|---|---|---:|---:|---:|
| `F2b_m1` | +48.4 | 40 | 0.473 (0.325–0.639) | 36/40 → 33/40 | −7.5 | 0.71× | 0.61× |
| `K_synth_m1` | +24.2 | 40 | 0.695 (0.423–1.012) | 36/40 → 33/40 | −7.5 | 0.75× | 0.95× |
| `111_m1` | +23.0 | 40 | 0.706 (0.455–1.062) | 36/40 → 33/40 | −7.5 | 0.72× | 1.12× |
| `F2bOnly` | +22.2 | 40 | 0.691 (0.444–1.014) | 36/40 → 32/40 | −10.0 | 0.80× | 0.94× |
| `K_v2_m1` | +15.7 | 40 | 0.773 (0.538–1.014) | 36/40 → 33/40 | −7.5 | 0.77× | 1.11× |
| `K_v2` | +8.7 | 40 | 0.863 (0.545–1.179) | 36/40 → 34/40 | −5.0 | 0.78× | 1.20× |
| `K_lean_m1` | +5.6 | 40 | 0.865 (0.491–1.335) | 36/40 → 33/40 | −7.5 | 0.75× | 1.28× |
| `111` | −2.2 | 40 | 0.908 (0.544–1.345) | 36/40 → 32/40 | −10.0 | 0.78× | 1.18× |

- [e] Seven long tasks that hit turn or time limits dominate the totals, and per-request uncached input rose about 17× between this run and the previous Kimi run for every arm, native included. Arms in this run could not be separated from each other.

## Other comparisons

| Comparison | Cost ratio (95% CI) | Resolved |
|---|---|---|
| M1 hook, three pairs pooled (`F2b_m1`/`F2bOnly`, `111_m1`/`111`, `K_v2_m1`/`K_v2`) | 0.79 (0.66–0.96) | +1, +1, −1 tasks |

## Outcome

- Pre-registered quality guard (Δ ≥ −5.0 pp and p_worse ≥ 0.05): only `K_v2` passes, exactly on the line (34/40 vs 36/40). The other arms lose 7.5–10 pp. No arm is non-inferior at 5 pp under the Tango test.
- Every arm is cheaper than native (10%-trimmed ratios 0.57–0.72), but the arms cannot be separated from each other: re-running the same arm on the same tasks varied about as much as the arms differed.
- The gap is concentrated in django-13195 (native resolved, all 8 arms failed) and django-14792 (native resolved, 7 of 8 failed). On both, native's change matches the official fix line by line.
- Upstream drift: between W1 and W2, per-request uncached input rose from about 130 to about 2,200 tokens for every arm including native, with identical request settings. Only within-run comparisons are reported.
- M1 reduced the number of tasks hitting test-runner errors in all three pairs (16→5, 19→9, 20→7); its cost effect was not robust (pooled 0.79, but 0.79 / 0.89 / 1.02 after dropping the most favourable task).
- Wave 3 was not started and the 24-task audit split stays sealed.

## Data

[`../data/kimi-w2.csv`](../data/kimi-w2.csv): one row per task × arm × repetition (validity, resolution, end state, requests, output tokens, final-attempt token breakdown, fixed-price cost). Session logs, request ledgers and server details are not published.
