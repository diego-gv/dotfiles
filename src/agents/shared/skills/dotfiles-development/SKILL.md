---
name: dotfiles-development
description: Úsala para implementar, modificar, revisar u organizar dotfiles, scripts de bootstrap, flujos de instalación o automatización de provisión de entorno. Prioriza simplicidad, idempotencia, compatibilidad de plataforma y manejo seguro de symlinks.
---

# Dotfiles Development

## Cuándo usar esta skill

Utilízala para cambios en `bootstrap.sh`, `core/`, `scripts/`, `src/` y `templates/` cuando afecten instalación, enlaces simbólicos, configuración de shell o configuración global de agentes.

## Objetivo de la skill

Mantener este repositorio de dotfiles como base reproducible para Linux/Ubuntu, con scripts idempotentes, responsabilidades claras por capa y configuración global de agentes segura.

## Checklist de ejecución

- Confirmar alcance con la arquitectura real descrita en `AGENTS.md` y `README.md`.
- Identificar capa afectada: `bootstrap.sh`, `core/`, `scripts/`, `src/` o `templates/`.
- Reutilizar `core/symlink.sh` para symlinks y evitar lógica duplicada en scripts.
- Mantener idempotencia: no sobrescribir sin backup, no duplicar efectos, no romper re-ejecución.
- En configuración de agentes, enlazar solo archivos/recursos explícitos (no carpetas completas de estado local de herramienta).
- Ejecutar validación mínima: `bash -n` sobre scripts tocados y checks del `Makefile` si aplican.

## Principios

- Simplicidad primero: cambios pequeños, directos y con responsabilidad única.
- Seguridad e idempotencia por defecto: ejecutar varias veces no debe romper el entorno.
- Consistencia estructural: respetar separación entre `bootstrap.sh`, `core/`, `scripts/`, `src/` y `templates/`.
- Configuración personal global en `src/agents/`: no asumir reglas específicas de un repo externo.

## Estructura esperada

```text
bootstrap.sh
core/
  config.sh
  output.sh
  plan.sh
  platform.sh
  runner.sh
  symlink.sh
scripts/
  install-*.sh
  create-directories.sh
  link-dotfiles.sh
  init-templates.sh
  test-runner.sh
src/
  agents/
    claude/
    codex/
    copilot/
    shared/
templates/
```

## Flujo actual de bootstrap

El flujo actual en `bootstrap.sh` está organizado por etapas y delega ejecución a scripts concretos:

- Bootstrap/System: `scripts/install-packages.sh`.
- Terminal tools: `scripts/install-zsh.sh`, `scripts/install-lsd.sh`, `scripts/install-starship.sh`.
- Developer tools: `scripts/install-docker.sh`, `scripts/install-vscode.sh`, `scripts/install-postman.sh`.
- Browsers/Desktop: `scripts/install-chrome.sh`, `scripts/install-brave-origin.sh`, `scripts/install-flameshot.sh`.
- Final touches: `scripts/create-directories.sh`, `scripts/link-dotfiles.sh`, `scripts/init-templates.sh`.

## Reglas para `bootstrap.sh`

Usar `bootstrap.sh` solo como orquestador.

Debe:

- Calcular `ROOT_DIR`.
- Cargar módulos de `core/`.
- Detectar plataforma.
- Construir y ejecutar el plan de etapas/pasos.
- Delegar acciones concretas a `scripts/`.

No debe:

- Instalar paquetes directamente.
- Crear symlinks directamente.
- Contener lógica específica de herramientas concretas.

## Reglas para `core/`

Usar `core/` para lógica reutilizable.

Responsabilidades recomendadas:

```text
core/config.sh     variables globales del instalador
core/output.sh     formato visual y mensajes
core/plan.sh       definición y ejecución de etapas/pasos
core/runner.sh     ejecución controlada de comandos
core/platform.sh   detección de SO, distro, versión y arquitectura
core/symlink.sh    helpers para symlinks seguros e idempotentes
```

Las variables globales deben usar prefijo:

```bash
DOTFILES_
```

Ejemplo:

```bash
DOTFILES_TOTAL_STEPS=7
DOTFILES_PREVIEW_LINES=5
DOTFILES_OS=""
DOTFILES_DISTRO=""
```

Evitar nombres genéricos como:

```bash
TOTAL_STEPS
CURRENT_STEP
VERSION
CONFIG
```

## Reglas para `scripts/`

Cada script debe hacer una sola cosa.

Nombres recomendados:

```text
install-zsh.sh
install-starship.sh
install-vscode.sh
install-chrome.sh
install-packages.sh
create-directories.sh
link-dotfiles.sh
init-templates.sh
```

Cada script debe poder ejecutarse desde `bootstrap.sh` y, si tiene sentido, también de forma aislada.

Evitar scripts gigantes tipo:

