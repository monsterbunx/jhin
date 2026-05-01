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

. <(curl -fsSL https://monsterbunx.github.io/jhin/XT/php) "$LANG_ARG"

say()  { printf '%b\n' "$1"; }
run()  { if [ "$VERBOSE" = "1" ]; then "$@"; else "$@" >/dev/null 2>&1; fi; }

say "$XT_TITLE"

say "$XT_DEPS"
run apt update
run apt install -y lsb-release ca-certificates curl

say "$XT_KEYRING_DOWNLOAD"
run curl -sSLo /tmp/debsuryorg-archive-keyring.deb https://packages.sury.org/debsuryorg-archive-keyring.deb

say "$XT_KEYRING_INSTALL"
run dpkg -i /tmp/debsuryorg-archive-keyring.deb
rm -f /tmp/debsuryorg-archive-keyring.deb

say "$XT_REPO_ADD"
tee /etc/apt/sources.list.d/php.sources >/dev/null <<EOF
Types: deb
URIs: https://packages.sury.org/php/
Suites: $(lsb_release -sc)
Components: main
Signed-By: /usr/share/keyrings/debsuryorg-archive-keyring.gpg
EOF

say "$XT_REPO_UPDATE"
run apt update

say "$XT_PHP_INSTALL"
run apt install -y php8.5

say "$XT_DONE"
php -v
