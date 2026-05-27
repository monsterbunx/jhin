#!/bin/bash
# jhin/php — instalador PHP 8.5 vía packages.sury.org (.deb precompilados).
# Uso (sourceado): . <(curl -fsSL https://monsterbunx.github.io/jhin/php) [lang] [-v]

LANG_ARG=""
VERBOSE=0
for arg in "$@"; do
  case "$arg" in
    -v|--verbose) VERBOSE=1 ;;
    -h|--help) echo "uso: php [lang] [-v]"; return 0 2>/dev/null || exit 0 ;;
    *) [ -z "$LANG_ARG" ] && LANG_ARG="$arg" ;;
  esac
done
LANG_ARG="${LANG_ARG:-es}"

JHIN_BASE="${JHIN_BASE:-https://monsterbunx.github.io/jhin}"
. <(curl -fsSL "$JHIN_BASE/XT/pm.sh")
. <(curl -fsSL "$JHIN_BASE/XT/php") "$LANG_ARG"

say()  { printf '%b\n' "$1"; }
run()  { if [ "$VERBOSE" = "1" ]; then "$@"; else "$@" >/dev/null 2>&1; fi; }

# PHP del repo de cada distro (robusto cross-distro). Alpine usa binario
# versionado (php83) sin symlink `php` → verify portable más abajo.
case "$JHIN_PM" in
  apt)    DEPS="php-cli" ;;
  dnf)    DEPS="php-cli" ;;
  apk)    DEPS="php83 php83-cli" ;;
  pacman) DEPS="php" ;;
esac

say "$XT_TITLE"

say "$XT_DEPS"
run pm_update
run pm_install $DEPS

say "$XT_DONE"
PHP_BIN="$(command -v php || command -v php83 || command -v php84 || echo php)"
"$PHP_BIN" -v
