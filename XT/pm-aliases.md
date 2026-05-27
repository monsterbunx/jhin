# Mapa de paquetes por distro (jhin multiplataforma)

Referencia para escribir instaladores que corran en Debian/Ubuntu (`apt`),
Fedora/RHEL (`dnf`), Alpine (`apk`) y Arch (`pacman`). El nombre del paquete
diverge entre distros; declarar por instalador y elegir con `$JHIN_PM` (de
[`XT/pm.sh`](pm.sh)).

## Patrón en el instalador

```bash
JHIN_BASE="${JHIN_BASE:-https://monsterbunx.github.io/jhin}"
. <(curl -fsSL "$JHIN_BASE/XT/pm.sh")

case "$JHIN_PM" in
  apt)    DEPS=(build-essential libssl-dev) ;;
  dnf)    DEPS=(gcc gcc-c++ make openssl-devel) ;;
  apk)    DEPS=(build-base openssl-dev) ;;
  pacman) DEPS=(base-devel openssl) ;;
esac
run pm_update
run pm_install "${DEPS[@]}"
```

## Tabla de equivalencias frecuentes

| Propósito | apt (Debian/Ubuntu) | dnf (Fedora/RHEL) | apk (Alpine) | pacman (Arch) |
|---|---|---|---|---|
| Toolchain C/C++ | `build-essential` | `gcc gcc-c++ make` o `@development-tools` | `build-base` | `base-devel` |
| Headers OpenSSL | `libssl-dev` | `openssl-devel` | `openssl-dev` | `openssl` |
| Descompresión xz | `xz-utils` | `xz` | `xz` | `xz` |
| zlib headers | `zlib1g-dev` | `zlib-devel` | `zlib-dev` | `zlib` |
| libcurl runtime | `libcurl4` | `libcurl` | `libcurl` | `curl` |
| JRE (Java runtime) | `default-jre` | `java-latest-openjdk-headless` | `openjdk17-jre` | `jre-openjdk` |
| JDK (Java dev) | `default-jdk` | `java-latest-openjdk-devel` | `openjdk17` | `jdk-openjdk` |
| Python dev headers | `libpython3-dev` | `python3-devel` | `python3-dev` | `python` |
| pkg-config | `pkg-config` | `pkgconf-pkg-config` | `pkgconf` | `pkgconf` |
| libxml2 headers | `libxml2-dev` | `libxml2-devel` | `libxml2-dev` | `libxml2` |
| ncurses headers | `libncurses-dev` | `ncurses-devel` | `ncurses-dev` | `ncurses` |
| readline headers | `libreadline-dev` | `readline-devel` | `readline-dev` | `readline` |
| git | `git` | `git` | `git` | `git` |
| unzip | `unzip` | `unzip` | `unzip` | `unzip` |

## Notas por distro

- **Alpine usa musl, no glibc.** Toolchains que asumen glibc (Swift, algunos
  binarios precompilados de Node/Bun "gnu") fallan. Preferir builds `-musl` o
  marcar el tool como no soportado en Alpine (ej. [`swift`](swift)).
- **Fedora**: `dnf` no necesita `update` antes de instalar, pero `pm_update`
  (makecache) ayuda en imágenes viejas. Los `-devel` son el equivalente de los
  `-dev` de Debian.
- **Arch**: rolling release, `pacman -Sy` puede dejar el sistema en estado
  parcial; `pm.sh` usa `-Sy --noconfirm` por simplicidad en contenedores
  efímeros (no recomendado en hosts reales — ahí usar `-Syu`).
- **ca-certificates**: en Debian/Alpine hay que instalarlo explícito; en Fedora
  suele venir en la imagen base. Incluirlo siempre en `pm_install` es inocuo.

## Convenciones de arquitectura por tool

`$JHIN_ARCH` normaliza a `amd64`/`arm64`. Cada upstream nombra distinto:

| Tool | amd64 | arm64 | Fuente |
|---|---|---|---|
| node | `linux-x64` | `linux-arm64` | nodejs.org/dist |
| zig | `zig-x86_64-linux` | `zig-aarch64-linux` | ziglang.org/download |
| coursier `cs` | `cs-x86_64-pc-linux-static` | (inconsistente por release → usar JAR launcher) | github coursier |
| swift | `ubuntu22.04` | `ubuntu22.04-aarch64` | download.swift.org |
| go | `linux-amd64` | `linux-arm64` | go.dev/dl |
| rust (rustup) | autodetecta | autodetecta | rustup.rs |
| bun | `linux-x64` | `linux-aarch64` | github oven-sh/bun |

> **coursier**: el binario nativo `cs` aarch64 no está en todos los releases
> `latest`. Para arm64 se usa el launcher JAR polyglot
> (`coursier/launchers/raw/master/coursier`), que corre en cualquier arch con
> JVM. Ver [`scala`](scala).
