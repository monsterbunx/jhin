#!/bin/bash
# jhin/dart — instalador Dart vía repo Google.
# Uso (sourceado): . <(curl -fsSL https://monsterbunx.github.io/jhin/dart) [lang] [-v]

LANG_ARG=""
VERBOSE=0
for arg in "$@"; do
  case "$arg" in
    -v|--verbose) VERBOSE=1 ;;
    -h|--help) echo "uso: dart [lang] [-v]"; return 0 2>/dev/null || exit 0 ;;
    *) [ -z "$LANG_ARG" ] && LANG_ARG="$arg" ;;
  esac
done
LANG_ARG="${LANG_ARG:-es}"

. <(curl -fsSL https://monsterbunx.github.io/jhin/XT/dart) "$LANG_ARG"

say()  { printf '%b\n' "$1"; }
run()  { if [ "$VERBOSE" = "1" ]; then "$@"; else "$@" >/dev/null 2>&1; fi; }

say "$XT_TITLE"

say "$XT_DEPS"
run apt update
run apt install -y gnupg apt-transport-https ca-certificates curl

say "$XT_KEYRING"
run curl -fsSL https://dl-ssl.google.com/linux/linux_signing_key.pub -o /tmp/dart.gpg.key
gpg --batch --yes --dearmor < /tmp/dart.gpg.key > /usr/share/keyrings/dart.gpg
rm -f /tmp/dart.gpg.key

say "$XT_REPO_ADD"
echo "deb [signed-by=/usr/share/keyrings/dart.gpg arch=amd64] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main" > /etc/apt/sources.list.d/dart_stable.list

say "$XT_REPO_UPDATE"
run apt update

say "$XT_INSTALL"
run apt install -y dart

say "$XT_DONE"
dart --version 2>&1
