# Checklist multiplataforma jhin

Objetivo: cada instalador funciona en **Debian 10/11/12/13, Kali, Ubuntu,
Alpine, Fedora** × **amd64 + arm64**.

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
| **nodejs** | tarball nodejs.org (arch en URL) | ⬜ | ⬜ | ✅ | ✅ | ⬜ | ⬜ | 🟡 | 🟡 | ✅ |
| **zig** | tarball ziglang.org (arch en URL) | ⬜ | ⬜ | ✅ | ✅ | ⬜ | ⬜ | 🟡 | 🟡 | ✅ |
| **scala** | coursier (cs nativo amd64 / JAR arm64) | ⬜ | ⬜ | ✅ | ✅ | ⬜ | ⬜ | 🟡 | 🟡 | ✅ |
| **swift** | tarball swift.org (glibc, Ubuntu build) | ⬜ | ⬜ | ✅ | ⚠️ | ⬜ | ⬜ | ❌ musl | ⚠️ | ✅ |
| **go** | tarball go.dev (arch en URL) | ⬜ | ⬜ | 🟡 | 🟡 | ⬜ | ⬜ | 🟡 | 🟡 | ⚠️ usa dpkg |
| **gotty** | binario github (arch en URL) | ⬜ | ⬜ | 🟡 | 🟡 | ⬜ | ⬜ | 🟡 | 🟡 | 🟡 |
| **rust** | rustup.rs (script, auto-arch) | 🟡 | 🟡 | ✅ | 🟡 | 🟡 | 🟡 | ✅ | ✅ | 🟡 |
| **bun** | bun.sh/install (script, auto-arch) | 🟡 | 🟡 | ✅ | 🟡 | 🟡 | 🟡 | ✅ | ✅ | 🟡 |
| **deno** | deno.land/install (script, auto-arch) | 🟡 | 🟡 | ✅ | 🟡 | 🟡 | 🟡 | ❌ | ✅ | 🟡 |
| **haskell** | ghcup (script, auto-arch) | 🟡 | 🟡 | ✅ | 🟡 | 🟡 | 🟡 | ✅ | ✅ | 🟡 |
| **kotlin** | zip github (JVM, arch-indep) | ⬜ | ⬜ | 🟡 | 🟡 | ⬜ | ⬜ | 🟡 | 🟡 | 🟡 |
| **crystal** | install.sh (apt/yum interno) | ⬜ | ⬜ | 🟡 | 🟡 | ⬜ | ⬜ | ❌ | 🟡 | ⚠️ |
| **cpp** | paquete distro (build-essential/clang) | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ➖ |
| **git** | paquete distro | ✅ | ✅ | ✅ | ✅ | ⚠️ | ✅ | ✅ | ✅ | ➖ |
| **jq** | paquete distro | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ➖ |
| **tmux** | paquete distro | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ➖ |
| **vim** | paquete distro | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ➖ |
| **java** | paquete distro (default-jdk/openjdk) | ⬜ | ⬜ | 🟡 | 🟡 | ⬜ | ⬜ | 🟡 | 🟡 | ➖ |
| **lua** | paquete distro (lua5.4) | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ➖ |
| **ruby** | paquete distro (ruby-full) | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ➖ |
| **r** | paquete distro (r-base) | ⬜ | ⬜ | 🟡 | 🟡 | ⬜ | ⬜ | 🟡 | 🟡 | ➖ |
| **elixir** | paquete distro (elixir) | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ➖ |
| **sql** | paquete distro (sqlite3) | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ➖ |
| **redis** | paquete distro (redis) | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ➖ |
| **mysql** | cliente distro (mariadb-client) | ⬜ | ⬜ | 🟡 | 🟡 | ⬜ | ⬜ | 🟡 | 🟡 | ➖ |
| **postgres** | paquete distro (postgresql) | ⬜ | ⬜ | 🟡 | 🟡 | ⬜ | ⬜ | 🟡 | 🟡 | ➖ |
| **python** | compila CPython desde fuente | ⬜ | ⬜ | 🟡 | 🟡 | ⬜ | ⬜ | ⚠️ | 🟡 | 🟡 |
| **typescript** | npm -g (requiere nodejs) | ⬜ | ⬜ | 🟡 | 🟡 | ⬜ | ⬜ | 🟡 | 🟡 | ➖ |
| **prisma** | npm -g (requiere nodejs) | ⬜ | ⬜ | 🟡 | 🟡 | ⬜ | ⬜ | 🟡 | 🟡 | ➖ |
| **docker** | .deb + binarios estáticos | ⬜ | ⬜ | 🟡 | 🟡 | ⬜ | ⬜ | ⚠️ | ⚠️ | ⚠️ |
| **tailscale** | repo apt/dnf/apk + binario estático | ⬜ | ⬜ | 🟡 | 🟡 | ⬜ | ⬜ | ⚠️ | ⚠️ | ⚠️ |
| **terraform** | repo hashicorp + zip estático | ⬜ | ⬜ | 🟡 | 🟡 | ⬜ | ⬜ | ⚠️ | ⚠️ | ⚠️ |
| **dotnet** | repo MS deb/dnf + dotnet-install.sh | ⬜ | ⬜ | 🟡 | 🟡 | ⬜ | ⬜ | ⚠️ | ⚠️ | ⚠️ |
| **vscode** | repo MS deb/dnf (Electron glibc) | ⬜ | ⬜ | 🟡 | 🟡 | ⬜ | ⬜ | ❌ musl | ⚠️ | ⚠️ |
| **dart** | repo apt Google (no fedora/alpine) | ⬜ | ⬜ | 🟡 | 🟡 | ⬜ | ⬜ | ❌ | ⚠️ | ⚠️ |
| **php** | repo sury (Debian) / remi (Fedora) | ❌ | ⬜ | 🟡 | 🟡 | ⬜ | ⬜ | ⚠️ | ⚠️ | ⚠️ |
| **mongodb** | repo apt/dnf mongodb (no alpine) | ⬜ | ⬜ | 🟡 | 🟡 | ⬜ | ⬜ | ❌ | ⚠️ | ⚠️ |

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
- [ ] java, r, mysql, postgres (verify en stderr / setup de servidor — más cuidado)