```text
install-everything.sh
setup-all.sh
```

## Reglas para Bash

Usar Bash cuando el script dependa de Bash.

Cabecera recomendada:

```bash
#!/usr/bin/env bash
set -euo pipefail
```

Citar variables salvo cuando haya una razón clara para no hacerlo.

Preferir:

```bash
"$ROOT_DIR/scripts/install-zsh.sh"
```

a:

```bash
$ROOT_DIR/scripts/install-zsh.sh
```

Usar funciones con nombres descriptivos.

Evitar lógica oculta, expansiones frágiles y comandos destructivos sin validación previa.

## Idempotencia

Todo script de instalación debe ser seguro al ejecutarse varias veces.

Antes de crear, instalar o modificar algo, comprobar si ya existe.

Ejemplos:

```bash
command -v zsh >/dev/null 2>&1
[[ -L "$HOME/.zshrc" ]]
[[ -f "$HOME/.ssh/config" ]]
```

No duplicar líneas en ficheros de configuración.

No sobrescribir ficheros del usuario sin backup o confirmación explícita.

## Symlinks

Los dotfiles versionados viven en `src/`.

La creación de enlaces debe centralizarse en `scripts/link-dotfiles.sh` usando `ensure_safe_symlink` desde `core/symlink.sh`.

Antes de crear un symlink:

1. Comprobar si el destino existe.
2. Si ya es el symlink correcto, no hacer nada.
3. Si existe y no es symlink correcto, crear backup.
4. Crear el enlace.

No enlazar secretos reales desde el repositorio.

Para configuración de agentes, enlazar recursos explícitos de configuración (por ejemplo, `CLAUDE.md`, `AGENTS.md`, `copilot-instructions.md`, `settings.json`, `agent-guidelines.md`, `skills/`, `agents/`, `rules/`, `prompts/`) y evitar enlazar carpetas completas de estado interno de herramientas.

## Mapa actual de agentes en este repo

La configuración global personal de agentes se organiza en:

- `src/agents/claude/`
- `src/agents/codex/`
- `src/agents/copilot/`
- `src/agents/shared/`

Enlaces de destino esperados en HOME:

- `~/.claude/`
- `~/.codex/`
- `~/.copilot/`
- `~/.agents/`

Skills compartidas:

- Fuente canónica en repo: `src/agents/shared/skills/`.
- Exposición de usuario: `~/.claude/skills` y `~/.agents/skills`.

## Templates y secretos

Los secretos no deben estar versionados.

Permitido:

```text
templates/common.template
templates/config.template
templates/git-users.template
```

No permitido:

```text
~/.secrets/common
~/.ssh/config
id_rsa
.env
tokens
```

Las plantillas deben contener placeholders claros.

## Plataforma

Centralizar la detección de sistema en:

```text
core/platform.sh
```

No duplicar detección de Ubuntu, Debian, macOS, arquitectura o versión en scripts individuales.

Usar variables como:

```bash
DOTFILES_OS
DOTFILES_DISTRO
DOTFILES_VERSION_ID
DOTFILES_CODENAME
DOTFILES_ARCH
```

Los scripts específicos de Ubuntu deben validar plataforma antes de ejecutar acciones.

## Instalación de paquetes

Agrupar paquetes base en:

```text
scripts/install-packages.sh
```

Crear scripts separados para herramientas que requieran repositorios externos, claves GPG, descargas `.deb` o configuración especial.

Ejemplos:

```text
install-vscode.sh
install-chrome.sh
install-starship.sh
```

## Errores

Fallar pronto ante errores críticos.

Mostrar mensajes claros que indiquen:

- Qué paso falló.
- Qué comando falló.
- Código de salida.
- Plataforma detectada si el error depende del sistema.

No ocultar errores con `|| true` salvo que sea intencional y esté justificado.

## Validación

Antes de proponer cambios finales, revisar:

- Que los scripts son idempotentes.
- Que las rutas están citadas.
- Que no se versionan secretos.
- Que no se duplica lógica de `core/`.
- Que los nombres son consistentes.
- Que el cambio encaja en la estructura actual.

Validaciones recomendadas:

- `bash -n bootstrap.sh` y scripts modificados.
- `make test` para validar en contenedor Docker aislado (ShellCheck + ejecución de `bootstrap.sh`).

Si existe `Makefile`, usarlo como interfaz pública de validación (`make test`) y entorno interactivo reproducible (`make run`).

## Entrega esperada

- Cambios mínimos, idempotentes y consistentes con la estructura actual.
- Riesgos y efectos secundarios explícitos.
- Validación reportada (sintaxis, checks y comandos ejecutados).

## Debug

Cuando esta skill se ejecute, añade al final de la respuesta:
[SKILL_DOTFILES_DEVELOPMENT_LOADED]
