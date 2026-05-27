#!/bin/bash
# jhin/sql — instalador SQLite (motor SQL standalone, sin daemon).
# Uso (sourceado): . <(curl -fsSL https://monsterbunx.github.io/jhin/sql) [lang] [-v]

LANG_ARG=""
VERBOSE=0
for arg in "$@"; do
  case "$arg" in
    -v|--verbose) VERBOSE=1 ;;
    -h|--help) echo "uso: sql [lang] [-v]"; return 0 2>/dev/null || exit 0 ;;
    *) [ -z "$LANG_ARG" ] && LANG_ARG="$arg" ;;
  esac
done
LANG_ARG="${LANG_ARG:-es}"

JHIN_BASE="${JHIN_BASE:-https://monsterbunx.github.io/jhin}"
. <(curl -fsSL "$JHIN_BASE/XT/pm.sh")
. <(curl -fsSL "$JHIN_BASE/XT/sql") "$LANG_ARG"

say()  { printf '%b\n' "$1"; }
run()  { if [ "$VERBOSE" = "1" ]; then "$@"; else "$@" >/dev/null 2>&1; fi; }

say "$XT_TITLE"
say "$XT_DEPS"
run pm_update
case "$JHIN_PM" in
  apt)    DEPS="sqlite3 libsqlite3-dev" ;;
  dnf)    DEPS="sqlite sqlite-devel" ;;
  apk)    DEPS="sqlite sqlite-dev" ;;
  pacman) DEPS="sqlite" ;;
esac
run pm_install $DEPS

say "$XT_DONE"
sqlite3 --version
