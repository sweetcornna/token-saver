# Experiment library

Paired SWE-bench Verified results for token-saver variants and outside methods. The marketplace installs the released style in [`plugin/`](../plugin/) (0.2.0, called `111` below).

本目录收录所有做过配对评测的 token-saver 消融版本和外部方法，附各自的成绩，按综合成绩从高到低排列。中文说明见文末。

- 33 variants of our own (5 more were built but never run) and 7 outside methods; 72 variant × run results from 24 runs between 2026-11-08 and 2026-11-27.
- Tables: [leaderboard by variant](#leaderboard-by-variant), [all results](#all-results-variant--run), [runs](#runs). Machine-readable: [`leaderboard.csv`](leaderboard.csv).
- Variant files and results are in [`variants/`](variants/). Run settings, arms and outcomes are in [`runs/`](runs/). Seven runs have [per-task CSVs](data/).

## Composite score

For a variant in one run, against native Claude Code in the same run:

```
score = 100 × (1 − (C_variant / C_native) × (R_native / R_variant))
```

`C` is fixed-price cost summed over the tasks (and repetitions) that both arms completed, and `R` is the number resolved over the same set. The score is the saving in **cost per resolved task**: +30 means each resolved task cost 30% less than with native Claude Code, 0 means no change, and a negative score means each resolved task cost more. A variant that is cheaper but resolves fewer tasks gains less, in proportion to the tasks it lost.

In the [leaderboard by variant](#leaderboard-by-variant), a variant's score is the mean of its per-run scores.

How to read the ranking:

- **It is descriptive.** Each score is relative to native Claude Code in its own run, but rows from different models, task sets and harness versions are still not directly comparable.
- **It ignores certainty.** A 40-task single run counts as much as a 98-task × 4 held-out run, and single-run scores are not shrunk toward zero, so variants tested once sit near the top partly by chance. The variants with the most evidence are `v0` (10 runs), `F2bOnly` (5) and `111` (4). On Kimi, re-running the same arm on the same tasks changed its cost about as much as switching arms did.
- **No variant has established quality non-inferiority on held-out tasks.** The best-supported result is `F2bOnly` on deepseek: cost confirmed on 98 unused tasks × 4 (0.696, 0.616–0.776), but resolution fell 2.6 points and non-inferiority at 3 or 5 points was not established.
- The released plugin was not chosen by this ranking and is not replaced by it.
- *Status*: **released** / **previous release**; **candidate**: best supported for one model, not confirmed for quality; **control**: an arm that isolates part of a variant; **screen only**: tested once in a screening run and not advanced; **superseded**: a later split did better; **not advanced**: no measurable effect beyond its control, so not carried into the next run; **rejected** / **inconclusive** / **not confirmed**: see the variant's page; **not run**: built and pre-registered, no scores; **external**: someone else's tool, retested here and not redistributed.

## Leaderboard by variant

| # | Score | Variant | Type | Status | Runs | Range | Mean Δ resolved (pp) | Models | What it is |
|---:|---:|---|---|---|---:|---|---:|---|---|
| 1 | **+48.4** | [`F2b_m1`](variants/F2b_m1/) | plugin | screen only | 1 | — | −7.5 | kimi-k3.1-pro | `F2bOnly` + the M1 hook. |
| 2 | **+42.0** | [`v1a-brief`](variants/v1a-brief/) | plugin | rejected | 1 | — | −1.5 | deepseek-v4.1-flash | "Brief reasoning" output style: think just enough to choose the next step. Lost 8.3 pp on a second task set (that run was later voided for a gateway cache fault) and failed the quality condition in a later screen on another harness. |
| 3 | **+40.6** | [`v0-notes`](variants/v0-notes/) | plugin | inconclusive | 1 | — | −3.3 | deepseek-v4.1-flash | v0 + a SessionStart hook that injects notes learned from earlier tasks in the same repository. Versus v0: 0.917 (0.752–1.115); indistinguishable from mismatched notes. |
| 4 | **+38.6** | [`v2-stop-gate`](variants/v2-stop-gate/) | plugin | rejected | 1 | — | +4.2 | deepseek-v4.1-flash | v0 + a Stop hook closing gate. The gate changed code after firing in only 2 of 120 sessions, so its gain is run-to-run noise. |
| 5 | **+37.5** | [`111D`](variants/111D/) | plugin | not advanced | 1 | — | +1.2 | claude-haiku-5-5 | `111` + delegation rule D. No arm dispatched a subagent in its run; against `111` it cost 1.075 (0.973–1.164). |
| 6 | **+36.4** | [`000D`](variants/000D/) | plugin | not advanced | 1 | — | +4.9 | claude-haiku-5-5 | Cost preamble + delegation rule D ("work in the main session; delegate only independent investigations"). No arm dispatched a subagent in its run, so D had nothing to act on. |
| 7 | **+35.3** | [`F2bSuite`](variants/F2bSuite/) | plugin | rejected | 1 | — | −3.0 | deepseek-v4.1-flash | Heading + a stricter closing rule: finish once every case in the issue is handled and both the reproduction and the existing tests for the changed code pass. |
| 8 | **+34.4** | [`F2bTail`](variants/F2bTail/) | plugin | rejected | 1 | — | +0.4 | deepseek-v4.1-flash | Heading + only the second half of F2b ("don't repeat checks that already passed"), without "finish". |
| 9 | **+34.2** | [`v1b-budget`](variants/v1b-budget/) | plugin | not confirmed | 1 | — | +2.1 | deepseek-v4.1-flash | PostToolUse hook that adds a budget reminder at the 50th and 90th tool call. No valid follow-up confirmation. |
| 10 | **+30.7** | [`v0`](variants/v0/) | plugin | previous release 0.1.0 | 10 | +17.7 … +40.3 | −0.3 | gpt-6-luna, deepseek-v4.1-flash | Cost preamble + F1 + F2 (no F3). The first release (0.1.0); same text as the `110` atom combination. |
| 11 | **+30.3** | [`F2only`](variants/F2only/) | plugin | superseded by F2bOnly | 1 | — | −2.5 | deepseek-v4.1-flash | Heading + F2 (no re-reads; finish once verified), no cost sentence. |
| 12 | **+29.9** | [`F2bOnly`](variants/F2bOnly/) | plugin | candidate (deepseek) | 5 | +21.0 … +42.7 | −3.3 | deepseek-v4.1-flash, kimi-k3.1-pro | Heading + F2b only: "Once the change is made and the relevant tests or reproduction pass, finish." Best arm on deepseek; held-out cost confirmed, quality not established. |
| 13 | **+28.6** | [`001`](variants/001/) | plugin | not advanced | 1 | — | +2.4 | deepseek-v4.1-flash | Cost preamble + F3 batch edits only. |
| 14 | **+27.4** | [`shell`](variants/shell/) | plugin | control | 3 | +19.7 … +36.0 | −0.4 | claude-haiku-5-5, deepseek-v4.1-flash | Control: heading plus the one cost sentence ("Every tool call re-sends the whole conversation… Work the same way you normally would."), no habits. |
| 15 | **+27.2** | [`K_synth_m1`](variants/K_synth_m1/) | plugin | screen only | 2 | +24.2 … +30.1 | −2.0 | kimi-k3.1-pro | `K_synth` + the M1 SessionStart hook. |
| 16 | **+25.1** | [`K_verify`](variants/K_verify/) | plugin | screen only | 1 | — | +7.1 | kimi-k3.1-pro | Verify with targeted existing tests (never the full suite), reuse one `/tmp/repro.py`, stop once verified. |
| 17 | **+25.0** | [`v1`](variants/v1/) | plugin | rejected | 1 | — | −1.0 | deepseek-v4.1-flash | v0 with the closing rule replaced by "cover the related cases, one targeted test, then finish". |
| 18 | **+24.0** | [`F2aOnly`](variants/F2aOnly/) | plugin | not advanced | 1 | — | +0.6 | deepseek-v4.1-flash | Heading + F2a only: don't re-read unchanged files or re-run unchanged commands. |
| 19 | **+23.0** | [`111_m1`](variants/111_m1/) | plugin | screen only | 1 | — | −7.5 | kimi-k3.1-pro | `111` (0.2.0) + the M1 hook. |
| 20 | **+20.5** | [`111`](../plugin/) | plugin | released 0.2.0 | 4 | −2.2 … +42.8 | −3.7 | claude-haiku-5-5, deepseek-v4.1-flash, kimi-k3.1-pro | Cost preamble + batch read-only steps (F1) + no re-reads and finish once verified (F2) + batch edits (F3). This is `plugin/`. |
| 21 | **+19.1** | [`K_synth`](variants/K_synth/) | plugin | screen only | 1 | — | −3.6 | kimi-k3.1-pro | Distilled `K_explore` + `K_batch` + `K_verify` (4 rules, no hook). |
| 22 | **+18.3** | [`100`](variants/100/) | plugin | not advanced | 2 | +13.5 … +23.0 | −2.9 | deepseek-v4.1-flash | Cost preamble + F1 batch read-only steps only. Same text as the 2026-11-11 `abl-batchonly` arm. |
| 23 | **+17.8** | [`styleEmpty`](variants/styleEmpty/) | plugin | control | 4 | +5.9 … +28.6 | −2.6 | deepseek-v4.1-flash, kimi-k3.1-pro | Control: an output style that contains only the heading line. Measures the effect of delivering any output style. |
| 24 | **+16.2** | [`010`](variants/010/) | plugin | superseded by F2bOnly | 3 | −11.3 … +32.7 | −1.3 | deepseek-v4.1-flash | Cost preamble + F2 only (no re-reads; finish once verified). Same text as the 2026-11-11 `abl-nobatch` arm. |
| 25 | **+15.7** | [`K_v2_m1`](variants/K_v2_m1/) | plugin | screen only | 1 | — | −7.5 | kimi-k3.1-pro | `K_v2` + the M1 hook. |
| 26 | **+10.4** | [`v4-subagents`](variants/v4-subagents/) | plugin | rejected | 1 | — | +5.8 | deepseek-v4.1-flash | v0 + plugin subagents (scout, runner, tracer) at lower reasoning effort for search/read/run steps. 41.1% costlier than v0. |
| 27 | **+9.2** | [`K_batch`](variants/K_batch/) | plugin | screen only | 1 | — | −7.1 | kimi-k3.1-pro | Parallel independent reads, line-range slices, batched edits, verify once and finish. |
| 28 | **+8.7** | [`K_v2`](variants/K_v2/) | plugin | screen only | 1 | — | −5.0 | kimi-k3.1-pro | 0.2.0's batching habits merged with the `K_synth` focus rules (no `/tmp/repro.py`). The only Kimi W2 arm inside the −5 pp quality guard. |
| 29 | **+7.3** | [`RTK`](runs/external-retests.md) | external | external | 1 | — | +3.3 | deepseek-v4.1-flash | RTK v1.2.0 command-output compression hook, installed unchanged. |
| 30 | **+5.6** | [`K_lean_m1`](variants/K_lean_m1/) | plugin | screen only | 1 | — | −7.5 | kimi-k3.1-pro | A three-line compression of `K_v2` + the M1 hook. |
| 31 | **+0.9** | [`DevSkills`](runs/external-retests.md) | external | external | 1 | — | +3.3 | deepseek-v4.1-flash | DevSkills (arXiv 2609.30725) skill text appended to the system prompt. |
| 32 | **−2.8** | [`K_explore`](variants/K_explore/) | plugin | screen only | 1 | — | −10.7 | kimi-k3.1-pro | Targeted search and sliced reads, no git-history archaeology, check sibling code paths before editing. |
| 33 | **−3.5** | [`appendCost`](variants/appendCost/) | config | not advanced | 1 | — | −1.2 | deepseek-v4.1-flash | Not a plugin: the `shell` cost sentence passed with `--append-system-prompt` instead of an output style. |
| 34 | **−6.4** | [`jCodeMunch`](runs/external-retests.md) | external | external | 2 | −22.0 … +9.3 | +4.3 | claude-opus-5-5, deepseek-v4.1-flash | jCodeMunch code-retrieval MCP server. |
| 35 | **−8.9** | [`noAgent`](variants/noAgent/) | config | not advanced | 1 | — | +1.2 | claude-haiku-5-5 | Not a plugin: native Claude Code with `--disallowedTools Agent Task` (no subagents). |
| 36 | **−13.9** | [`H_m1`](variants/H_m1/) | plugin | screen only | 1 | — | −7.1 | kimi-k3.1-pro | Only the M1 SessionStart hook (prints Python version, top-level entries and the targeted test command; about 45 tokens), no output style. |
| 37 | **−24.1** | [`Polaris-topo`](runs/external-retests.md) | external | external | 2 | −52.0 … +3.8 | −4.3 | kimi-k3.1-pro, deepseek-v4.1-flash | Polaris Code v0.4.5, official `--topology-task` gated SWE-bench mode. |
| 38 | **−52.3** | [`TokenEconomizer`](runs/external-retests.md) | external | external | 3 | −87.6 … −22.9 | −3.3 | deepseek-v4.1-flash, claude-opus-5-5 | Microsoft TokenEconomizer (arXiv 2610.22732), original plugin with micro-skills on. |
| 39 | **−128.3** | [`ReasoningBank`](runs/external-retests.md) | external | external | 2 | −183.5 … −73.2 | −3.3 | deepseek-v4.1-flash, claude-opus-5-5 | Google ReasoningBank (arXiv 2509.25140), upstream SWE memory module ported to Claude Code. |
| 40 | **−235.8** | [`Polaris-cli`](runs/external-retests.md) | external | external | 3 | −445.7 … −12.6 | −1.9 | kimi-k3.1-pro, deepseek-v4.1-flash, claude-opus-5-5 | Polaris Code v0.4.5 (RadiantAILabs/polaris_code), generic `-p` mode, as a replacement agent. |

Variants that were built but never run (no score): [`v2-env`](variants/v2-env/), [`v2-habits`](variants/v2-habits/), [`v3a`](variants/v3a/), [`v3b-codefind`](variants/v3b-codefind/), [`codex-v0`](variants/codex-v0/).

## All results (variant × run)

Sorted by score. *Evidence*: **held-out** = tasks never used during development; **dev ×k** = development tasks with k repetitions per arm; **screen ×1** = one repetition.

| # | Score | Variant | Run | Model (effort) | Tasks × reps | Cost vs. native (95% CI) | Resolved, native → variant | Δ pp | Evidence | Notes |
|---:|---:|---|---|---|---|---|---|---:|---|---|
| 1 | **+48.4** | [`F2b_m1`](variants/F2b_m1/) | [kimi-w2](runs/kimi-w2.md) | kimi-k3.1-pro (xhigh) | 40 × 1 | 0.473 (0.325–0.639) | 36/40 → 33/40 | −7.5 | screen ×1 | [e] 10%-trimmed 0.57; ~40% of the gap from one task |
| 2 | **+42.8** | [`111`](../plugin/) | [s1-haiku](runs/s1-haiku.md) | claude-haiku-5-5 (max) | 82 × 1 | 0.590 (0.537–0.652) | 64/81 → 66/81 | +2.5 | screen ×1 | [c] released 0.2.0 |
| 3 | **+42.7** | [`F2bOnly`](variants/F2bOnly/) | [s1d-ds](runs/s1d-ds.md) | deepseek-v4.1-flash (max) | 82 × 3 | 0.585 (0.521–0.653) | 193/240 → 197/240 | +1.7 | dev ×3 |  |
| 4 | **+42.0** | [`v1a-brief`](variants/v1a-brief/) | [ccb5](runs/2026-11-08-to-12.md#ccb5) | deepseek-v4.1-flash (max) | 97 × 2 | 0.568 (0.397–0.807) | 75.3% → 73.7% | −1.5 | dev ×2 | [h] |
| 5 | **+40.6** | [`v0-notes`](variants/v0-notes/) | [seq1](runs/2026-11-08-to-12.md#seq1) | deepseek-v4.1-flash (max) | 61 × 2 | 0.571 | 84.4% → 81.1% | −3.3 | dev ×2 | vs v0: 0.917 (0.752–1.115) |
| 6 | **+40.3** | [`v0`](variants/v0/) | [lunamax1](runs/2026-11-08-to-12.md#lunamax1) | gpt-6-luna (max) | 60 × 2 | 0.624 (0.419–0.971) | 72.5% → 75.8% | +3.3 | dev ×2 | [d] |
| 7 | **+38.6** | [`v2-stop-gate`](variants/v2-stop-gate/) | [dt1](runs/2026-11-08-to-12.md#dt1) | deepseek-v4.1-flash (xhigh) | 60 × 2 | 0.646 (0.521–0.786) | 80.0% → 84.2% | +4.2 | dev ×2 | gate changed code after firing in 2/120 sessions |
| 8 | **+37.5** | [`111D`](variants/111D/) | [s1-haiku](runs/s1-haiku.md) | claude-haiku-5-5 (max) | 82 × 1 | 0.634 (0.565–0.706) | 65/82 → 66/82 | +1.2 | screen ×1 | [a] |
| 9 | **+37.2** | [`v0`](variants/v0/) | [ccb4](runs/2026-11-08-to-12.md#ccb4) | deepseek-v4.1-flash (max) | 97 × 2 | 0.640 (0.517–0.793) | 75.3% → 76.8% | +1.5 | dev ×2 | [h] |
| 10 | **+37.2** | [`v0`](variants/v0/) | [seq1](runs/2026-11-08-to-12.md#seq1) | deepseek-v4.1-flash (max) | 61 × 2 | 0.622 (0.532–0.719) | 84.4% → 83.6% | −0.8 | dev ×2 |  |
| 11 | **+36.4** | [`000D`](variants/000D/) | [s1-haiku](runs/s1-haiku.md) | claude-haiku-5-5 (max) | 82 × 1 | 0.675 (0.603–0.757) | 65/82 → 69/82 | +4.9 | screen ×1 | [a] |
| 12 | **+36.0** | [`shell`](variants/shell/) | [s1-haiku](runs/s1-haiku.md) | claude-haiku-5-5 (max) | 82 × 1 | 0.660 (0.602–0.724) | 65/82 → 67/82 | +2.4 | screen ×1 |  |
| 13 | **+35.4** | [`F2bOnly`](variants/F2bOnly/) | [s1c-ds](runs/s1c-ds.md) | deepseek-v4.1-flash (max) | 82 × 2 | 0.631 (0.559–0.708) | 127/160 → 124/160 | −1.9 | dev ×2 |  |
| 14 | **+35.3** | [`F2bSuite`](variants/F2bSuite/) | [s1d-ds](runs/s1d-ds.md) | deepseek-v4.1-flash (max) | 82 × 3 | 0.623 (0.535–0.712) | 190/237 → 183/237 | −3.0 | dev ×3 |  |
| 15 | **+34.5** | [`v0`](variants/v0/) | [dt3](runs/2026-11-08-to-12.md#dt3) | deepseek-v4.1-flash (xhigh) | 60 × 2 | 0.683 (0.552–0.869) | 78.3% → 81.7% | +3.3 | dev ×2 |  |
| 16 | **+34.4** | [`F2bTail`](variants/F2bTail/) | [s1d-ds](runs/s1d-ds.md) | deepseek-v4.1-flash (max) | 82 × 3 | 0.659 (0.601–0.715) | 193/240 → 194/240 | +0.4 | dev ×3 |  |
| 17 | **+34.2** | [`v1b-budget`](variants/v1b-budget/) | [ccb5](runs/2026-11-08-to-12.md#ccb5) | deepseek-v4.1-flash (max) | 97 × 2 | 0.675 (0.566–0.809) | 75.3% → 77.3% | +2.1 | dev ×2 | [h] |
| 18 | **+32.7** | [`010`](variants/010/) | [s1c-ds](runs/s1c-ds.md) | deepseek-v4.1-flash (max) | 82 × 2 | 0.679 (0.601–0.761) | 127/162 → 128/162 | +0.6 | dev ×2 |  |
| 19 | **+32.3** | [`v0`](variants/v0/) | [dt1](runs/2026-11-08-to-12.md#dt1) | deepseek-v4.1-flash (xhigh) | 60 × 2 | 0.677 (0.546–0.805) | 80.0% → 80.0% | +0.0 | dev ×2 |  |
| 20 | **+32.1** | [`v0`](variants/v0/) | [ccb8](runs/2026-11-08-to-12.md#ccb8) | deepseek-v4.1-flash (max) | 97 × 2 | 0.669 (0.562–0.769) | 75.8% → 74.7% | −1.0 | dev ×2 |  |
| 21 | **+30.3** | [`F2only`](variants/F2only/) | [s1c-ds](runs/s1c-ds.md) | deepseek-v4.1-flash (max) | 82 × 2 | 0.675 (0.591–0.760) | 126/160 → 122/160 | −2.5 | dev ×2 |  |
| 22 | **+30.1** | [`K_synth_m1`](variants/K_synth_m1/) | [kimi-w1](runs/kimi-w1.md) | kimi-k3.1-pro (xhigh) | 28 × 1 | 0.734 (0.565–0.959) | 20/28 → 21/28 | +3.6 | screen ×1 |  |
| 23 | **+28.6** | [`styleEmpty`](variants/styleEmpty/) | [s1d-ds](runs/s1d-ds.md) | deepseek-v4.1-flash (max) | 82 × 3 | 0.703 (0.637–0.785) | 191/237 → 188/237 | −1.3 | dev ×3 |  |
| 24 | **+28.6** | [`001`](variants/001/) | [s1b-ds](runs/s1b-ds.md) | deepseek-v4.1-flash (max) | 82 × 1 | 0.736 (0.635–0.844) | 65/82 → 67/82 | +2.4 | screen ×1 | [b] |
| 25 | **+28.1** | [`F2bOnly`](variants/F2bOnly/) | [c1-ds](runs/c1-ds.md) | deepseek-v4.1-flash (max) | 98 × 4 | 0.696 (0.616–0.776) | 313/388 → 303/388 | −2.6 | held-out ×4 | held-out confirmation |
| 26 | **+27.3** | [`v0`](variants/v0/) | [cf1](runs/2026-11-08-to-12.md#cf1) | deepseek-v4.1-flash (xhigh) | 174 × 2 | 0.727 (0.647–0.823) | 75.0% → 75.0% | +0.0 | held-out ×2 | held-out confirmation; NI lower bound −3.16pp |
| 27 | **+27.1** | [`010`](variants/010/) | [s1b-ds](runs/s1b-ds.md) | deepseek-v4.1-flash (max) | 82 × 1 | 0.718 (0.619–0.858) | 65/82 → 64/82 | −1.2 | screen ×1 | [b] |
| 28 | **+26.5** | [`shell`](variants/shell/) | [s1c-ds](runs/s1c-ds.md) | deepseek-v4.1-flash (max) | 82 × 2 | 0.735 (0.648–0.825) | 125/160 → 125/160 | +0.0 | dev ×2 |  |
| 29 | **+25.1** | [`K_verify`](variants/K_verify/) | [kimi-w1](runs/kimi-w1.md) | kimi-k3.1-pro (xhigh) | 28 × 1 | 0.824 (0.673–1.023) | 20/28 → 22/28 | +7.1 | screen ×1 |  |
| 30 | **+25.0** | [`v1`](variants/v1/) | [ccb8](runs/2026-11-08-to-12.md#ccb8) | deepseek-v4.1-flash (max) | 97 × 2 | 0.739 | 75.8% → 74.7% | −1.0 | dev ×2 | +10.5% vs v0 |
| 31 | **+24.9** | [`v0`](variants/v0/) | [ccb7d](runs/2026-11-08-to-12.md#ccb7d) | deepseek-v4.1-flash (max) | 60 × 2 | 0.729 | 84.2% → 81.7% | −2.5 | dev ×2 |  |
| 32 | **+24.2** | [`K_synth_m1`](variants/K_synth_m1/) | [kimi-w2](runs/kimi-w2.md) | kimi-k3.1-pro (xhigh) | 40 × 1 | 0.695 (0.423–1.012) | 36/40 → 33/40 | −7.5 | screen ×1 | [e] 10%-trimmed 0.61 |
| 33 | **+24.0** | [`F2aOnly`](variants/F2aOnly/) | [s1c-ds](runs/s1c-ds.md) | deepseek-v4.1-flash (max) | 82 × 2 | 0.766 (0.687–0.852) | 125/160 → 126/160 | +0.6 | dev ×2 |  |
| 34 | **+23.3** | [`v0`](variants/v0/) | [sc1-medium](runs/2026-11-08-to-12.md#sc1-medium) | deepseek-v4.1-flash (medium) | 30 × 1 | 0.732 (0.597–0.895) | 22/30 → 21/30 | −3.3 | screen ×1 | vs medium-effort native |
| 35 | **+23.0** | [`111_m1`](variants/111_m1/) | [kimi-w2](runs/kimi-w2.md) | kimi-k3.1-pro (xhigh) | 40 × 1 | 0.706 (0.455–1.062) | 36/40 → 33/40 | −7.5 | screen ×1 | [e] 10%-trimmed 0.62 |
| 36 | **+23.0** | [`100`](variants/100/) | [sc1](runs/2026-11-08-to-12.md#sc1) | deepseek-v4.1-flash (xhigh) | 30 × 1 | 0.735 (0.594–0.937) | 22/30 → 21/30 | −3.3 | screen ×1 | as abl-batchonly |
| 37 | **+22.2** | [`F2bOnly`](variants/F2bOnly/) | [kimi-w2](runs/kimi-w2.md) | kimi-k3.1-pro (xhigh) | 40 × 1 | 0.691 (0.444–1.014) | 36/40 → 32/40 | −10.0 | screen ×1 | [e] 10%-trimmed 0.66 |
| 38 | **+22.2** | [`styleEmpty`](variants/styleEmpty/) | [s1c-ds](runs/s1c-ds.md) | deepseek-v4.1-flash (max) | 82 × 2 | 0.760 (0.677–0.844) | 127/162 → 124/162 | −1.9 | dev ×2 |  |
| 39 | **+21.0** | [`F2bOnly`](variants/F2bOnly/) | [kimi-w1](runs/kimi-w1.md) | kimi-k3.1-pro (xhigh) | 28 × 1 | 0.750 (0.605–0.934) | 20/28 → 19/28 | −3.6 | screen ×1 |  |
| 40 | **+20.6** | [`111`](../plugin/) | [s1b-ds](runs/s1b-ds.md) | deepseek-v4.1-flash (max) | 82 × 1 | 0.757 (0.653–0.894) | 65/82 → 62/82 | −3.7 | screen ×1 | [b] released 0.2.0 |
| 41 | **+20.6** | [`111`](../plugin/) | [kimi-w1](runs/kimi-w1.md) | kimi-k3.1-pro (xhigh) | 28 × 1 | 0.754 (0.616–0.912) | 20/28 → 19/28 | −3.6 | screen ×1 | released 0.2.0 |
| 42 | **+19.7** | [`shell`](variants/shell/) | [s1b-ds](runs/s1b-ds.md) | deepseek-v4.1-flash (max) | 82 × 1 | 0.766 (0.657–0.906) | 65/82 → 62/82 | −3.7 | screen ×1 | [b] |
| 43 | **+19.1** | [`K_synth`](variants/K_synth/) | [kimi-w1](runs/kimi-w1.md) | kimi-k3.1-pro (xhigh) | 28 × 1 | 0.768 (0.586–1.015) | 20/28 → 19/28 | −3.6 | screen ×1 |  |
| 44 | **+17.7** | [`v0`](variants/v0/) | [sc1](runs/2026-11-08-to-12.md#sc1) | deepseek-v4.1-flash (xhigh) | 30 × 1 | 0.786 (0.630–0.968) | 22/30 → 21/30 | −3.3 | screen ×1 |  |
| 45 | **+15.7** | [`K_v2_m1`](variants/K_v2_m1/) | [kimi-w2](runs/kimi-w2.md) | kimi-k3.1-pro (xhigh) | 40 × 1 | 0.773 (0.538–1.014) | 36/40 → 33/40 | −7.5 | screen ×1 | [e] 10%-trimmed 0.63 |
| 46 | **+14.5** | [`styleEmpty`](variants/styleEmpty/) | [s1b-ds](runs/s1b-ds.md) | deepseek-v4.1-flash (max) | 82 × 1 | 0.855 (0.737–0.979) | 65/82 → 65/82 | +0.0 | screen ×1 | [b] |
| 47 | **+13.5** | [`100`](variants/100/) | [s1b-ds](runs/s1b-ds.md) | deepseek-v4.1-flash (max) | 82 × 1 | 0.838 (0.722–0.994) | 65/82 → 63/82 | −2.4 | screen ×1 | [b] |
| 48 | **+10.4** | [`v4-subagents`](variants/v4-subagents/) | [dt3](runs/2026-11-08-to-12.md#dt3) | deepseek-v4.1-flash (xhigh) | 60 × 2 | 0.964 (0.637–1.542) | 78.3% → 84.2% | +5.8 | dev ×2 | +41.1% vs v0 |
| 49 | **+9.3** | [`jCodeMunch`](runs/external-retests.md) | [jcm3](runs/external-retests.md#jcm3) | claude-opus-5-5 (max) | 50 × 1 | 1.050 (0.853–1.286) | 38/50 → 44/50 | +12.0 | screen ×1 |  |
| 50 | **+9.2** | [`K_batch`](variants/K_batch/) | [kimi-w1](runs/kimi-w1.md) | kimi-k3.1-pro (xhigh) | 28 × 1 | 0.817 (0.614–1.065) | 20/28 → 18/28 | −7.1 | screen ×1 |  |
| 51 | **+8.7** | [`K_v2`](variants/K_v2/) | [kimi-w2](runs/kimi-w2.md) | kimi-k3.1-pro (xhigh) | 40 × 1 | 0.863 (0.545–1.179) | 36/40 → 34/40 | −5.0 | screen ×1 | [e] 10%-trimmed 0.65 |
| 52 | **+7.3** | [`RTK`](runs/external-retests.md) | [sc1](runs/2026-11-08-to-12.md#sc1) | deepseek-v4.1-flash (xhigh) | 30 × 1 | 0.969 (0.784–1.187) | 22/30 → 23/30 | +3.3 | screen ×1 |  |
| 53 | **+5.9** | [`styleEmpty`](variants/styleEmpty/) | [kimi-w1](runs/kimi-w1.md) | kimi-k3.1-pro (xhigh) | 28 × 1 | 0.847 (0.659–1.039) | 20/28 → 18/28 | −7.1 | screen ×1 |  |
| 54 | **+5.6** | [`K_lean_m1`](variants/K_lean_m1/) | [kimi-w2](runs/kimi-w2.md) | kimi-k3.1-pro (xhigh) | 40 × 1 | 0.865 (0.491–1.335) | 36/40 → 33/40 | −7.5 | screen ×1 | [e] 10%-trimmed 0.59 |
| 55 | **+3.8** | [`Polaris-topo`](runs/external-retests.md) | [polaris-kimi](runs/external-retests.md#polaris-kimi) | kimi-k3.1-pro (xhigh) | 82 × 1 | 0.946 (0.829–1.084) | 62/82 → 61/82 | −1.2 | screen ×1 |  |
| 56 | **+0.9** | [`DevSkills`](runs/external-retests.md) | [sc1](runs/2026-11-08-to-12.md#sc1) | deepseek-v4.1-flash (xhigh) | 30 × 1 | 1.036 (0.827–1.299) | 22/30 → 23/30 | +3.3 | screen ×1 |  |
| 57 | **−2.2** | [`111`](../plugin/) | [kimi-w2](runs/kimi-w2.md) | kimi-k3.1-pro (xhigh) | 40 × 1 | 0.908 (0.544–1.345) | 36/40 → 32/40 | −10.0 | screen ×1 | [e] 10%-trimmed 0.72; released 0.2.0 |
| 58 | **−2.8** | [`K_explore`](variants/K_explore/) | [kimi-w1](runs/kimi-w1.md) | kimi-k3.1-pro (xhigh) | 28 × 1 | 0.874 (0.667–1.116) | 20/28 → 17/28 | −10.7 | screen ×1 |  |
| 59 | **−3.5** | [`appendCost`](variants/appendCost/) | [s1b-ds](runs/s1b-ds.md) | deepseek-v4.1-flash (max) | 82 × 1 | 1.019 (0.907–1.163) | 65/82 → 64/82 | −1.2 | screen ×1 | [b] |
| 60 | **−8.9** | [`noAgent`](variants/noAgent/) | [s1-haiku](runs/s1-haiku.md) | claude-haiku-5-5 (max) | 82 × 1 | 1.106 (0.977–1.267) | 65/82 → 66/82 | +1.2 | screen ×1 |  |
| 61 | **−11.3** | [`010`](variants/010/) | [sc1](runs/2026-11-08-to-12.md#sc1) | deepseek-v4.1-flash (xhigh) | 30 × 1 | 1.062 (0.632–1.919) | 22/30 → 21/30 | −3.3 | screen ×1 | as abl-nobatch |
| 62 | **−12.6** | [`Polaris-cli`](runs/external-retests.md) | [polaris-kimi](runs/external-retests.md#polaris-kimi) | kimi-k3.1-pro (xhigh) | 82 × 1 | 1.089 (0.903–1.339) | 62/82 → 60/82 | −2.4 | screen ×1 |  |
| 63 | **−13.9** | [`H_m1`](variants/H_m1/) | [kimi-w1](runs/kimi-w1.md) | kimi-k3.1-pro (xhigh) | 28 × 1 | 1.025 (0.785–1.299) | 20/28 → 18/28 | −7.1 | screen ×1 |  |
| 64 | **−22.0** | [`jCodeMunch`](runs/external-retests.md) | [jcm2](runs/external-retests.md#jcm2) | deepseek-v4.1-flash (max) | 30 × 1 | 1.167 (0.981–1.413) | 23/30 → 22/30 | −3.3 | screen ×1 |  |
| 65 | **−22.9** | [`TokenEconomizer`](runs/external-retests.md) | [seq1](runs/2026-11-08-to-12.md#seq1) | deepseek-v4.1-flash (max) | 61 × 2 | 1.206 (1.035–1.415) | 84.4% → 82.8% | −1.6 | dev ×2 | [g] |
| 66 | **−46.2** | [`TokenEconomizer`](runs/external-retests.md) | [terb](runs/external-retests.md#terb) | deepseek-v4.1-flash (max) | 92 × 2 | 1.433 (1.292–1.598) | 148/184 → 145/184 | −1.6 | dev ×2 |  |
| 67 | **−52.0** | [`Polaris-topo`](runs/external-retests.md) | [polaris-ds](runs/external-retests.md#polaris-ds) | deepseek-v4.1-flash (max) | 82 × 1 | 1.382 (1.170–1.670) | 66/82 → 60/82 | −7.3 | screen ×1 |  |
| 68 | **−73.2** | [`ReasoningBank`](runs/external-retests.md) | [terb](runs/external-retests.md#terb) | deepseek-v4.1-flash (max) | 92 × 2 | 1.661 (1.544–1.791) | 148/184 → 142/184 | −3.3 | dev ×2 |  |
| 69 | **−87.6** | [`TokenEconomizer`](runs/external-retests.md) | [opus-v2](runs/external-retests.md#opus-v2) | claude-opus-5-5 (xhigh) | 30 × 1 | 1.747 (0.940–2.900) | 29/30 → 27/30 | −6.7 | screen ×1 | [f] same-channel 23 pairs: 0.943 |
| 70 | **−183.5** | [`ReasoningBank`](runs/external-retests.md) | [opus-v2](runs/external-retests.md#opus-v2) | claude-opus-5-5 (xhigh) | 30 × 1 | 2.737 (1.470–4.570) | 29/30 → 28/30 | −3.3 | screen ×1 | [f] same-channel 27 pairs: 1.765 |
| 71 | **−249.0** | [`Polaris-cli`](runs/external-retests.md) | [polaris-ds](runs/external-retests.md#polaris-ds) | deepseek-v4.1-flash (max) | 82 × 1 | 3.490 (2.910–4.260) | 66/82 → 66/82 | +0.0 | screen ×1 |  |
| 72 | **−445.7** | [`Polaris-cli`](runs/external-retests.md) | [opus-v2](runs/external-retests.md#opus-v2) | claude-opus-5-5 (xhigh) | 30 × 1 | 5.269 (3.560–6.880) | 29/30 → 28/30 | −3.3 | screen ×1 | [f] same-channel 21 pairs: 3.401 |

- **[a]** Computed for this table from the per-task data with the run's own method; not part of the run's pre-registered analysis.
- **[b]** The native arm of this run had 4.9% of sessions with missing usage, above the 2% data-quality limit.
- **[c]** 2 of 81 sessions of this arm had missing usage (2.47%), above the 2% limit. The run's pre-registered mechanism gate failed (output per request 1.74× native, limit 1.15×).
- **[d]** The run failed its procedural checks (usage gaps), so it is descriptive only.
- **[e]** Seven long tasks that hit turn or time limits dominate the totals, and per-request uncached input rose about 17× between this run and the previous Kimi run for every arm, native included. Arms in this run could not be separated from each other.
- **[f]** Raw ratio. Several sessions in both arms ran on upstream channels with very different thinking cost, which distorts the ratio; the same-channel ratio is in the notes.
- **[g]** One final attempt was cut by the gateway; reported, not judged.
- **[h]** Gateway list-price cost, not the fixed-price ledger.

## Runs

All runs use SWE-bench Verified tasks, one fresh session per task × arm × repetition, the same model and effort on both arms, arms interleaved task by task, no internet access, and the official SWE-bench evaluation. Cost is estimated from per-request usage at fixed prices, with gateway list-price estimates marked [h].

| Run | Date | Model (effort) | Claude Code | Task set | Tasks × reps | Variants | Record | Per-task data |
|---|---|---|---|---|---|---|---|---|
| s1-haiku | 2026-11-25 | claude-haiku-5-5 (max) | 2.1.323 | dev-82 | 82 × 1 | `111`, `111D`, `000D`, `shell`, `noAgent` | [page](runs/s1-haiku.md) | [csv](data/s1-haiku.csv) |
| s1b-ds | 2026-11-25 | deepseek-v4.1-flash (max) | 2.1.323 | dev-82 | 82 × 1 | `001`, `010`, `111`, `shell`, `styleEmpty`, `100`, `appendCost` | [page](runs/s1b-ds.md) | [csv](data/s1b-ds.csv) |
| s1c-ds | 2026-11-26 | deepseek-v4.1-flash (max) | 2.1.323 | dev-82 | 82 × 2 | `F2bOnly`, `010`, `F2only`, `shell`, `F2aOnly`, `styleEmpty` | [page](runs/s1c-ds.md) | [csv](data/s1c-ds.csv) |
| s1d-ds | 2026-11-26 | deepseek-v4.1-flash (max) | 2.1.323 | dev-82 | 82 × 3 | `F2bOnly`, `F2bSuite`, `F2bTail`, `styleEmpty` | [page](runs/s1d-ds.md) | [csv](data/s1d-ds.csv) |
| c1-ds | 2026-11-26 | deepseek-v4.1-flash (max) | 2.1.323 | held-out-98 | 98 × 4 | `F2bOnly` | [page](runs/c1-ds.md) | [csv](data/c1-ds.csv) |
| kimi-w1 | 2026-11-26 | kimi-k3.1-pro (xhigh) | 2.1.323 | kimi-screen-28 | 28 × 1 | `K_synth_m1`, `K_verify`, `F2bOnly`, `111`, `K_synth`, `K_batch`, `styleEmpty`, `K_explore`, `H_m1` | [page](runs/kimi-w1.md) | [csv](data/kimi-w1.csv) |
| kimi-w2 | 2026-11-27 | kimi-k3.1-pro (xhigh) | 2.1.323 | kimi-factorial-40 | 40 × 1 | `F2b_m1`, `K_synth_m1`, `111_m1`, `F2bOnly`, `K_v2_m1`, `K_v2`, `K_lean_m1`, `111` | [page](runs/kimi-w2.md) | [csv](data/kimi-w2.csv) |
| ccb4 | 2026-11-08 | deepseek-v4.1-flash (max) | 2.1.319 | dev-97 | 97 × 2 | `v0` | [page](runs/2026-11-08-to-12.md#ccb4) | — |
| ccb5 | 2026-11-08 | deepseek-v4.1-flash (max) | 2.1.319 | dev-97 | 97 × 2 | `v1a-brief`, `v1b-budget` | [page](runs/2026-11-08-to-12.md#ccb5) | — |
| ccb7d | 2026-11-09 | deepseek-v4.1-flash (max) | 2.1.319 | fixed-60 | 60 × 2 | `v0` | [page](runs/2026-11-08-to-12.md#ccb7d) | — |
| ccb8 | 2026-11-10 | deepseek-v4.1-flash (max) | 2.1.319 | dev-97 | 97 × 2 | `v0`, `v1` | [page](runs/2026-11-08-to-12.md#ccb8) | — |
| seq1 | 2026-11-10 | deepseek-v4.1-flash (max) | 2.1.319 | django-seq-61 | 61 × 2 | `v0-notes`, `v0`, `TokenEconomizer` | [page](runs/2026-11-08-to-12.md#seq1) | — |
| dt1 | 2026-11-10 | deepseek-v4.1-flash (xhigh) | 2.1.319 | fixed-60 | 60 × 2 | `v2-stop-gate`, `v0` | [page](runs/2026-11-08-to-12.md#dt1) | — |
| dt3 | 2026-11-10 | deepseek-v4.1-flash (xhigh) | 2.1.319 | fixed-60 | 60 × 2 | `v0`, `v4-subagents` | [page](runs/2026-11-08-to-12.md#dt3) | — |
| cf1 | 2026-11-11 | deepseek-v4.1-flash (xhigh) | 2.1.319 | held-out-174 | 174 × 2 | `v0` | [page](runs/2026-11-08-to-12.md#cf1) | — |
| sc1 | 2026-11-11 | deepseek-v4.1-flash (xhigh) | 2.1.319 | screen-30 | 30 × 1 | `100`, `v0`, `RTK`, `DevSkills`, `010` | [page](runs/2026-11-08-to-12.md#sc1) | — |
| sc1-medium | 2026-11-11 | deepseek-v4.1-flash (medium) | 2.1.319 | screen-30 | 30 × 1 | `v0` | [page](runs/2026-11-08-to-12.md#sc1-medium) | — |
| lunamax1 | 2026-11-12 | gpt-6-luna (max) | 2.1.319 | fixed-60 | 60 × 2 | `v0` | [page](runs/2026-11-08-to-12.md#lunamax1) | — |
| jcm2 | 2026-11-25 | deepseek-v4.1-flash (max) | 2.1.323 | 30 tasks stratified by difficulty | 30 × 1 | `jCodeMunch` | [page](runs/external-retests.md#jcm2) | — |
| jcm3 | 2026-11-25 | claude-opus-5-5 (max) | 2.1.323 | dev-82 (50 sampled) | 50 × 1 | `jCodeMunch` | [page](runs/external-retests.md#jcm3) | — |
| terb | 2026-11-25 | deepseek-v4.1-flash (max) | 2.1.323 | 92 tasks in 6 repository streams | 92 × 2 | `TokenEconomizer`, `ReasoningBank` | [page](runs/external-retests.md#terb) | — |
| polaris-ds | 2026-11-25 | deepseek-v4.1-flash (max) | 2.1.323 | dev-82 | 82 × 1 | `Polaris-topo`, `Polaris-cli` | [page](runs/external-retests.md#polaris-ds) | — |
| polaris-kimi | 2026-11-26 | kimi-k3.1-pro (xhigh) | 2.1.323 | dev-82 | 82 × 1 | `Polaris-topo`, `Polaris-cli` | [page](runs/external-retests.md#polaris-kimi) | — |
| opus-v2 | 2026-11-26 | claude-opus-5-5 (xhigh) | 2.1.323 | dev-82 (30 in 3 repo streams) | 30 × 1 | `TokenEconomizer`, `ReasoningBank`, `Polaris-cli` | [page](runs/external-retests.md#opus-v2) | — |

## Not in the tables

- Experiments on an agent harness that is neither Claude Code nor Codex and is not publicly available.
- The local-model phase (Qwen3.6-35B-A3B on OpenHands with history-masking proxies): another harness and simulated prices. Its main finding shaped this plugin: masking old tool output cut raw tokens by 14–29% but raised cache-priced cost by 2–23%, so the plugin never rewrites history.
- Offline audits on recorded trajectories (stop-loss rules, deterministic prefetch, opening location hints, tool-output compression, cross-task code reuse). Each had an upper bound of a few percent and none was run live.
- Runs without scores: a 60-task check voided for a gateway cache fault; `dt2` (`v3a`, `v3b-codefind`), whose smoke run was aborted; a claude-opus-5-5 (xhigh) ablation that was pre-registered but not run; the Kimi wave-0 profiling run (native only).
- Atom combinations that were built but never run (`011`, `101` and the delegation-rule variants other than `000D` and `111D`). `110` has the same text as `v0`.

## Layout

```
experiments/
  README.md          this page
  leaderboard.csv    all results, one row per variant × run
  variants/<name>/   tested files and that variant's results
  runs/<run>.md      setup, arms, results and outcome of each run
  data/<run>.csv     per-task results for seven runs
```

From the repository root, load a Claude Code plugin variant for one session with `claude --plugin-dir experiments/variants/<name>`. For the released `111` variant, use `claude --plugin-dir ./plugin`. The [`appendCost`](variants/appendCost/) and [`noAgent`](variants/noAgent/) pages give their command-line flags. The [`codex-v0`](variants/codex-v0/) page contains the Codex instructions.

---

## 中文

本目录是一个公开的实验库：收录了所有做过配对评测的 token-saver 消融版本（33 个，另有 5 个只构建、没上过实验）和 7 个外部方法，共 72 条“版本 × 批次”结果，来自 2026-11-08 至 11-27 的 24 个批次。marketplace 仍只安装 `plugin/`（0.2.0，即表中的 `111`）。

**综合成绩**：同一批次内相对原生 Claude Code 的“每解出一题的费用节省率”，即 `100 × (1 − 费用比 × 原生解出数 / 版本解出数)`。+30 表示每解出一题比原生便宜 30%；负数表示更贵。少解的题按比例扣分。“按版本排行”里一个版本的成绩是它各批次成绩的平均。

**读法**：

- 只作描述。成绩都相对同批原生，但不同模型、题集、宿主版本之间仍不能直接比较。
- 不计确定性：40 题单次与 98 题 × 4 次的留出确认批权重相同，单批成绩也没有向 0 收缩，所以只测过一次的版本排得靠前，部分是运气。证据最多的是 `v0`（10 批）、`F2bOnly`（5 批）、`111`（4 批）。Kimi 上同一臂同题重跑的费用波动与换臂差不多大。
- 没有一个版本在留出题上证明了解决率不变差。证据最强的是 deepseek 上的 `F2bOnly`：98 道未用过的题 × 4 次，费用 0.696（0.616–0.776），但解决率低 2.6 个百分点，3 点与 5 点非劣效都没建立。
- 发布版本不是按这个排名选的，也不因排名替换。

[版本目录](variants/)收录实验文件和成绩，[批次记录](runs/)列出设置、实验臂和结论，[逐题数据](data/)覆盖七个批次，[成绩 CSV](leaderboard.csv)收录所有排名条目。

从仓库根目录用 `claude --plugin-dir experiments/variants/<名称>` 单次加载 Claude Code 实验插件。发布版 `111` 使用 `claude --plugin-dir ./plugin`。[`appendCost`](variants/appendCost/)和[`noAgent`](variants/noAgent/)各自列出启动参数，[`codex-v0`](variants/codex-v0/)提供 Codex 指令文件。
