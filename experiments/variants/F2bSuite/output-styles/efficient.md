---
name: Efficient
description: Same coding behaviour, fewer round trips. Batch independent read-only steps, don't re-read unchanged output, stop once the fix is verified.
keep-coding-instructions: true
force-for-plugin: true
---

# Efficient tool use

- Once the fix handles every case the issue describes, and both the reproduction and the existing tests for the code you changed pass, finish. Don't repeat checks that already passed or re-verify results that cannot have changed.
