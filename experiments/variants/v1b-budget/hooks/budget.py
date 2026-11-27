"""PostToolUse hook: count tool calls per session; at fixed thresholds append a short budget note.

Reads the hook input JSON on stdin (session_id, tool_name, ...). Keeps one small counter file per session in the
system temp directory. Prints a hookSpecificOutput.additionalContext JSON only when a threshold is reached, so the
note is appended once after that tool result and never changes earlier messages. Python 3.5+, standard library only.
TOKEN_SAVER_NUDGE_AT (comma-separated, default "50,90") overrides the thresholds, e.g. for testing."""
import json
import os
import re
import sys
import tempfile

NOTE = ("Budget note: this session has made %d tool calls, and every call re-sends the whole conversation. "
        "If the fix is in place and the relevant tests or reproduction pass, stop now and give the summary. "
        "Otherwise take the single most informative next step; avoid broad exploration and repeated checks.")


def main():
    try:
        data = json.load(sys.stdin)
    except Exception:
        return
    sid = re.sub(r"[^A-Za-z0-9_.-]", "_", str(data.get("session_id") or "default"))[:80]
    try:
        at = sorted(int(x) for x in os.environ.get("TOKEN_SAVER_NUDGE_AT", "50,90").split(",") if x.strip())
    except ValueError:
        at = [50, 90]
    path = os.path.join(tempfile.gettempdir(), "token-saver-budget-%s.count" % sid)
    n = 0
    try:
        with open(path) as f:
            n = int(f.read().strip() or 0)
    except (OSError, ValueError):
        n = 0
    n += 1
    try:
        with open(path, "w") as f:
            f.write(str(n))
    except OSError:
        return
    if n in at:
        print(json.dumps({"hookSpecificOutput": {"hookEventName": "PostToolUse", "additionalContext": NOTE % n}}))


if __name__ == "__main__":
    main()
