# token-saver

A Claude Code plugin that cuts API cost on coding tasks by reducing round trips. It is one static output style (`plugin/output-styles/efficient.md`, about 1 KB) and a manifest. No hooks, MCP servers, skills, agents or runtime.

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

## Evidence so far (one run, not a confirmed result)

Paired experiment, 2026-11-25. Setup: `claude-haiku-5-5` at `max` effort, Claude Code 2.1.323, 82 SWE-bench Verified tasks, one session per task per arm. Patches were scored with the official SWE-bench harness. Cost is computed from the per-request usage ledger at list-style fixed prices with cache warm-up normalised. It is not an invoice.

| Comparison (81 aligned tasks) | Cost ratio (95% task-bootstrap CI) | Resolved |
|---|---|---|
| this plugin vs. native Claude Code | 0.590 (0.537–0.652); cheaper on 74/81 tasks | 64/81 → 66/81 |
| an empty plugin wrapper vs. native | 0.660 (0.602–0.724) | 65/82 → 67/82 |
| this plugin vs. the empty wrapper | 0.894 (0.83–0.97) | 66/81 → 66/81 |

How to read it:

- About two thirds of the drop also appears with an empty plugin wrapper that carries no instructions. The instructions add roughly another 10% on top of that.
- The run's pre-registered mechanism gate failed. The plugin cut main-thread requests to 0.44× of native, but output per request rose to 1.74×, above the frozen 1.15× limit. Usage was also missing for 2.47% of the plugin's sessions, above the 2% data-quality limit.
- Treat the cost numbers as descriptive. This is a single run on one model and one task family. Results on other models, effort levels or task types are untested.

## License

MIT

---

## 中文

一个 Claude Code 插件，通过减少往返次数来降低编码任务的 API 费用。它只有一个静态 output style（`plugin/output-styles/efficient.md`，约 1 KB）和一个插件清单，不带 hook、MCP、skill、agent，也不需要任何运行时。

内容是四条习惯：
- 互不依赖的只读步骤合并发出。
- 想好的修改一次改完。
- 没变的文件和输出不重看。
- 改完并且相关测试或复现通过就结束。

它保留 Claude Code 默认的编码指令，不改写历史，不改模型，也不改推理强度。

安装方法见上面的 Install 一节。

现有证据只有一次运行，不是确认结论。2026-11-25 的配对实验条件如下：
- 模型 claude-haiku-5-5，推理强度 max。
- 82 道 SWE-bench Verified 题，每题每组各 1 次，补丁用官方评测打分。
- 费用按逐请求用量和固定价目估算（做了缓存冷启动归一），不是实际账单。

结果：
- 本插件对原生 Claude Code 的费用比是 0.590，95% 区间 0.537–0.652。81 题里 74 题更便宜，解决数从 64/81 变成 66/81。
- 其中约三分之二的降幅来自不带任何指令的空插件外壳（空外壳对原生是 0.660）。指令本身在外壳之上再降约 10%（本插件对空外壳是 0.894，区间 0.83–0.97）。
- 这次运行预注册的机制门槛没有通过：主线程请求数降到原生的 0.44 倍，但每次请求的输出升到 1.74 倍，超过冻结的 1.15 倍上限。另外有 2.47% 的会话用量缺失，超过 2% 的数据质量上限。
- 换别的模型、推理强度或任务类型的效果都还没有测过。
