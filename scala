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

JHIN_BASE="${JHIN_BASE:-https://monsterbunx.github.io/jhin}"
. <(curl -fsSL "$JHIN_BASE/XT/pm.sh")
. <(curl -fsSL "$JHIN_BASE/XT/scala") "$LANG_ARG"

say()  { printf '%b\n' "$1"; }
run()  { if [ "$VERBOSE" = "1" ]; then "$@"; else "$@" >/dev/null 2>&1; fi; }

# JRE: el nombre del paquete diverge por distro.
case "$JHIN_PM" in
  apt)    JRE_PKG="default-jre" ;;
  dnf)    JRE_PKG="java-latest-openjdk-headless" ;;
  apk)    JRE_PKG="openjdk17-jre" ;;
  pacman) JRE_PKG="jre-openjdk" ;;
  *)      JRE_PKG="default-jre" ;;
esac

say "$XT_TITLE"

say "$XT_DEPS"
run pm_update
run pm_install "$JRE_PKG" curl ca-certificates gzip

td=$(mktemp -d)
say "$XT_DOWNLOAD"
# Coursier publica el binario nativo `cs` para x86_64 de forma estable, pero el
# release `latest` no siempre trae el aarch64 → en arm64 usamos el launcher JAR
# polyglot (corre en cualquier arch con JVM, que ya instalamos arriba).
case "$JHIN_ARCH" in
  amd64)
    run curl -fL -o "$td/cs.gz" https://github.com/coursier/coursier/releases/latest/download/cs-x86_64-pc-linux-static.gz
    run gunzip "$td/cs.gz"
    CS="$td/cs"
    ;;
  arm64)
    run curl -fL -o "$td/cs" https://github.com/coursier/launchers/raw/master/coursier
    CS="$td/cs"
    ;;
  *) jhin_unsupported_arch; return 1 2>/dev/null || exit 1 ;;
esac
chmod +x "$CS"

say "$XT_SETUP"
run "$CS" setup --yes
# Asegurar que scala esté instalado (cs setup en algunas versiones no lo incluye por defecto)
run "$CS" install scala scalac
rm -rf "$td"

say "$XT_PATH"
export PATH="$HOME/.local/share/coursier/bin:$PATH"

say "$XT_DONE"
"$HOME/.local/share/coursier/bin/scala" --version 2>&1 | head -1
