#!/bin/sh
# token-saver environment facts (optional part). POSIX sh only; the hook input (JSON) arrives on stdin.
# SessionStart: print a few facts about the project, detected right now, as additional context. Printed once, when a
# conversation starts (not on resume or compaction), at most about 600 characters. It only looks at marker files in the
# project directory and asks tools on PATH for their version: no network, nothing remembered between sessions.
# Fail open: any error -> exit 0 with whatever was found, or nothing. TOKEN_SAVER_ENV_FACTS=0 turns it off.

[ "${TOKEN_SAVER_ENV_FACTS:-1}" = 0 ] && exit 0
input=$(cat 2>/dev/null) || exit 0
case $input in
  *'"source":"startup"'* | *'"source": "startup"'* | *'"source":"clear"'* | *'"source": "clear"'*) ;;
  *) exit 0 ;;
esac
if [ -n "${CLAUDE_PROJECT_DIR:-}" ]; then cd "$CLAUDE_PROJECT_DIR" 2>/dev/null || exit 0; fi

has() { command -v "$1" >/dev/null 2>&1; }
# First line of a version command, reduced to plain characters and a bounded length.
ver() { "$@" 2>&1 | head -n 1 | tr -cd 'A-Za-z0-9 ._+-' | cut -c1-40; }
join() { sep=; out=; for x in "$@"; do out="$out$sep$x"; sep=', '; done; printf '%s' "$out"; }

set --
for f in pyproject.toml setup.py setup.cfg tox.ini noxfile.py pytest.ini conftest.py package.json tsconfig.json \
         Cargo.toml go.mod pom.xml build.gradle Makefile CMakeLists.txt; do
  [ -f "$f" ] && set -- "$@" "$f"
done
for d in tests test testing spec; do [ -d "$d" ] && set -- "$@" "$d/"; done
files=$(join "$@")

set --
[ -f tox.ini ] && set -- "$@" "tox"
for f in pytest.ini pyproject.toml setup.cfg tox.ini; do
  if [ -f "$f" ] && grep -q -e '^\[pytest\]' -e '^\[tool:pytest\]' -e '^\[tool\.pytest' "$f" 2>/dev/null; then
    set -- "$@" "pytest (configured in $f)"; break
  fi
done
for f in runtests.py tests/runtests.py run_tests.py; do [ -f "$f" ] && set -- "$@" "$f"; done
[ -f Makefile ] && grep -q '^test:' Makefile 2>/dev/null && set -- "$@" "make test"
[ -f package.json ] && grep -q '"test"[[:space:]]*:' package.json 2>/dev/null && set -- "$@" "npm test"
[ -f Cargo.toml ] && set -- "$@" "cargo test"
[ -f go.mod ] && set -- "$@" "go test ./..."
tests=$(join "$@")

set --
py=
if has python; then py=python; elif has python3; then py=python3; fi
if [ -n "$py" ] && { [ -f pyproject.toml ] || [ -f setup.py ] || [ -f setup.cfg ] || [ -f tox.ini ] || [ -f pytest.ini ]; }; then
  set -- "$@" "$py = $(ver "$py" --version)"
  "$py" -c 'import pytest' >/dev/null 2>&1 && set -- "$@" "$(ver "$py" -m pytest --version)"
fi
[ -f package.json ] && has node && set -- "$@" "node $(ver node --version)"
[ -f go.mod ] && has go && set -- "$@" "$(ver go version)"
[ -f Cargo.toml ] && has cargo && set -- "$@" "$(ver cargo --version)"
tools=$(join "$@")

[ -n "$files$tests$tools" ] || exit 0
echo "Project facts detected when the session started (not exhaustive):"
[ -n "$files" ] && printf '%s\n' "- project and test config: $files" | cut -c1-180
[ -n "$tests" ] && printf '%s\n' "- test entry points: $tests" | cut -c1-180
[ -n "$tools" ] && printf '%s\n' "- on PATH: $tools" | cut -c1-170
exit 0
