#!/bin/bash
# jhin/scala — instalador Scala vía Coursier (cs setup).
# Uso (sourceado): . <(curl -fsSL https://monsterbunx.github.io/jhin/scala) [lang] [-v]

LANG_ARG=""
VERBOSE=0
for arg in "$@"; do
  case "$arg" in
    -v|--verbose) VERBOSE=1 ;;
    -h|--help) echo "uso: scala [lang] [-v]"; return 0 2>/dev/null || exit 0 ;;
    *) [ -z "$LANG_ARG" ] && LANG_ARG="$arg" ;;
  esac
done
LANG_ARG="${LANG_ARG:-es}"

. <(curl -fsSL https://monsterbunx.github.io/jhin/XT/scala) "$LANG_ARG"

say()  { printf '%b\n' "$1"; }
run()  { if [ "$VERBOSE" = "1" ]; then "$@"; else "$@" >/dev/null 2>&1; fi; }

say "$XT_TITLE"

say "$XT_DEPS"
run apt update
run apt install -y default-jre curl ca-certificates

td=$(mktemp -d)
say "$XT_DOWNLOAD"
run curl -fL -o "$td/cs" https://github.com/coursier/coursier/releases/latest/download/cs-x86_64-pc-linux-static
chmod +x "$td/cs"

say "$XT_SETUP"
run "$td/cs" setup --yes
rm -rf "$td"

say "$XT_PATH"
export PATH="$HOME/.local/share/coursier/bin:$PATH"

say "$XT_DONE"
"$HOME/.local/share/coursier/bin/scala" --version 2>&1 | head -1
