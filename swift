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

. <(curl -fsSL https://monsterbunx.github.io/jhin/XT/swift) "$LANG_ARG"

say()  { printf '%b\n' "$1"; }
run()  { if [ "$VERBOSE" = "1" ]; then "$@"; else "$@" >/dev/null 2>&1; fi; }

SWIFT_VER="6.1.2"
SWIFT_DIR="ubuntu2204"
SWIFT_FILE_DIST="ubuntu22.04"

say "$XT_TITLE"

say "$XT_DEPS"
run apt update
run apt install -y curl ca-certificates binutils gnupg2 libc6-dev libcurl4 libedit2 libgcc-12-dev libpython3-dev libsqlite3-0 libstdc++-12-dev libxml2-dev libz3-dev pkg-config tzdata zlib1g-dev unzip

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
