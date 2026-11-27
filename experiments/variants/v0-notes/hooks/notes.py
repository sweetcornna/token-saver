"""SessionStart hook: inject the repository notes block once, at session start.

Reads the notes file (EXP_NOTES_FILE, default /ccbstate/notes.json: {"block": "<text>", ...}) written by the learning
step of a sequence experiment, and prints it as SessionStart additionalContext, so the notes sit in the prompt prefix for
the whole session and later turns keep hitting the prompt cache. Prints nothing when there is no file or no block.
The same hook serves the control arms: their learning step writes mismatched notes or neutral filler instead.
Python 3.5+, standard library only (the container's python3 is the task's own environment)."""
import json
import os
import sys


def main():
    try:
        sys.stdin.read()
    except Exception:
        pass
    path = os.environ.get("EXP_NOTES_FILE", "/ccbstate/notes.json")
    try:
        with open(path) as f:
            block = (json.load(f).get("block") or "").strip()
    except (OSError, ValueError):
        return
    if block:
        print(json.dumps({"hookSpecificOutput": {"hookEventName": "SessionStart", "additionalContext": block}}))


if __name__ == "__main__":
    main()