### Lote 2 — script oficial auto-arch (curl|bash, multi-distro casi gratis)
- [x] rust, bun, deno, haskell — deb12/fedora OK. Alpine: rust ✅ (build-base),
      bun ✅ (+libstdc++ libgcc), haskell ✅ (+gcompat), deno ❌ (solo binario glibc).

### Lote 3 — binario/tarball con arch en URL
- [ ] go (cambiar `dpkg --print-architecture` → `$JHIN_ARCH`)
- [ ] gotty, kotlin (deps por distro)
- [ ] python (compila; deps build por distro), typescript, prisma (post-nodejs)

### Lote 4 — repos de terceros (lo más duro; rama por PM)
- [ ] docker, tailscale, terraform (tienen binario estático → preferirlo cross-distro)
- [ ] dotnet (dotnet-install.sh script), vscode (deb/dnf, no alpine)
- [ ] dart, php, mongodb, crystal (apt-only o per-distro complejo)

---

## Notas de incompatibilidad conocidas

- **Alpine (musl)**: swift, vscode, dart, mongodb, crystal → builds glibc, no
  corren en musl. Marcar ❌ con motivo, no forzar.
- **deb10 (buster)**: php-sury dejó de publicar; hashicorp/google idem →
  ❌ esperables en varios Lote 4.
- **arm64**: tools que son solo "paquete distro" (➖) heredan el soporte arm64
  del repo de la distro — funcionan sin cambios. Los de binario/tarball
  necesitan detección de arch explícita (`$JHIN_ARCH`).

## Metodología de validación

- **Directo**: deb12 (apt), fedora:40 (dnf), alpine:3.20 (apk) — los 3 package
  managers. amd64.
- **Familia Debian** (deb10/deb11/deb13/kali/ubuntu): los ✅ de tools
  "paquete distro" se validaron **representativamente** con `git` (same-name) +
  `cpp` (deps por distro), que ejercitan el mismo path `pm_update`+`pm_install`.
  No se re-corrió cada tool en cada variante Debian.
- **deb10/buster**: `git` y `cpp` OK vía `archive.debian.org` (fixup en `pm.sh`).
- **kali-rolling**: `git` dio 404 transitorio (índice con `.deb` ya rotado);
  `cpp` OK. Mitigado con `Acquire::Retries=3` en `pm.sh`. Marcado ⚠️.
- **arm64**: validado nativo-vía-qemu solo para Lote 0 (nodejs/zig/scala/swift).
  Lote 2 (scripts auto-arch) marcado 🟡: el script baja el binario arm64 correcto
  pero falta correrlo. Validación nativa pendiente en oracle.
- **Hallazgos musl (Alpine)**: zig (estático) y rust/haskell/bun corren con las
  libs runtime correctas; nodejs y deno NO (solo binario glibc) → fallback apk
  (nodejs) o ❌ (deno).
