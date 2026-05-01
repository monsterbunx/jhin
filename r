#!/bin/bash
# jhin/r — instalador R (estadística) vía apt (r-base).
# Uso (sourceado): . <(curl -fsSL https://monsterbunx.github.io/jhin/r) [lang] [-v]

LANG_ARG=""
VERBOSE=0
for arg in "$@"; do
  case "$arg" in
    -v|--verbose) VERBOSE=1 ;;
    -h|--help) echo "uso: r [lang] [-v]"; return 0 2>/dev/null || exit 0 ;;
    *) [ -z "$LANG_ARG" ] && LANG_ARG="$arg" ;;
  esac
done
LANG_ARG="${LANG_ARG:-es}"

. <(curl -fsSL https://monsterbunx.github.io/jhin/XT/r) "$LANG_ARG"

say()  { printf '%b\n' "$1"; }
run()  { if [ "$VERBOSE" = "1" ]; then "$@"; else "$@" >/dev/null 2>&1; fi; }

say "$XT_TITLE"
say "$XT_DEPS"
run apt update
run apt install -y r-base

say "$XT_DONE"
R --version | head -1
