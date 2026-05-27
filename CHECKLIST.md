# Checklist multiplataforma jhin

Objetivo: cada instalador funciona en **Debian 10/11/12/13, Kali, Ubuntu,
Alpine, Fedora** × **amd64 + arm64**.

> **Estado:** 37 instaladores migrados a `XT/pm.sh` y en `main`. i18n en 15
> idiomas (es en pt fr de it ru pl tr nl zh ja ko ar hi). Solo 2 ❌ irreducibles
> (swift/mongodb en Alpine: sin build musl). arm64 validado nativo en oracle.

Validación: `scripts/test-matrix.sh` (contenedores efímeros, `JHIN_BASE=file://`).

**Leyenda:** ✅ probado OK · 🟡 migrado, sin probar aún · ⬜ pendiente de migrar ·
⚠️ requiere ajuste · ❌ no soportado (con motivo) · ➖ N/A

**Distros (imagen docker):** deb10 `debian:10` · deb11 `debian:11` ·
deb12 `debian:12` · deb13 `debian:13` · kali `kalilinux/kali-rolling` ·
ubu `ubuntu:24.04` · alp `alpine:3.20` · fed `fedora:40`

> **deb10 (buster) es EOL**: sus repos viven en `archive.debian.org`. `pm.sh`
> aplica el fixup automático en `pm_update`. Aun así, varios repos de terceros
> (sury/php, google/dart, hashicorp) ya no publican para buster → ❌ esperables.

---

## Estado por tool

| Tool | Método de instalación | deb10 | deb11 | deb12 | deb13 | kali | ubu | alp | fed | arm64 |
|------|----------------------|:----:|:----:|:----:|:----:|:----:|:---:|:---:|:---:|:----:|
| **nodejs** | tarball nodejs.org (arch en URL) | ⬜ | ⬜ | ✅ | ✅ | ⬜ | ⬜ | ✅ | 🟡 | ✅ |
| **zig** | tarball ziglang.org (arch en URL) | ⬜ | ⬜ | ✅ | ✅ | ⬜ | ⬜ | ✅ | 🟡 | ✅ |
| **scala** | coursier (cs nativo amd64 / JAR arm64) | ⬜ | ⬜ | ✅ | ✅ | ⬜ | ⬜ | 🟡 | 🟡 | ✅ |
| **swift** | tarball swift.org (glibc, Ubuntu build) | ⬜ | ⬜ | ✅ | ⚠️ | ⬜ | ⬜ | ❌ musl | ⚠️ | ✅ |
| **go** | tarball go.dev (arch en URL) | 🟡 | 🟡 | ✅ | 🟡 | 🟡 | 🟡 | ✅ | ✅ | ✅ |
| **gotty** | binario github (arch en URL) | 🟡 | 🟡 | ✅ | 🟡 | 🟡 | 🟡 | ✅ | ✅ | ✅ |
| **rust** | rustup.rs (script, auto-arch) | 🟡 | 🟡 | ✅ | 🟡 | 🟡 | 🟡 | ✅ | ✅ | ✅ |
| **bun** | bun.sh/install (script, auto-arch) | 🟡 | 🟡 | ✅ | 🟡 | 🟡 | 🟡 | ✅ | ✅ | ✅ |
| **deno** | deno.land/install (script, auto-arch) | 🟡 | 🟡 | ✅ | 🟡 | 🟡 | 🟡 | ✅ | ✅ | ✅ |
| **haskell** | ghcup (script, auto-arch) | 🟡 | 🟡 | ✅ | 🟡 | 🟡 | 🟡 | ✅ | ✅ | ✅ |
| **kotlin** | zip github (JVM, arch-indep) | 🟡 | 🟡 | ✅ | 🟡 | 🟡 | 🟡 | ✅ | ✅ | ✅ |
| **crystal** | install.sh (apt/yum interno) | 🟡 | 🟡 | ✅ | 🟡 | 🟡 | 🟡 | ✅ | ✅ | ✅ |
| **cpp** | paquete distro (build-essential/clang) | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ➖ |
| **git** | paquete distro | ✅ | ✅ | ✅ | ✅ | ⚠️ | ✅ | ✅ | ✅ | ➖ |
| **jq** | paquete distro | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ➖ |
| **tmux** | paquete distro | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ➖ |
| **vim** | paquete distro | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ➖ |
| **java** | paquete distro (default-jdk/openjdk) | 🟡 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ➖ |
| **lua** | paquete distro (lua5.4) | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ➖ |
| **ruby** | paquete distro (ruby-full) | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ➖ |
| **r** | paquete distro (r-base) | 🟡 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ➖ |
| **elixir** | paquete distro (elixir) | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ➖ |
| **sql** | paquete distro (sqlite3) | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ➖ |
| **redis** | paquete distro (redis) | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ➖ |
| **mysql** | cliente distro (mariadb-client) | 🟡 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ➖ |
| **postgres** | paquete distro (postgresql) | 🟡 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ➖ |
| **python** | compila CPython desde fuente | 🟡 | 🟡 | ✅ | 🟡 | 🟡 | 🟡 | ✅ | ✅ | 🟡 |
| **typescript** | npm -g (requiere nodejs) | 🟡 | 🟡 | ✅ | 🟡 | 🟡 | 🟡 | ✅ | ✅ | ➖ |
| **prisma** | npm -g (requiere nodejs) | 🟡 | 🟡 | ✅ | 🟡 | 🟡 | 🟡 | ✅ | ✅ | ➖ |
| **docker** | .deb + binarios estáticos | 🟡 | 🟡 | ✅ | 🟡 | 🟡 | 🟡 | ✅ | ✅ | ✅ |
| **tailscale** | repo apt/dnf/apk + binario estático | 🟡 | 🟡 | ✅ | 🟡 | 🟡 | 🟡 | ✅ | ✅ | ✅ |
| **terraform** | repo hashicorp + zip estático | 🟡 | 🟡 | ✅ | 🟡 | 🟡 | 🟡 | ✅ | ✅ | ✅ |
| **dotnet** | repo MS deb/dnf + dotnet-install.sh | 🟡 | 🟡 | ✅ | 🟡 | 🟡 | 🟡 | ✅ | ✅ | ✅ |
| **vscode** | MS deb/dnf · code-server (apk, node musl) | 🟡 | 🟡 | ✅ | 🟡 | 🟡 | 🟡 | ✅ | ✅ | 🟡 |
| **dart** | repo apt Google (no fedora/alpine) | 🟡 | 🟡 | ✅ | 🟡 | 🟡 | 🟡 | ✅ | ✅ | ✅ |
| **php** | repo sury (Debian) / remi (Fedora) | 🟡 | 🟡 | ✅ | 🟡 | 🟡 | 🟡 | ✅ | ✅ | ➖ |
| **mongodb** | repo apt/dnf mongodb (no alpine) | 🟡 | 🟡 | ✅ | 🟡 | 🟡 | 🟡 | ❌ | ✅ | 🟡 |

