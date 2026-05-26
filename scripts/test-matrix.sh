#!/usr/bin/env bash
# scripts/test-matrix.sh — prueba instaladores jhin en una matriz distro × arch
# usando contenedores efímeros. Sourcea la copia LOCAL del repo (JHIN_BASE=file://)
# para validar ediciones sin publicar a GitHub Pages primero.
#
# Uso:
#   scripts/test-matrix.sh                      # tools por defecto, debian:13, amd64+arm64
#   TOOLS="nodejs zig" scripts/test-matrix.sh
#   DISTROS="debian:12 debian:13 fedora:40 alpine:3.20" ARCHES="amd64 arm64" scripts/test-matrix.sh
#
# Cross-arch requiere binfmt/qemu (una vez):
#   sg docker -c "docker run --rm --privileged tonistiigi/binfmt --install all"

set -u
REPO="$(cd "$(dirname "$0")/.." && pwd)"

TOOLS="${TOOLS:-nodejs zig scala swift}"
DISTROS="${DISTROS:-debian:13}"
ARCHES="${ARCHES:-amd64 arm64}"
# Cómo invocar docker. En apocalipsis: `sg docker -c`. Override con DOCKER_RUN="docker".
DOCKER_RUN="${DOCKER_RUN:-}"

# Runner que corre DENTRO del contenedor. Arranca con /bin/sh (presente en toda
# distro, incl. Alpine que no trae bash), bootstrapea curl+bash, y recién ahí
# sourcea el instalador bajo bash.
RUNNER="$(mktemp)"
cat > "$RUNNER" <<'EOF'
#!/bin/sh
tool="$1"
if command -v apt-get >/dev/null 2>&1; then
  # deb10 (buster) es EOL → repos en archive.debian.org, sin Valid-Until.
  if grep -qs buster /etc/os-release 2>/dev/null; then
    sed -i 's|deb.debian.org/debian|archive.debian.org/debian|g; s|security.debian.org/debian-security|archive.debian.org/debian-security|g; s|deb.debian.org/debian-security|archive.debian.org/debian-security|g; /buster-updates/d' /etc/apt/sources.list 2>/dev/null
    APT_OPTS="-o Acquire::Check-Valid-Until=false"
  fi
  export DEBIAN_FRONTEND=noninteractive
  # shellcheck disable=SC2086
  apt-get $APT_OPTS update -qq >/dev/null && apt-get install -y -qq curl ca-certificates bash >/dev/null
elif command -v dnf >/dev/null 2>&1; then dnf install -y -q curl ca-certificates bash >/dev/null
elif command -v apk >/dev/null 2>&1; then apk add --no-cache -q curl ca-certificates bash >/dev/null
fi
export JHIN_BASE=file:///jhin JHIN_TOOL="$tool"
# El instalador se autoverifica al final (node -v, zig version, etc.).
bash -c '. "/jhin/$JHIN_TOOL" es -v'
EOF
chmod +x "$RUNNER"
trap 'rm -f "$RUNNER"' EXIT

run_docker() {
  if [ -n "$DOCKER_RUN" ]; then $DOCKER_RUN "$@"; else sg docker -c "docker $(printf '%q ' "$@")"; fi
}

pass=0; fail=0; FAILED=""
for distro in $DISTROS; do
  for arch in $ARCHES; do
    for tool in $TOOLS; do
      label="$tool @ $distro/$arch"
      printf '▶ %-30s ... ' "$label"
      if run_docker run --rm "--platform=linux/$arch" \
           -v "$REPO:/jhin:ro" -v "$RUNNER:/run.sh:ro" \
           "$distro" sh /run.sh "$tool" >/tmp/jhin-test.log 2>&1; then
        echo "OK"; pass=$((pass+1))
      else
        echo "FAIL (ver /tmp/jhin-test.log)"; fail=$((fail+1)); FAILED="$FAILED\n  - $label"
      fi
    done
  done
done

echo ""
echo "═══ resultado: $pass OK · $fail FAIL ═══"
[ "$fail" -gt 0 ] && printf 'fallaron:%b\n' "$FAILED"
exit "$fail"
