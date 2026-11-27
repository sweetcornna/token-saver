# token-saver

A Claude Code plugin that cuts API cost on coding tasks by reducing round trips. It is one static output style (`plugin/output-styles/efficient.md`, about 1 KB) and a manifest. No hooks, MCP servers, skills, agents or runtime.

**Status (2026-11-27):** the released style is 0.2.0. It has been tested on three models. Cost went down on all three, but quality non-inferiority has not been established on any of them, so treat every number below as descriptive.

中文说明见下方。

## What it does

The style keeps Claude Code's default coding instructions (`keep-coding-instructions: true`) and is applied whenever the plugin is enabled (`force-for-plugin: true`). It adds four habits:

1. Batch independent read-only steps (reads, searches, checks) into one response or one shell command.
2. Batch edits once the changes are known, instead of one edit per response.
3. Don't re-read files or re-run commands whose output has not changed.
4. Once the change is made and the relevant tests or reproduction pass, finish.

It does not rewrite, compress or mask history, and does not change the model or reasoning effort. The text is added once at session start, so the cached prefix is unchanged.

## Install

```bash
claude plugin marketplace add sweetcornna/token-saver
claude plugin install token-saver@token-saver
```

For a single session from a local clone:

```bash
claude --plugin-dir /path/to/token-saver/plugin
```

Uninstall with `claude plugin uninstall token-saver@token-saver`.

## Evidence so far

All runs use SWE-bench Verified tasks, Claude Code 2.1.323 and one fresh session per task per arm. Patches are scored with the official SWE-bench harness. Cost is computed from the per-request usage ledger at fixed list-style prices, with cache warm-up normalised. It is not an invoice.

| Model (effort) | Run | Tasks × runs | Arm | Cost vs. native (95% CI) | Resolved, native → arm |
|---|---|---|---|---|---|
| claude-haiku-5-5 (`max`) | 2026-11-25 paired | 81 × 1 | this plugin (0.2.0) | 0.590 (0.537–0.652) | 64/81 → 66/81 |
| deepseek-v4.1-flash (`max`) | 2026-11-26 held-out confirmation | 98 × 4 | closing habit only (`F2bOnly`) | 0.696 (0.616–0.776) | 80.7% → 78.1% |
| kimi-k3.1-pro (`xhigh`) | 2026-11-26 factorial | 40 × 1 | this plugin (0.2.0) | 0.908 (0.5442–1.3448); 10%-trimmed 0.7151 | 36/40 → 32/40 |
| kimi-k3.1-pro (`xhigh`) | same run | 40 × 1 | `K_v2` (experimental) | 0.8625 (0.5448–1.1786); 10%-trimmed 0.6491 | 36/40 → 34/40 |

### claude-haiku-5-5

| Comparison (81 aligned tasks) | Cost ratio (95% task-bootstrap CI) | Resolved |
|---|---|---|
| this plugin vs. native Claude Code | 0.590 (0.537–0.652); cheaper on 74/81 tasks | 64/81 → 66/81 |
| delivery wrapper only (`shell`) vs. native | 0.660 (0.602–0.724) | 65/82 → 67/82 |
| this plugin vs. `shell` | 0.894 (0.83–0.97) | 66/81 → 66/81 |

- About two thirds of the drop already appears with the `shell` control arm. `shell` is the same plugin with only the heading and one sentence of the style: "Every tool call re-sends the whole conversation, so the number of round trips drives the cost of a task. Work the same way you normally would." Loading any output style also makes Claude Code swap one identity sentence in its system prompt. This run cannot separate the effect of that swap from the effect of the cost sentence. The four habits add roughly another 10% on top of `shell`.
- The run's pre-registered mechanism gate failed. The plugin cut main-thread requests to 0.44× of native, but output per request rose to 1.74×, above the frozen 1.15× limit. Usage was also missing for 2.47% of the plugin's sessions, above the 2% data-quality limit.

### deepseek-v4.1-flash

- The held-out run used 98 tasks that were not used during development, with 4 runs per arm. It tested the closing habit alone (`F2bOnly`), which was the best arm on the development tasks.
- Cost fell to 0.696× native (upper bound below 1). Resolution fell by 2.6 points, and non-inferiority at 3 or 5 points was not established.
- Most of the loss came from 4 tasks where the agent stopped as soon as the reported reproduction passed and missed sibling code paths. That is the known risk of a "finish once verified" rule. Two rewordings meant to keep quality did not help on the development tasks, so the released style was not replaced.

### kimi-k3.1-pro

