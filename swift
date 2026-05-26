#!/bin/bash
# jhin/swift — instalador Swift vía tar.gz desde swift.org (build de Ubuntu, compatible con Debian 12).
# Uso (sourceado): . <(curl -fsSL https://monsterbunx.github.io/jhin/swift) [lang] [-v]

LANG_ARG=""
VERBOSE=0
for arg in "$@"; do
  case "$arg" in
    -v|--verbose) VERBOSE=1 ;;
    -h|--help) echo "uso: swift [lang] [-v]"; return 0 2>/dev/null || exit 0 ;;
    *) [ -z "$LANG_ARG" ] && LANG_ARG="$arg" ;;
  esac
done
LANG_ARG="${LANG_ARG:-es}"

JHIN_BASE="${JHIN_BASE:-https://monsterbunx.github.io/jhin}"
. <(curl -fsSL "$JHIN_BASE/XT/pm.sh")
. <(curl -fsSL "$JHIN_BASE/XT/swift") "$LANG_ARG"

say()  { printf '%b\n' "$1"; }
run()  { if [ "$VERBOSE" = "1" ]; then "$@"; else "$@" >/dev/null 2>&1; fi; }

# Swift.org publica builds glibc para Ubuntu (compatibles con Debian). Alpine usa
# musl → incompatible. Fedora necesita un build distinto. Por ahora: solo Debian/Ubuntu.
if [ "$JHIN_OS" != "debian" ]; then
  say "✗ swift: por ahora solo Debian/Ubuntu (glibc). $JHIN_OS no soportado."
  return 1 2>/dev/null || exit 1
fi

SWIFT_VER="6.1.2"
# arm64 lleva el sufijo -aarch64 en directorio y nombre de archivo.
case "$JHIN_ARCH" in
  amd64) SWIFT_SUFFIX="" ;;
  arm64) SWIFT_SUFFIX="-aarch64" ;;
  *)     jhin_unsupported_arch; return 1 2>/dev/null || exit 1 ;;
esac
SWIFT_DIR="ubuntu2204${SWIFT_SUFFIX}"
SWIFT_FILE_DIST="ubuntu22.04${SWIFT_SUFFIX}"

say "$XT_TITLE"

say "$XT_DEPS"
run pm_update
run pm_install curl ca-certificates binutils gnupg2 libc6-dev libcurl4 libedit2 libgcc-12-dev libncurses6 libpython3-dev libsqlite3-0 libstdc++-12-dev libxml2-dev libz3-dev pkg-config tzdata zlib1g-dev unzip

td=$(mktemp -d)
URL="https://download.swift.org/swift-${SWIFT_VER}-release/${SWIFT_DIR}/swift-${SWIFT_VER}-RELEASE/swift-${SWIFT_VER}-RELEASE-${SWIFT_FILE_DIST}.tar.gz"

say "$XT_DOWNLOAD"
run curl -fL -o "$td/swift.tar.gz" "$URL"

say "$XT_EXTRACT"
rm -rf /usr/local/swift
mkdir -p /usr/local/swift
run tar -xzf "$td/swift.tar.gz" -C /usr/local/swift --strip-components=1
rm -rf "$td"

say "$XT_PATH"
echo 'export PATH=/usr/local/swift/usr/bin:$PATH' > /etc/profile.d/swift.sh
export PATH=/usr/local/swift/usr/bin:$PATH

say "$XT_DONE"
swift --version
