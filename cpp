#!/bin/bash
# jhin/cpp — toolchain C/C++ (gcc, g++, clang, make) vía apt.
# Uso (sourceado): . <(curl -fsSL https://monsterbunx.github.io/jhin/cpp) [lang] [-v]

LANG_ARG=""
VERBOSE=0
for arg in "$@"; do
  case "$arg" in
    -v|--verbose) VERBOSE=1 ;;
    -h|--help) echo "uso: cpp [lang] [-v]"; return 0 2>/dev/null || exit 0 ;;
    *) [ -z "$LANG_ARG" ] && LANG_ARG="$arg" ;;
  esac
done
LANG_ARG="${LANG_ARG:-es}"

. <(curl -fsSL https://monsterbunx.github.io/jhin/XT/cpp) "$LANG_ARG"

say()  { printf '%b\n' "$1"; }
run()  { if [ "$VERBOSE" = "1" ]; then "$@"; else "$@" >/dev/null 2>&1; fi; }

say "$XT_TITLE"
say "$XT_DEPS"
run apt update
run apt install -y build-essential clang

say "$XT_DONE"
gcc --version | head -1
g++ --version | head -1
clang --version | head -1
