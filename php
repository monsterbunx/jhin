#!/bin/bash
# jhin/php — compilación de PHP desde fuente (php-src GitHub release).
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

. <(curl -fsSL https://monsterbunx.github.io/jhin/xt-php) "$LANG_ARG"

say()  { printf '%b\n' "$1"; }
run()  { if [ "$VERBOSE" = "1" ]; then "$@"; else "$@" >/dev/null 2>&1; fi; }

say "$XT_TITLE"

say "$XT_DEPS"
run apt update
run apt upgrade -y
run apt install -y libxml2-dev libsqlite3-dev build-essential curl autoconf bison re2c pkg-config

td=$(mktemp -d)
say "$XT_DOWNLOAD"
run curl -L -o "$td/php-src.tar.gz" https://github.com/php/php-src/archive/refs/tags/php-8.5.0.tar.gz

run tar -xzf "$td/php-src.tar.gz" -C "$td"
cd "$td"/php-src-* || return 1

say "$XT_BUILDCONF"
run ./buildconf --force

say "$XT_CONFIGURE"
run ./configure

say "$XT_BUILD"
run make -j"$(nproc)"

say "$XT_INSTALL"
run make install

cd ~ || return 1
rm -rf "$td"

say "$XT_DONE"
php -v