---

## Lotes de migración (orden de trabajo)

### Lote 0 — base (hecho)
- [x] `XT/pm.sh` (detect_os/arch/pm, pm_install/update/has)
- [x] `XT/pm-aliases.md`
- [x] `scripts/test-matrix.sh`
- [x] nodejs, zig, scala, swift (arm64 + JHIN_BASE)
- [x] nodejs: fallback Alpine (apk nodejs npm — tarball glibc no corre en musl)
- [x] `pm.sh`: fixup `archive.debian.org` para deb10 (buster EOL)
- [x] `test-matrix.sh`: runner `sh` (Alpine sin bash) + bootstrap buster

### Lote 1 — paquete distro puro (fácil: solo pm_install + nombre por distro)
- [x] git, jq, tmux, vim (mismo nombre) — 30/30 en apt/dnf/apk
- [x] cpp, lua, ruby, elixir, sql, redis (nombre por distro) — 30/30 en apt/dnf/apk
- [x] java, r, mysql, postgres (JDK/R/cliente-mariadb/postgresql por PM) — 12/12 apt/dnf/apk

### Lote 2 — script oficial auto-arch (curl|bash, multi-distro casi gratis)
- [x] rust, bun, deno, haskell — deb12/fedora OK. Alpine: rust ✅ (build-base),
      bun ✅ (+libstdc++ libgcc), haskell ✅ (+gcompat), deno ✅ (apk community musl).

### Lote 3 — binario/tarball con arch en URL
- [x] go — `dpkg`→`$JHIN_ARCH` + `grep -oP`→`-oE` (busybox) — deb12/fedora/alpine + arm64 OK
- [x] gotty (uname→`$JHIN_ARCH`), kotlin (JRE por distro + `grep -oP`→`-oE`) — deb12/fedora/alpine OK
- [x] typescript, prisma (nodejs por distro/jhin) — deb12/fedora/alpine OK
- [x] python (compila CPython; deps build por distro + `grep -oP`→`-oE`) — deb12/fedora/alpine OK

