# dotfiles

Automatización de los dotfiles para Ubuntu 26.04 amd64. El único punto de
entrada implementado es `install.sh`.

## Perfil base

El perfil `base` actualiza los índices de APT e instala únicamente `curl` y
`wget` cuando falten. No configura estas herramientas ni modifica archivos de
usuario.

Ejecutar la instalación:

```bash
bash install.sh --non-interactive --profile base --yes
```

Requiere Ubuntu 26.04 amd64. APT solicita privilegios de administrador para
actualizar sus índices e instalar paquetes. El menú, otros perfiles,
desinstalación y actualización del clon están planificados.

## Validación

La definición de la imagen y su `entrypoint` están en `.docker/`. `make`
ejecuta `docker build` y Docker reutiliza las capas sin cambios; el contexto se
limita a `.docker/`. Después monta el checkout actual en solo lectura en
`/root/.dotfiles` dentro de un contenedor efímero. El `entrypoint` invoca
exclusivamente `install.sh` dos veces y comprueba que `curl` y `wget` quedan
disponibles:

```bash
make validate
```

Para ejecutar únicamente el análisis estático y sintáctico:

```bash
make lint
```

Para abrir una terminal manual en el mismo entorno Docker:

```bash
make shell
```

Dentro del contenedor, ejecutar:

```bash
bash /root/.dotfiles/install.sh --non-interactive --profile base --yes
```
