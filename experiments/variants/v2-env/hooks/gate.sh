#!/bin/sh
# token-saver finishing gate. POSIX sh + git only; the hook input (JSON) arrives on stdin.
#   gate.sh baseline   SessionStart: remember what the working tree looks like now. Prints nothing.
#   gate.sh stop       Stop: if the tree differs from that baseline, hold the stop once and print a short checklist.
# The checklist goes to stderr with exit code 2, which Claude Code appends to the end of the conversation as
# "Stop hook feedback". Nothing earlier in the conversation is touched.
# Fail open: no git, not a repository, no baseline, unreadable input or any error -> exit 0 with no output, so a
# broken hook can never keep a session from starting or finishing. TOKEN_SAVER_GATE=0 turns the gate off.

[ "${TOKEN_SAVER_GATE:-1}" = 0 ] && exit 0
mode=${1:-}
input=$(cat 2>/dev/null) || exit 0

# The session id is the value of the first "session_id" key of the input. Only [A-Za-z0-9_-] is accepted, so it is safe
# in a file name. (Inside a JSON string a quote is written \", so a string value cannot contain the text "session_id":" .)
rest=${input#*\"session_id\"}
[ "$rest" != "$input" ] || exit 0
case $rest in :\"* | :\ \"*) ;; *) exit 0 ;; esac
rest=${rest#*\"}
sid=${rest%%\"*}
case $sid in '' | *[!A-Za-z0-9_-]*) exit 0 ;; esac
[ "${#sid}" -le 80 ] || exit 0

command -v git >/dev/null 2>&1 || exit 0
if [ -n "${CLAUDE_PROJECT_DIR:-}" ]; then cd "$CLAUDE_PROJECT_DIR" 2>/dev/null || exit 0; fi
[ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" = true ] || exit 0
top=$(git rev-parse --show-toplevel 2>/dev/null) || exit 0
cd "$top" 2>/dev/null || exit 0

state=${CLAUDE_PLUGIN_DATA:-${TMPDIR:-/tmp}/token-saver-$(id -u 2>/dev/null)}
mkdir -p "$state" 2>/dev/null || exit 0
base=$state/$sid.base
fired=$state/$sid.fired

# One hash for "what the tree looks like": the commit, the status lines, the full diff of tracked files, and the names
# and contents of untracked files that are not ignored (the first 200; a file the user has not added yet is still code).
# Hashed by git itself and read-only: no index refresh, nothing written to the repository.
fingerprint() {
  GIT_OPTIONAL_LOCKS=0; export GIT_OPTIONAL_LOCKS
  {
    git rev-parse HEAD 2>/dev/null
    git status --porcelain 2>/dev/null
    git diff --no-ext-diff --no-textconv HEAD 2>/dev/null
    git -c core.quotePath=false ls-files --others --exclude-standard 2>/dev/null
    git -c core.quotePath=false ls-files --others --exclude-standard 2>/dev/null | head -n 200 | git hash-object --stdin-paths 2>/dev/null
  } | git hash-object --stdin 2>/dev/null
}

case $mode in
  baseline)
    # Keep an existing baseline (the session was resumed or compacted); forget sessions older than a week.
    [ -s "$base" ] || ( fingerprint > "$base" ) 2>/dev/null
    find "$state" -type f \( -name '*.base' -o -name '*.fired' \) -mtime +7 -exec rm -f {} + >/dev/null 2>&1
    exit 0
    ;;
  stop)
    # Never hold a stop twice: not while Claude is already continuing because of a stop hook, and not again later.
    case $input in *'"stop_hook_active":true'* | *'"stop_hook_active": true'*) exit 0 ;; esac
    [ -e "$fired" ] && exit 0
    [ -s "$base" ] || exit 0
    now=$(fingerprint) || exit 0
    [ -n "$now" ] || exit 0
    [ "$now" = "$(cat "$base" 2>/dev/null)" ] && exit 0
    # Record that the gate fired before printing anything: if that fails, do not fire at all. (In a subshell: a failed
    # redirection on the special built-in ":" would otherwise end a POSIX shell with status 2 and an error on stderr,
    # which Claude Code would take for the gate's message.)
    ( : > "$fired" ) 2>/dev/null || exit 0
    [ -e "$fired" ] || exit 0
    cat >&2 <<'EOF'
One finishing check before you stop (asked once per session, because files changed):
1. Does the change handle the related cases the request implies: other inputs that should behave the same way, and other code paths that share the logic you changed?
2. Have you run the existing tests closest to the change?
If both are already done, finish now and do not repeat any check. Otherwise do only the missing part, then finish.
EOF
    exit 2
    ;;
esac
exit 0