### Lote 4 — repos de terceros (lo más duro; rama por PM)
- [x] tailscale (tgz), terraform (zip), dotnet (dotnet-install.sh) — binario/script cross-distro
- [x] docker (get.docker.com + apk alpine, DinD intacto) — deb12/fedora/alpine OK (cliente)
- [x] crystal (install.sh deb/fedora + apk alpine), php (php-cli por distro) — deb12/fedora/alpine OK
- [x] dart (SDK zip multi-arch; Alpine vía gcompat+libstdc++), vscode (apt+dnf MS),
      mongodb (apt+dnf mongo) — deb12/fedora OK; vscode/mongodb alpine ❌ (glibc)

---

## Notas de incompatibilidad conocidas

- **Alpine (musl)**: swift (toolchain glibc, sin build musl oficial ni paquete
  apk) y mongodb/mongosh (binario glibc; gcompat no aporta los símbolos del
  resolver `__res_nsearch`/`__dn_expand` y segfaultea con la shim de glibc) →
  ❌ con motivo, no forzar. **vscode** sí: en Alpine se instala code-server
  (mismo editor en navegador) con el tarball oficial + el node musl de Alpine
  (se reemplaza el node glibc del bundle) — verificado: el servidor HTTP
  arranca y sirve el workbench. **deno** sí (paquete community musl), **dart**
  sí (SDK glibc + `gcompat`+`libstdc++`, corre y compila), **crystal** sí
  (paquete community).
- **deb10 (buster)**: php-sury dejó de publicar; hashicorp/google idem →
  ❌ esperables en varios Lote 4.
- **arm64**: tools que son solo "paquete distro" (➖) heredan el soporte arm64
  del repo de la distro — funcionan sin cambios. Los de binario/tarball
  necesitan detección de arch explícita (`$JHIN_ARCH`).

## Metodología de validación

- **Directo**: deb12 (apt), fedora:40 (dnf), alpine:3.20 (apk) — los 3 package
  managers. amd64.
- **Barrido baseline**: los 37 instaladores corren en `debian:12/amd64` —
  37/37 OK en un solo sweep (verificación definitiva del baseline).
- **Familia Debian** (deb10/deb11/deb13/kali/ubuntu): los ✅ de tools
  "paquete distro" se validaron **representativamente** con `git` (same-name) +
  `cpp` (deps por distro), que ejercitan el mismo path `pm_update`+`pm_install`.
  No se re-corrió cada tool en cada variante Debian.
- **deb10/buster**: `git` y `cpp` OK vía `archive.debian.org` (fixup en `pm.sh`).
- **kali-rolling**: `git` dio 404 transitorio (índice con `.deb` ya rotado);
  `cpp` OK. Mitigado con `Acquire::Retries=3` en `pm.sh`. Marcado ⚠️.
- **arm64**: validado **nativo en oracle** (aarch64, Ubuntu 20.04, docker sin
  qemu) — 15/15 en `debian:12/arm64`: nodejs, zig, scala, swift, go, gotty,
  rust, bun, deno, haskell, kotlin, tailscale, terraform, dotnet, dart. Los
  tools "paquete distro" (➖) heredan arm64 del repo de la distro.
- **arm64 + musl** (oracle nativo): 14/14 en `alpine:3.20/arm64` — git, cpp,
  nodejs, zig, go, rust, bun, haskell, crystal, docker, php, tailscale,
  terraform, dotnet. El combo más difícil (musl + arm64) pasa entero.
- **Hallazgos musl (Alpine)** — estrategias por tool:
  - **estático/musl-nativo**: zig, go, gotty, tailscale, terraform (corren sin más).
  - **+libs runtime**: bun (+libstdc++ libgcc), haskell (+gcompat), dotnet (+icu-libs).
  - **paquete community musl**: nodejs (apk nodejs), deno (apk deno), crystal (apk crystal).
  - **gcompat (shim glibc, verificado que corre/compila)**: dart.
  - **tarball + node musl de Alpine (se reemplaza el node glibc del bundle)**:
    vscode→code-server (4.100.x, última serie Node 20; arranca y sirve HTTP).
  - **sin camino musl → ❌**: swift (toolchain glibc, sin apk ni build community),
    mongodb/mongosh (binario glibc; gcompat sin `__res_nsearch`/`__dn_expand`,
    glibc-shim segfaultea; el npm crashea por bindings nativos; apk sólo trae
    `mongodb-tools` = dump/export, no shell interactivo).
