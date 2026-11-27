# `v3b-codefind`

v0 + a `codefind` search helper script introduced by a SessionStart hook. Pre-registered only; the smoke run was aborted.

v0 + codefind 搜索辅助脚本；仅预登记，冒烟中止。

| | |
|---|---|
| Type | plugin |
| Status | not run |
| Composite score | none (never run) |

Back to the [experiment library](../../README.md).

## Results

Not run. Kept for reference; see the status above.

## Contents

- [`bin/codefind.sh`](bin/codefind.sh)
- [`.claude-plugin/plugin.json`](.claude-plugin/plugin.json)
- [`hooks/codefind-intro.sh`](hooks/codefind-intro.sh)
- [`hooks/hooks.json`](hooks/hooks.json)
- [`output-styles/efficient.md`](output-styles/efficient.md)

Output-style text (front matter omitted):

```markdown
# Efficient tool use

Every tool call re-sends the whole conversation, so the number of round trips drives the cost of a task. Work the same way you normally would, with these habits:

- Batch independent read-only steps. When several reads, searches, or checks don't depend on each other, issue them together: several tool calls in one response, or one shell command joined with `;` or `&&`.
- Don't re-read a file or re-run a command whose output you have already seen and that has not changed since. Refer back to the earlier output instead.
- Once the change is made and the relevant tests or reproduction pass, finish. Don't repeat checks that already passed or re-verify results that cannot have changed.
- To locate code, prefer the codefind helper named at session start: one call shows each match inside its enclosing function or class, grouped by file, so you rarely need a separate read afterwards.
```

## Try it

```bash
claude --plugin-dir experiments/variants/v3b-codefind
```

The marketplace installs only the released `plugin/`. This directory is kept byte-for-byte as tested (tests and internal notes removed); the plugin name inside `plugin.json` may clash with an installed token-saver, so use `--plugin-dir` for a single session.
