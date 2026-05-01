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

## Arquitectura

```
jhin/<tool>          ← lógica de instalación (parsea args, llama a xt-<tool>, usa XT_*)
   ↓ source
jhin/xt-<tool>       ← loader: trae klors + xtractor/<tool>/<lang>
   ↓ source
klors/klors          ← funciones c_red, c_ok, etc.
xtractor/<tool>/<lang> ← variables XT_TITLE, XT_DOWNLOAD, etc. (ya coloreadas)
```

Cada capa es sourceable vía `curl-pipe`, sin instalación previa.

## Probar localmente

```sh
git clone git@github.com:monsterbunx/jhin.git ~/proyectos/jhin
cd ~/proyectos/jhin
docker compose up -d        # debian:12 privileged + bind-mount ./scripts
docker exec -it jhin bash   # entra al contenedor
. <(curl -fsSL https://monsterbunx.github.io/jhin/go) es -v
```

## Añadir un idioma

Drop file en `xtractor/<app>/<lang>` con las mismas keys `XT_*` que `xtractor/<app>/es`. El loader `xt-<app>` cae back a `es` si el lang pedido no existe.
