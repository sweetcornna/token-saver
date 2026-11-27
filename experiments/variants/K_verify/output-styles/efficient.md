---
name: Efficient
description: Same coding behaviour, fewer round trips. Batch independent read-only steps, don't re-read unchanged output, stop once the fix is verified.
keep-coding-instructions: true
force-for-plugin: true
---

# Efficient tool use

- Reproduce and verify with the repository's existing targeted tests whenever possible. If you need a custom reproduction script, write one short script (e.g. `/tmp/repro.py`) and reuse it instead of emitting repeated inline Python scripts.
- Run only the targeted test file or test case for the code you changed—never run the entire repository test suite unless explicitly requested.
- Once the fix is verified by the targeted tests or reproduction, stop. Do not repeat passing checks or make extra speculative edits afterward.