- In this run (40 tasks × 9 arms × 1), every variant was cheaper than native: the 10%-trimmed cost ratio was 0.57–0.72 for all eight variants. The untrimmed ratios have wide intervals because 7 long tasks that hit turn or time limits dominate the totals. Without those 7 tasks, the ratios were 0.51–0.72, and 7 of the 8 upper bounds were below 1.
- None of the variants established 5-point non-inferiority: native resolved 36/40, the variants 32–34/40. Most of the gap came from two Django tasks. On both, native wrote the same code change as the official fix, and almost every variant wrote a different one.
- The variants could not be ranked against each other on cost. On the same tasks, the same arm's cost varied across runs about as much as it varied between arms.
- Between two batches on the same day, per-request uncached input rose from about 130 to about 2,200 tokens for every arm, including native, with identical request settings. Only within-batch comparisons are reported.
- The experimental M1 hook, a session-start probe that prints the repository's test command, reduced the number of tasks that hit test-runner errors in all three pairs where it was added (16→5, 19→9, 20→7). Its effect on cost was not established.

Results on other models, effort levels or task types are untested.

## Experiment library

The [experiment library](experiments/README.md) ranks 33 tested variants and 7 outside methods using 72 results from 24 paired runs. Each entry links to its scores and run setup. The library includes our tested variant files, summaries for outside methods, and [per-task CSVs for seven runs](experiments/data/). The composite score measures the saving in cost per resolved task against native Claude Code in the same run. The ranking gives each run equal weight, and quality non-inferiority remains unestablished on held-out tasks. The marketplace installs version 0.2.0.

## References

Papers consulted while designing and evaluating the plugin are listed with DOIs in [`REFERENCES.md`](REFERENCES.md), with BibTeX in [`references.bib`](references.bib).

## License

MIT

---

## 中文

一个 Claude Code 插件，通过减少往返次数来降低编码任务的 API 费用。它只有一个静态 output style（`plugin/output-styles/efficient.md`，约 1 KB）和一个插件清单，不带 hook、MCP、skill、agent，也不需要任何运行时。

**现状（2026-11-27）**：发布版本是 0.2.0。已经在三个模型上测过，三个模型上费用都下降了，但都还没有证明解决率不变差，所以下面的数字只作描述。

内容是四条习惯：
- 互不依赖的只读步骤合并发出。
- 想好的修改一次改完。
- 没变的文件和输出不重看。
- 改完并且相关测试或复现通过就结束。

它保留 Claude Code 默认的编码指令，不改写历史，不改模型，也不改推理强度。安装方法见上面的 Install 一节。

### 证据

所有运行都用 SWE-bench Verified 题、Claude Code 2.1.323，每题每组各开一个新会话，补丁用官方评测打分。费用按逐请求用量和固定价目估算（做了缓存冷启动归一），不是实际账单。

- **claude-haiku-5-5，max**（81 题 × 1 次）：本插件费用是原生的 0.590 倍（95% 区间 0.537–0.652），解决数 64 → 66。约三分之二的降幅在只保留一句成本提示的对照臂 `shell` 上就已出现；预注册的机制门槛没有通过（每请求输出升到 1.74 倍）。
- **deepseek-v4.1-flash，max，留出确认批**（98 道开发期未用过的题 × 4 次）：只保留收尾一条（`F2bOnly`）的费用是原生的 0.696 倍（0.616–0.776）；解决率 80.7% → 78.1%（−2.6 个百分点），3 点和 5 点非劣效都没有建立。掉分主要来自 4 道“复现一通过就结束、漏修同类代码路径”的题，所以已发布版本没有替换。
- **kimi-k3.1-pro，xhigh**（40 题 × 9 组 × 1 次）：所有变体都比原生便宜，10% 截尾费用比 0.57–0.72；本插件 0.2.0 未截尾为 0.908（0.5442–1.3448），区间宽是因为 7 道撞上轮次或时间上限的长题主导了总额。没有一个变体建立 5 点非劣效：原生解决 36/40，各变体 32–34/40，差距主要来自两道 Django 题，原生在这两题上写出了与官方修法相同的改动。同一天的两批之间，所有组（含原生）每请求的未缓存输入从约 130 涨到约 2,200 token，所以只报告同批内的比较。实验性的 M1 hook（会话开始时打印仓库的测试命令）让踩到测试运行器错误的题数在三组对比里都下降了（16→5、19→9、20→7），对费用的作用还没有确立。

其他模型、推理强度或任务类型都还没有测过。

### 实验库与参考文献

- [公开实验库](experiments/README.md)收录 33 个已测自有版本、7 个外部方法和 24 批的 72 条成绩，附自有版本的实验文件、外部方法的复测摘要和[七批逐题 CSV](experiments/data/)。综合成绩按同批相对原生的每解出一题费用节省率计算，每批等权。留出题上的质量非劣效尚未建立。marketplace 安装 0.2.0。
- 设计和评测时参考的论文（附 DOI）见 `REFERENCES.md`，BibTeX 见 `references.bib`。
