#!/bin/bash
# jhin/go — instalador Go vía tar.gz desde go.dev/dl.
# Uso (sourceado): . <(curl -fsSL https://monsterbunx.github.io/jhin/go) [lang] [-v]

LANG_ARG=""
VERBOSE=0
for arg in "$@"; do
  case "$arg" in
    -v|--verbose) VERBOSE=1 ;;
    -h|--help) echo "uso: go [lang] [-v]"; return 0 2>/dev/null || exit 0 ;;
    *) [ -z "$LANG_ARG" ] && LANG_ARG="$arg" ;;
  esac
done
LANG_ARG="${LANG_ARG:-es}"

JHIN_BASE="${JHIN_BASE:-https://monsterbunx.github.io/jhin}"
. <(curl -fsSL "$JHIN_BASE/XT/pm.sh")
. <(curl -fsSL "$JHIN_BASE/XT/go") "$LANG_ARG"

say()  { printf '%b\n' "$1"; }
sayf() { local f="$1"; shift; printf '%b\n' "$(printf "$f" "$@")"; }
run()  { if [ "$VERBOSE" = "1" ]; then "$@"; else "$@" >/dev/null 2>&1; fi; }

say "$XT_TITLE"

# El tarball oficial necesita curl (para bajar) y tar/gzip (para extraer).
run pm_update
run pm_install curl ca-certificates tar gzip

murl="https://go.dev/dl/"
say "$XT_FETCH_VERSION"
version=$(curl -s "$murl" | grep -oE 'go[0-9]+\.[0-9]+(\.[0-9]+)?\.src\.tar\.gz' | sed 's/\.src\.tar\.gz//' | uniq | head -n 1)
sayf "$XT_VERSION" "$version"

case "$JHIN_ARCH" in
  amd64) ark="linux-amd64" ;;
  arm64) ark="linux-arm64" ;;
  armhf) ark="linux-armv6l" ;;
  *)     jhin_unsupported_arch; return 1 2>/dev/null || exit 1 ;;
esac
sayf "$XT_ARCH" "$ark"

td=$(mktemp -d)
URL="$murl$version.$ark.tar.gz"
sayf "$XT_DOWNLOAD" "$version.$ark.tar.gz"
run curl -L -o "$td/go.tar.gz" "$URL"

say "$XT_EXTRACT"
run tar -C /usr/local -xzf "$td/go.tar.gz"
rm -rf "$td"

say "$XT_PATH"
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
export PATH=$PATH:/usr/local/go/bin

say "$XT_DONE"
go version
