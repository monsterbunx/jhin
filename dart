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

JHIN_BASE="${JHIN_BASE:-https://monsterbunx.github.io/jhin}"
. <(curl -fsSL "$JHIN_BASE/XT/pm.sh")
. <(curl -fsSL "$JHIN_BASE/XT/dart") "$LANG_ARG"

say()  { printf '%b\n' "$1"; }
run()  { if [ "$VERBOSE" = "1" ]; then "$@"; else "$@" >/dev/null 2>&1; fi; }

# El repo apt de Google es amd64-only; el SDK zip cubre amd64+arm64 y cualquier
# distro glibc. En Alpine (musl) el SDK glibc corre con gcompat + libstdc++
# (verificado: dart run y dart compile exe funcionan).
case "$JHIN_ARCH" in
  amd64) DART_ARCH="x64" ;;
  arm64) DART_ARCH="arm64" ;;
  *)     jhin_unsupported_arch; return 1 2>/dev/null || exit 1 ;;
esac
case "$JHIN_PM" in
  apk) DEPS="curl ca-certificates unzip gcompat libstdc++" ;;
  *)   DEPS="curl ca-certificates unzip" ;;
esac

say "$XT_TITLE"

say "$XT_DEPS"
run pm_update
run pm_install $DEPS

say "$XT_INSTALL"
td=$(mktemp -d)
URL="https://storage.googleapis.com/dart-archive/channels/stable/release/latest/sdk/dartsdk-linux-${DART_ARCH}-release.zip"
run curl -fL -o "$td/dart.zip" "$URL"
rm -rf /usr/local/dart-sdk
run unzip -o "$td/dart.zip" -d /usr/local
ln -sf /usr/local/dart-sdk/bin/dart /usr/local/bin/dart
rm -rf "$td"
export PATH="/usr/local/dart-sdk/bin:$PATH"

say "$XT_DONE"
dart --version 2>&1
