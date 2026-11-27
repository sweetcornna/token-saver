# `v2-env`

`v2-stop-gate` + a SessionStart hook that injects project facts (test entry points, tool versions). Offline upper bound 2–3%; never run.

v2 + 注入项目事实；离线上界 2–3%，未上实验。

| | |
|---|---|
| Type | plugin |
| Status | not run |
| Composite score | none (never run) |
| Same output-style text as | [`v0-notes`](../v0-notes/), [`v2-stop-gate`](../v2-stop-gate/), [`v0`](../v0/) |

Back to the [experiment library](../../README.md).

## Results

Not run. Kept for reference; see the status above.

## Contents

- [`.claude-plugin/plugin.json`](.claude-plugin/plugin.json)
- [`hooks/env-facts.sh`](hooks/env-facts.sh)
- [`hooks/gate.sh`](hooks/gate.sh)
- [`hooks/hooks.json`](hooks/hooks.json)
- [`output-styles/efficient.md`](output-styles/efficient.md)

Output-style text (front matter omitted):

```markdown
# Efficient tool use

Every tool call re-sends the whole conversation, so the number of round trips drives the cost of a task. Work the same way you normally would, with these habits:

- Batch independent read-only steps. When several reads, searches, or checks don't depend on each other, issue them together: several tool calls in one response, or one shell command joined with `;` or `&&`.
- Don't re-read a file or re-run a command whose output you have already seen and that has not changed since. Refer back to the earlier output instead.
- Once the change is made and the relevant tests or reproduction pass, finish. Don't repeat checks that already passed or re-verify results that cannot have changed.
```

## Try it

```bash
claude --plugin-dir experiments/variants/v2-env
```

The marketplace installs only the released `plugin/`. This directory is kept byte-for-byte as tested (tests and internal notes removed); the plugin name inside `plugin.json` may clash with an installed token-saver, so use `--plugin-dir` for a single session.
