#!/bin/sh
# token-saver v3b: SessionStart. Tells the agent where the code search helper is and how to call it, as additional
# context, once per conversation (startup or clear; not on resume or compaction). POSIX sh only; the hook input (JSON)
# arrives on stdin. Fail open: any problem -> exit 0 with no output. TOKEN_SAVER_CODEFIND=0 turns it off.
[ "${TOKEN_SAVER_CODEFIND:-1}" = 0 ] && exit 0
input=$(cat 2>/dev/null) || exit 0
case $input in
  *'"source":"startup"'* | *'"source": "startup"'* | *'"source":"clear"'* | *'"source": "clear"'*) ;;
  *) exit 0 ;;
esac
root=${CLAUDE_PLUGIN_ROOT:-}
[ -n "$root" ] && [ -f "$root/bin/codefind.sh" ] || exit 0
case $root in *[!A-Za-z0-9_./-]*) exit 0 ;; esac
cat <<MSG
Code search helper (token-saver): sh $root/bin/codefind.sh [-i] [-w] PATTERN [PATH...]
It greps PATTERN (extended regex) under PATH (default: the current directory) and, in one call, prints each match inside its enclosing function or class, grouped by file (at most 300 lines; it says how to narrow the search when there is more).
Example: sh $root/bin/codefind.sh -w parse_header src/
MSG
exit 0
