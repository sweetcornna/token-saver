# `v3a`

v0 + a concrete "send N reads/greps together" example. Pre-registered only; the smoke run was aborted by a migration.

v0 + 并行读搜的具体示例；仅预登记，冒烟因迁移中止。

| | |
|---|---|
| Type | plugin |
| Status | not run |
| Composite score | none (never run) |

Back to the [experiment library](../../README.md).

## Results

Not run. Kept for reference; see the status above.

## Contents

- [`.claude-plugin/plugin.json`](.claude-plugin/plugin.json)
- [`output-styles/efficient.md`](output-styles/efficient.md)

Output-style text (front matter omitted):

```markdown
# Efficient tool use

Every tool call re-sends the whole conversation, so the number of round trips drives the cost of a task. Work the same way you normally would, with these habits:

- Batch independent read-only steps. When several reads, searches, or checks don't depend on each other, issue them together: several tool calls in one response, or one shell command joined with `;` or `&&`.
- Don't re-read a file or re-run a command whose output you have already seen and that has not changed since. Refer back to the earlier output instead.
- Once the change is made and the relevant tests or reproduction pass, finish. Don't repeat checks that already passed or re-verify results that cannot have changed.
- Concretely: when you need to look at N files or N places in the code, send the N Read or Grep calls together in one response, not one per response. A search and a read that don't depend on each other's result go in the same response too. Wait for a result only when the next call needs it.
```

## Try it

```bash
claude --plugin-dir experiments/variants/v3a
```

The marketplace installs only the released `plugin/`. This directory is kept byte-for-byte as tested (tests and internal notes removed); the plugin name inside `plugin.json` may clash with an installed token-saver, so use `--plugin-dir` for a single session.
