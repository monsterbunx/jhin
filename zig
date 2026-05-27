#!/bin/bash
# jhin/zig — instalador Zig vía tar.xz desde ziglang.org/download.
# Uso (sourceado): . <(curl -fsSL https://monsterbunx.github.io/jhin/zig) [lang] [-v]

LANG_ARG=""
VERBOSE=0
for arg in "$@"; do
  case "$arg" in
    -v|--verbose) VERBOSE=1 ;;
    -h|--help) echo "uso: zig [lang] [-v]"; return 0 2>/dev/null || exit 0 ;;
    *) [ -z "$LANG_ARG" ] && LANG_ARG="$arg" ;;
  esac
done
LANG_ARG="${LANG_ARG:-es}"

JHIN_BASE="${JHIN_BASE:-https://monsterbunx.github.io/jhin}"
. <(curl -fsSL "$JHIN_BASE/XT/pm.sh")
. <(curl -fsSL "$JHIN_BASE/XT/zig") "$LANG_ARG"

say()  { printf '%b\n' "$1"; }
sayf() { local f="$1"; shift; printf '%b\n' "$(printf "$f" "$@")"; }
run()  { if [ "$VERBOSE" = "1" ]; then "$@"; else "$@" >/dev/null 2>&1; fi; }

# Zig publica como zig-<uname -m>-linux-<ver> (x86_64 / aarch64).
case "$JHIN_ARCH" in
  amd64) ZIG_ARCH="x86_64" ;;
  arm64) ZIG_ARCH="aarch64" ;;
  *)     jhin_unsupported_arch; return 1 2>/dev/null || exit 1 ;;
esac

case "$JHIN_PM" in
  apt) XZ_PKG="xz-utils" ;;
  *)   XZ_PKG="xz" ;;
esac

say "$XT_TITLE"

say "$XT_DEPS"
run pm_update
run pm_install curl ca-certificates "$XZ_PKG"

say "$XT_FETCH_VERSION"
ZIG_VER=$(curl -fsSL https://ziglang.org/download/index.json | grep -oE '"[0-9]+\.[0-9]+\.[0-9]+"' | head -1 | tr -d '"')
sayf "$XT_VERSION" "$ZIG_VER"

td=$(mktemp -d)
sayf "$XT_DOWNLOAD" "$ZIG_VER"
run curl -fL -o "$td/zig.tar.xz" "https://ziglang.org/download/$ZIG_VER/zig-${ZIG_ARCH}-linux-$ZIG_VER.tar.xz"

say "$XT_EXTRACT"
rm -rf /usr/local/zig
mkdir -p /usr/local/zig
run tar -xJf "$td/zig.tar.xz" -C /usr/local/zig --strip-components=1
rm -rf "$td"

say "$XT_PATH"
ln -sf /usr/local/zig/zig /usr/local/bin/zig

say "$XT_DONE"
zig version
