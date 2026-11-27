#!/bin/sh
# codefind (token-saver v3b): search code and show every match inside its enclosing function or class, grouped by file,
# in one call. Read-only, no network; POSIX sh + grep + awk. Errors print one line and exit 0.
#   sh codefind.sh [-i] [-w] PATTERN [PATH...]      PATTERN is an extended regex; PATH defaults to the current directory.
# A match on a definition line (def / class / function ...) prints that definition's body (up to 40 lines); any other
# match prints its enclosing definition's first line and two lines around the match. At most CODEFIND_MAX_LINES (300)
# lines in all and 80 per file (CODEFIND_MAX_FILE_LINES); past that it says how many matches were left out and how to narrow the search.

MAXL=${CODEFIND_MAX_LINES:-300}
case $MAXL in '' | *[!0-9]*) MAXL=300 ;; esac
FMAX=${CODEFIND_MAX_FILE_LINES:-80}
case $FMAX in '' | *[!0-9]*) FMAX=80 ;; esac
usage() { echo "usage: sh codefind.sh [-i] [-w] PATTERN [PATH...]   (extended regex; default PATH is the current directory)"; }
gopt=
while [ $# -gt 0 ]; do
  case $1 in
    -i) gopt="$gopt -i"; shift ;;
    -w) gopt="$gopt -w"; shift ;;
    -iw | -wi) gopt="$gopt -i -w"; shift ;;
    -h | --help) usage; exit 0 ;;
    --) shift; break ;;
    -?*) echo "codefind: unknown option $1"; usage; exit 0 ;;
    *) break ;;
  esac
done
if [ $# -lt 1 ] || [ -z "$1" ]; then usage; exit 0; fi
pat=$1; shift
command -v grep >/dev/null 2>&1 && command -v awk >/dev/null 2>&1 || { echo "codefind: needs grep and awk on PATH"; exit 0; }
[ $# -eq 0 ] && set -- .
for p in "$@"; do [ -e "$p" ] || { echo "codefind: no such file or directory: $p"; exit 0; }; done
tmp=$(mktemp 2>/dev/null) || tmp=${TMPDIR:-/tmp}/codefind.$$
trap 'rm -f "$tmp"' EXIT
trap 'exit 0' HUP INT TERM
# shellcheck disable=SC2086
grep -HrnIE $gopt --exclude-dir=.git --exclude-dir=node_modules --exclude-dir=__pycache__ --exclude-dir=.tox \
     --exclude-dir=.eggs --exclude-dir=.mypy_cache --exclude-dir=.pytest_cache -e "$pat" -- "$@" > "$tmp" 2>/dev/null
rc=$?
if [ ! -s "$tmp" ]; then
  if [ $rc -gt 1 ]; then echo "codefind: grep failed (check the pattern): $pat"; else echo "codefind: no match for: $pat"; fi
  exit 0
fi
awk -v maxl="$MAXL" -v fmax="$FMAX" '
function indent(s,   m) { m = match(s, /[^ \t]/); return m ? m - 1 : -1 }
function isdef(s) { return s ~ /^[ \t]*(async[ \t]+def|def|class|function|func|fn|sub|struct|impl|trait|interface|enum|module)[ \t(]/ }
function emit(s) { if (out < maxl) { print s; out++; return 1 } cut = 1; return 0 }
function cuts(s) { return length(s) > 200 ? substr(s, 1, 200) " ..." : s }
{
  # grep -n output: path:line:text (the first ":<digits>:" ends the path)
  if (!match($0, /:[0-9]+:/)) next
  f = substr($0, 1, RSTART - 1); ln = substr($0, RSTART + 1, RLENGTH - 2) + 0
  if (!(f in nh)) { order[++nf] = f; nh[f] = 0 }
  hit[f, ++nh[f]] = ln; total++
}
END {
  out = 0; cut = 0; shown_files = 0; shown_hits = 0
  if (nf == 1) fmax = maxl   # one file: the per-file cap would only hide what the user asked for
  for (k = 1; k <= nf; k++) {
    f = order[k]
    if (out >= maxl) { cut = 1; break }
    n = 0
    while ((getline line < f) > 0) L[++n] = line
    close(f)
    delete mark; delete ishit
    for (j = 1; j <= nh[f]; j++) {
      h = hit[f, j]; ishit[h] = 1
      if (h < 1 || h > n) continue
      ih = indent(L[h])
      if (isdef(L[h])) {
        mark[h] = 1
        for (i = h + 1; i <= n && i <= h + 40; i++) {
          if (indent(L[i]) >= 0 && indent(L[i]) <= ih) break
          mark[i] = 1
        }
      } else {
        for (i = h - 2; i <= h + 2; i++) if (i >= 1 && i <= n) mark[i] = 1
        for (i = h - 1; i >= 1 && i >= h - 400; i--) {
          ii = indent(L[i])
          if (ii >= 0 && ii < ih && isdef(L[i])) { mark[i] = 1; break }
        }
      }
    }
    if (!emit("== " f " (" nh[f] (nh[f] == 1 ? " match)" : " matches)"))) break
    shown_files++
    prev = 0; fl = 0; fh = 0
    for (i = 1; i <= n; i++) {
      if (!(i in mark)) continue
      if (fl >= fmax) { if (!emit(sprintf("   ... %d more matches in this file not shown; pass this file as the only PATH to see them all", nh[f] - fh))) break; break }
      if (prev && i > prev + 1) { if (!emit("   ...")) break; fl++ }
      if (!emit(sprintf("%5d%s %s", i, (i in ishit) ? ">" : ":", cuts(L[i])))) break
      fl++
      if (i in ishit) { shown_hits++; fh++ }
      prev = i
    }
    if (cut) break
    delete L
  }
  if (cut || shown_files < nf || shown_hits < total)
    printf "codefind: %d of %d matches (in %d of %d files) shown (limits: %d lines, %d per file). Narrow PATTERN (-w, a longer name) or pass a PATH.\n", shown_hits, total, shown_files, nf, maxl, fmax
}' "$tmp"
exit 0
