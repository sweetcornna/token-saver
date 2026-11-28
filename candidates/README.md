# Test candidates (2026-11-28)

Three versions of token-saver for side-by-side testing. All three are one static output style, with no hooks, MCP servers, skills or agents. The marketplace still installs 0.2.0 (`plugin/`), and nothing here changes it.

中文说明见下方。

| Candidate | Directory | What the style contains | Best evidence so far |
|---|---|---|---|
| **0.2.0** (released) | [`plugin/`](../plugin/) | Heading, one cost sentence, four habits (batch reads, batch edits, no re-reads, finish once verified) | claude-haiku-5-5 `max`: cost 0.590 (0.537–0.652) vs. native, resolved 64/81 → 66/81; development tasks, 1 run. **Not yet run on Sonnet.** |
| **lite** | [`candidates/lite/`](lite/) | Only the heading line `# Efficient tool use` | claude-sonnet-5-5 `xhigh`, **held-out** 98 tasks × 3: cost 0.724 (0.648–0.816), resolved 264/294 → 264/294 |
| **kv2** | [`candidates/kv2/`](kv2/) | 0.2.0's batching habits plus focus rules: targeted search and bounded reads, no git-history digging, targeted tests only, then finish | claude-sonnet-5-5 `xhigh`, **held-out** 98 tasks × 3: cost 0.713 (0.626–0.827), resolved 264/294 → 261/294 |

## What the Sonnet results show

- The held-out tasks were not used to pick these variants. The pass rule was written down before the run: the one-sided 95% lower bound of the resolve-rate difference ≥ −5 points, and the one-sided 95% upper bound of the cost ratio < 0.90. Both lite and kv2 pass: lite at 0.0 points (lower bound −2.38), kv2 at −1.02 points (lower bound −3.40). With a −3-point margin, lite passes and kv2 does not.
- lite and kv2 are tied: kv2 vs. lite 0.985 (0.922–1.054).
- On Sonnet, most of the saving comes from the names the model reads, delivered through the output-style channel. In exploratory runs on development tasks:
  - an output style with neutral names (`style-a:Style A`) saved nothing (0.999);
  - each of the plugin name `token-saver`, the style name `Efficient` and the heading `# Efficient tool use` saved 10–15% on its own.
  - the same words passed with `--append-system-prompt` instead of an output style cost 10% more than lite.
  - So **do not rename the plugin or the style** when testing. A renamed copy is an untested variant.
- On other models the instruction text matters more. On claude-haiku-5-5, 0.2.0 was 0.894 of the cost of a heading-plus-cost-sentence control. On deepseek-v4.1-flash, instruction text saved a further 10–17% over a heading-only style on development tasks. The finish-once-verified rule also cost 2.6 points of resolve rate on deepseek held-out tasks.

## Settings behind these numbers

- SWE-bench Verified, Claude Code 2.1.323, headless (`claude -p`), one fresh session per task per arm, scored with the official harness.
- Arms were run interleaved in the same batch, and every ratio is against native Claude Code in that batch.
- Cost is computed from the per-request usage (uncached input, cache read, cache write, output) at one fixed price table, with cache warm-up normalised. The table is 13 / 1.3 / 13 / 68 per million tokens and is the same for every arm. It is not Sonnet's list price and not an invoice, so ratios at other prices will shift somewhat.

## How to test

1. **One candidate at a time.** If the marketplace copy is installed, disable it first: `claude plugin disable token-saver@token-saver`. All three candidates are named `token-saver`.
2. **Load with an absolute path.** Use `claude --plugin-dir /absolute/path/to/candidates/lite`. A wrong or relative path silently runs native Claude Code, with no error.
3. **Check that it loaded.** The first model request should contain the line `# Output Style: token-saver:Efficient` exactly once. In Claude Code 2.1.323 and 2.1.332 it sits in a system-role message right after the first user message. The system prompt also changes to say "…according to your \"Output Style\"…".
4. **Pair with native.** Use the same model, effort, Claude Code version and tasks, with no plugin for the native arm. Interleave the arms and start a fresh session per task.
5. **Send back** per-task numbers for each arm: uncached input, cache read and cache write tokens, output tokens, number of requests, and resolved or not.

Files: the `efficient.md` in each directory is byte-identical to the file that was tested. sha256:
- `plugin/output-styles/efficient.md` `2c96e146…`
- `candidates/lite/output-styles/efficient.md` `bf194106…`
- `candidates/kv2/output-styles/efficient.md` `0ff46711…`

Only `version` and `description` in `plugin.json` differ from the tested builds, and neither is sent to the model.

---

## 中文

三个给队友并排测试的版本，都只有一个静态 output style。marketplace 仍然安装 0.2.0（`plugin/`），这里不改它。

| 候选 | 目录 | 内容 | 目前最好的证据 |
|---|---|---|---|
| **0.2.0**（已发布） | `plugin/` | 标题、一句成本提示、四条习惯 | claude-haiku-5-5 max：费用 0.590 倍，解决 64→66/81（开发题，1 次）。**还没在 Sonnet 上跑过** |
| **lite** | `candidates/lite/` | 只有标题行 `# Efficient tool use` | claude-sonnet-5-5 xhigh，**留出题** 98 × 3：费用 0.724 倍，解决 264→264/294 |
| **kv2** | `candidates/kv2/` | 0.2.0 的合并习惯加聚焦规则（定向搜索、不翻 git 历史、只跑相关测试） | claude-sonnet-5-5 xhigh，**留出题** 98 × 3：费用 0.713 倍，解决 264→261/294 |

- 留出题没参与挑选。事先写定的判定线是：解决率差单侧 95% 下界 ≥ −5 点，费用比单侧上界 < 0.90。lite 和 kv2 都过了，两者打平（0.985）。判定线改成 −3 点，lite 仍过，kv2 不过。
- 在 Sonnet 上，省钱主要靠模型读到的名字，并且要经 output style 通道送进去：
  - 名字中性的外壳不省钱；
  - 插件名、样式名、标题单独换上，各省 10–15%；
  - 同样的文字改走 `--append-system-prompt`，要贵 10%。
  - 所以测试时**不要改插件名或样式名**。
- 在 Haiku、DeepSeek 上，正文的作用更大。
- 测法：
  - 一次只开一个，先 `claude plugin disable token-saver@token-saver`；
  - `--plugin-dir` 用绝对路径，路径错了会静默跑成原生；
  - 首个请求里应恰好出现一次 `# Output Style: token-saver:Efficient`；
  - 和原生同模型、同档位、同版本、同题交错跑，每题新会话；
  - 回传每题每臂的四类 token、请求数和是否解出。
- 费用按一张固定价目（每百万 token 13 / 1.3 / 13 / 68，各臂相同）算，不是 Sonnet 官方价，也不是账单。
