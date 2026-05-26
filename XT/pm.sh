# XT/pm.sh — capa de abstracción multiplataforma para los instaladores jhin.
# Detecta OS, arquitectura y package manager; expone helpers uniformes.
# Uso (sourceado por cada instalador):
#   JHIN_BASE="${JHIN_BASE:-https://monsterbunx.github.io/jhin}"
#   . <(curl -fsSL "$JHIN_BASE/XT/pm.sh")
#
# Tras sourcear quedan disponibles:
#   $JHIN_OS    debian|fedora|alpine|arch|unknown
#   $JHIN_ARCH  amd64|arm64|armhf|<uname -m crudo>
#   $JHIN_PM    apt|dnf|apk|pacman|unknown
#   pm_update              actualiza índices del PM
#   pm_install pkg...      instala paquetes (no interactivo)
#   pm_has pkg             ¿paquete instalado? (exit 0/1)
#   jhin_unsupported_arch  imprime aviso bilingüe y retorna 1

# --- Detección de OS (familia) ---
jhin_detect_os() {
  if [ -r /etc/os-release ]; then
    # shellcheck disable=SC1091
    . /etc/os-release
    case "$ID" in
      debian|ubuntu|linuxmint|pop|raspbian|devuan) echo "debian"; return ;;
      fedora|rhel|centos|rocky|almalinux|ol)       echo "fedora"; return ;;
      alpine)                                       echo "alpine"; return ;;
      arch|manjaro|endeavouros|cachyos)             echo "arch";   return ;;
    esac
    case " $ID_LIKE " in
      *" debian "*|*ubuntu*)        echo "debian"; return ;;
      *" fedora "*|*" rhel "*|*centos*) echo "fedora"; return ;;
      *" arch "*)                   echo "arch";   return ;;
    esac
  fi
  echo "unknown"
}

# --- Detección de arquitectura (normalizada) ---
jhin_detect_arch() {
  case "$(uname -m)" in
    x86_64|amd64)   echo "amd64" ;;
    aarch64|arm64)  echo "arm64" ;;
    armv7l|armv7|armhf) echo "armhf" ;;
    *)              uname -m ;;
  esac
}

# --- Detección de package manager ---
jhin_detect_pm() {
  if   command -v apt-get >/dev/null 2>&1; then echo "apt"
  elif command -v dnf     >/dev/null 2>&1; then echo "dnf"
  elif command -v apk     >/dev/null 2>&1; then echo "apk"
  elif command -v pacman  >/dev/null 2>&1; then echo "pacman"
  else echo "unknown"; fi
}

JHIN_OS="$(jhin_detect_os)"
JHIN_ARCH="$(jhin_detect_arch)"
JHIN_PM="$(jhin_detect_pm)"
export JHIN_OS JHIN_ARCH JHIN_PM

# --- Operaciones del PM (idempotentes, no interactivas) ---
pm_update() {
  case "$JHIN_PM" in
    apt)    DEBIAN_FRONTEND=noninteractive apt-get update ;;
    dnf)    dnf -y makecache ;;
    apk)    apk update ;;
    pacman) pacman -Sy --noconfirm ;;
    *)      return 1 ;;
  esac
}

pm_install() {
  [ "$#" -eq 0 ] && return 0
  case "$JHIN_PM" in
    apt)    DEBIAN_FRONTEND=noninteractive apt-get install -y "$@" ;;
    dnf)    dnf install -y "$@" ;;
    apk)    apk add --no-cache "$@" ;;
    pacman) pacman -S --noconfirm --needed "$@" ;;
    *)      return 1 ;;
  esac
}

pm_has() {
  case "$JHIN_PM" in
    apt)    dpkg -s "$1" >/dev/null 2>&1 ;;
    dnf)    rpm -q "$1"  >/dev/null 2>&1 ;;
    apk)    apk info -e "$1" >/dev/null 2>&1 ;;
    pacman) pacman -Q "$1" >/dev/null 2>&1 ;;
    *)      return 1 ;;
  esac
}

# --- Aviso de arquitectura no soportada (bilingüe, sin depender de xtractor) ---
jhin_unsupported_arch() {
  printf '%b\n' "✗ arquitectura no soportada: $(uname -m) — unsupported architecture"
  return 1 2>/dev/null || exit 1
}
