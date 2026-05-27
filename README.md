# jhin

### One line, One solution

Copia funcional de [nyaweb/nya](https://github.com/nyaweb/nya) con i18n + verbose toggle. Cada archivo es un instalador shell que se aplica con `. <(curl -fsSL ...) [lang] [-v]`.

- **`lang`** — idioma de los mensajes (default: `es`). Strings cargados de [xtractor](https://github.com/monsterbunx/xtractor), coloreados con [klors](https://github.com/monsterbunx/klors).
- **`-v` / `--verbose`** — muestra la salida cruda de `apt`/`curl`/`dpkg`/`make` además de los mensajes traducidos. Sin `-v`, los comandos corren silenciados.

## Docker
```bash
. <(curl -fsSL https://monsterbunx.github.io/jhin/docker) es -v
```
Detecta DinD automáticamente: si corre dentro de un contenedor, configura `storage-driver=vfs` y arranca `dockerd` en background. Requiere `privileged: true` en el contenedor anfitrión.

## Go
```bash
. <(curl -fsSL https://monsterbunx.github.io/jhin/go) es -v
```

## NodeJs
```bash
. <(curl -fsSL https://monsterbunx.github.io/jhin/nodejs) es -v
```

## Python
```bash
. <(curl -fsSL https://monsterbunx.github.io/jhin/python) es -v
```

## PHP
```bash
. <(curl -fsSL https://monsterbunx.github.io/jhin/php) es -v
```

## Rust
```bash
. <(curl -fsSL https://monsterbunx.github.io/jhin/rust) es -v
```

## Ruby
```bash
. <(curl -fsSL https://monsterbunx.github.io/jhin/ruby) es -v
```

## Java (OpenJDK)
```bash
. <(curl -fsSL https://monsterbunx.github.io/jhin/java) es -v
```

## Kotlin
```bash
. <(curl -fsSL https://monsterbunx.github.io/jhin/kotlin) es -v
```

## .NET (dotnet SDK)
```bash
. <(curl -fsSL https://monsterbunx.github.io/jhin/dotnet) es -v
```

## Swift
```bash
. <(curl -fsSL https://monsterbunx.github.io/jhin/swift) es -v
```

## Elixir
```bash
. <(curl -fsSL https://monsterbunx.github.io/jhin/elixir) es -v
```

## Lua
```bash
. <(curl -fsSL https://monsterbunx.github.io/jhin/lua) es -v
```

## Deno
```bash
. <(curl -fsSL https://monsterbunx.github.io/jhin/deno) es -v
```

## Bun
```bash
. <(curl -fsSL https://monsterbunx.github.io/jhin/bun) es -v
```

---

## Tooling

### git
```bash
. <(curl -fsSL https://monsterbunx.github.io/jhin/git) es -v
```

### vim
```bash
. <(curl -fsSL https://monsterbunx.github.io/jhin/vim) es -v
```

### tmux
```bash
. <(curl -fsSL https://monsterbunx.github.io/jhin/tmux) es -v
```

### jq
```bash
. <(curl -fsSL https://monsterbunx.github.io/jhin/jq) es -v
```

### TypeScript (npm global, post-nodejs)
```bash
. <(curl -fsSL https://monsterbunx.github.io/jhin/typescript) es -v
```

### Terraform
```bash
. <(curl -fsSL https://monsterbunx.github.io/jhin/terraform) es -v
```

### PostgreSQL (server + client)
```bash
. <(curl -fsSL https://monsterbunx.github.io/jhin/postgres) es -v
```

---

## Más lenguajes

### R
```bash
. <(curl -fsSL https://monsterbunx.github.io/jhin/r) es -v
```

### Scala (Coursier)
```bash
. <(curl -fsSL https://monsterbunx.github.io/jhin/scala) es -v
```

### Haskell (GHCup)
```bash
. <(curl -fsSL https://monsterbunx.github.io/jhin/haskell) es -v
```

### Crystal
```bash
. <(curl -fsSL https://monsterbunx.github.io/jhin/crystal) es -v
```

### Zig
```bash
. <(curl -fsSL https://monsterbunx.github.io/jhin/zig) es -v
```

### Dart
```bash
. <(curl -fsSL https://monsterbunx.github.io/jhin/dart) es -v
```

### C/C++ (gcc + g++ + clang + make)
```bash
. <(curl -fsSL https://monsterbunx.github.io/jhin/cpp) es -v
```

## Arquitectura

```
jhin/<tool>            ← lógica de instalación (parsea args, llama a XT/<tool>, usa XT_*)
   ↓ source
jhin/XT/pm.sh          ← detecta OS/arch/PM; expone pm_install, pm_update, $JHIN_ARCH…
jhin/XT/<tool>         ← loader: trae klors + xtractor/<tool>/<lang>
   ↓ source
klors/klors            ← funciones c_red, c_ok, etc.
xtractor/<tool>/<lang> ← variables XT_TITLE, XT_DOWNLOAD, etc. (ya coloreadas)
```

Cada capa es sourceable vía `curl-pipe`, sin instalación previa.

## Multiplataforma (OS × arquitectura)

`XT/pm.sh` abstrae el package manager y la arquitectura, así un mismo
instalador corre en varias distros y arches:

- **OS**: Debian/Ubuntu (`apt`), Fedora/RHEL (`dnf`), Alpine (`apk`), Arch (`pacman`).
- **Arch**: `amd64` (x86_64) y `arm64` (aarch64). `$JHIN_ARCH` normaliza `uname -m`.

El mapa de nombres de paquetes entre distros está en [`XT/pm-aliases.md`](XT/pm-aliases.md).
No todos los tools soportan todo (ej. `swift` es glibc-only → no Alpine).

### Probar la matriz localmente

`scripts/test-matrix.sh` sourcea la copia **local** del repo (`JHIN_BASE=file://`)
dentro de contenedores efímeros, sin necesidad de publicar a Pages:

```sh
# cross-arch necesita binfmt una vez:
sg docker -c "docker run --rm --privileged tonistiigi/binfmt --install all"

TOOLS="nodejs zig" DISTROS="debian:13" ARCHES="amd64 arm64" scripts/test-matrix.sh
```

## Probar localmente

```sh
git clone git@github.com:monsterbunx/jhin.git
cd jhin
docker compose up -d        # debian:12 privileged + bind-mount ./scripts
docker exec -it jhin bash   # entra al contenedor
. <(curl -fsSL https://monsterbunx.github.io/jhin/go) es -v
```

## Añadir un idioma

Drop file en `xtractor/<app>/<lang>` con las mismas keys `XT_*` que `xtractor/<app>/es`. El loader `xt-<app>` cae back a `es` si el lang pedido no existe.
