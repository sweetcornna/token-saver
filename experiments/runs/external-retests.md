# External methods retested in the same harness

在同一评测框架下复测的外部方法（不是本仓库的插件，代码不在这里）。

Back to the [experiment library](../README.md).

These are other people's tools run through our paired harness, with the same model and effort on both arms and the official SWE-bench evaluation. They are our settings, not the authors' evaluations, and they say nothing about other models, task types or configurations. Their code is not redistributed here. RTK, DevSkills and the first TokenEconomizer run are on the [earlier runs page](2026-11-08-to-12.md).

## jcm2

**jCodeMunch (code-retrieval MCP server).** 2026-11-25, `deepseek-v4.1-flash` (`max`), Claude Code 2.1.323, 30 tasks stratified by difficulty, 30 tasks × 1. Native vs. Claude Code with jCodeMunch, 30 tasks stratified by difficulty (10 easy, 10 medium, 10 hard), 50 concurrent sessions.

| Method | Score | Cost vs. native (95% CI) | Resolved, native → method | Δ pp | Notes |
|---|---:|---|---|---:|---|
| jCodeMunch | −22.0 | 1.167 (0.981–1.413) | 23/30 → 22/30 | −3.3 |  |

Not cheaper: 1.167 overall; easy 0.849, medium 1.441, hard 1.103. 29 of 30 sessions used the MCP server.

## jcm3

**jCodeMunch on claude-opus-5-5 (max).** 2026-11-25, `claude-opus-5-5` (`max`), Claude Code 2.1.323, dev-82 (50 sampled), 50 tasks × 1. 50 tasks sampled from `dev-82` (20 easy, 27 medium, 3 hard), USD list prices.

| Method | Score | Cost vs. native (95% CI) | Resolved, native → method | Δ pp | Notes |
|---|---:|---|---|---:|---|
| jCodeMunch | +9.3 | 1.050 (0.853–1.286) | 38/50 → 44/50 | +12.0 |  |

Cost 1.050 (0.853–1.286); resolved 38 → 44. Token volume 1.51× native.

## terb

**Microsoft TokenEconomizer and Google ReasoningBank on deepseek-v4.1-flash (max).** 2026-11-25, `deepseek-v4.1-flash` (`max`), Claude Code 2.1.323, 92 tasks in 6 repository streams, 92 tasks × 2. TokenEconomizer: the original plugin with micro-skills on (off by default). ReasoningBank: the upstream SWE memory module ported to Claude Code. Tasks ran in 6 repository streams in creation order, each stream starting from empty state, so that memory methods could learn across tasks; 92 tasks × 2 repetitions, 552 cells, 0 voided. The solver had six tools (Read, Edit, Write, Bash, Grep, Glob), so TokenEconomizer's tool trimming had little to trim.

| Method | Score | Cost vs. native (95% CI) | Resolved, native → method | Δ pp | Notes |
|---|---:|---|---|---:|---|
| TokenEconomizer | −46.2 | 1.433 (1.292–1.598) | 148/184 → 145/184 | −1.6 |  |
| ReasoningBank | −73.2 | 1.661 (1.544–1.791) | 148/184 → 142/184 | −3.3 |  |

Both costlier: TokenEconomizer 1.433 (its auxiliary memory calls alone were 9.50 of 42.00 CNY), ReasoningBank 1.661 (memory calls 14.57 CNY). Neither mechanism went into the plugin.

## polaris-ds

**Polaris Code v0.4.5 (RadiantAILabs/polaris_code) on deepseek-v4.1-flash (max).** 2026-11-25, `deepseek-v4.1-flash` (`max`), Claude Code 2.1.323, dev-82, 82 tasks × 1. Polaris replaces Claude Code as the agent. `cli` = generic `-p` mode; `topo` = official `--topology-task` gated mode (6 tools, 30-step graph). 82 tasks × 3 arms, every request reconciled with the relay.

| Method | Score | Cost vs. native (95% CI) | Resolved, native → method | Δ pp | Notes |
|---|---:|---|---|---:|---|
| Polaris-topo | −52.0 | 1.382 (1.170–1.670) | 66/82 → 60/82 | −7.3 |  |
| Polaris-cli | −249.0 | 3.490 (2.910–4.260) | 66/82 → 66/82 | +0.0 |  |

`cli` rewrote history prefixes 1,117 times while folding old tool output, which broke prompt caching (cache hit 89% vs. 99%) and produced most of the extra cost. `topo` cut billed tokens by 56% but cost more (1.382) and resolved 6 fewer tasks.

## polaris-kimi

**Polaris Code v0.4.5 on kimi-k3.1-pro (xhigh).** 2026-11-26, `kimi-k3.1-pro` (`xhigh`), Claude Code 2.1.323, dev-82, 82 tasks × 1. Same three arms after a zero-cost capture audit and gateway probes; output caps aligned at 64k. 246/246 cells scored, 0 infrastructure errors.

| Method | Score | Cost vs. native (95% CI) | Resolved, native → method | Δ pp | Notes |
|---|---:|---|---|---:|---|
| Polaris-topo | +3.8 | 0.946 (0.829–1.084) | 62/82 → 61/82 | −1.2 |  |
| Polaris-cli | −12.6 | 1.089 (0.903–1.339) | 62/82 → 60/82 | −2.4 |  |

`topo` 0.946 (0.829–1.084): fewer tools saved cache reads and output per request, but 45% more turns cancelled most of it. `cli` 1.089.

## opus-v2

**TokenEconomizer, ReasoningBank and Polaris on claude-opus-5-5 (xhigh).** 2026-11-26, `claude-opus-5-5` (`xhigh`), Claude Code 2.1.323, dev-82 (30 in 3 repo streams), 30 tasks × 1. 30 tasks from three repositories in time order × 5 arms after fixing ten harness issues (native Anthropic transport for Polaris, full tool surface, default ToolSearch, native output caps).

| Method | Score | Cost vs. native (95% CI) | Resolved, native → method | Δ pp | Notes |
|---|---:|---|---|---:|---|
| TokenEconomizer | −87.6 | 1.747 (0.940–2.900) | 29/30 → 27/30 | −6.7 | [f] same-channel 23 pairs: 0.943 |
| ReasoningBank | −183.5 | 2.737 (1.470–4.570) | 29/30 → 28/30 | −3.3 | [f] same-channel 27 pairs: 1.765 |
| Polaris-cli | −445.7 | 5.269 (3.560–6.880) | 29/30 → 28/30 | −3.3 | [f] same-channel 21 pairs: 3.401 |

Raw ratios are distorted by sessions on upstream channels with very different thinking cost. Same-channel pairs: TokenEconomizer 0.943 (23 pairs), ReasoningBank 1.765 (27), Polaris `cli` 3.401 (21). The Polaris `topo` arm of this run was withdrawn: a non-streaming channel was misclassified and an asymmetric upstream cache cut contaminated it, so no conclusion is drawn.

## Earlier retests

- RTK, [sc1](2026-11-08-to-12.md#sc1): 0.969 (0.784–1.187), 22/30 → 23/30.
- DevSkills, [sc1](2026-11-08-to-12.md#sc1): 1.036 (0.827–1.299), 22/30 → 23/30.
- TokenEconomizer, [seq1](2026-11-08-to-12.md#seq1): 1.206 (1.035–1.415), 84.4% → 82.8% [g].

- [f] Raw ratio. Several sessions in both arms ran on upstream channels with very different thinking cost, which distorts the ratio; the same-channel ratio is in the notes.
- [g] One final attempt was cut by the gateway; reported, not judged.
