# Delta entre `.old` y el sistema nuevo

Este documento resume, de forma rápida, qué partes del sistema antiguo siguen sin portarse, qué piezas conviene dejar fuera por la nueva filosofía y qué ya está absorbido por el árbol actual.

La referencia antigua está en [.old/README.md](.old/README.md) y [.old/README-es.md](.old/README-es.md). La base nueva vive en [README.md](README.md) y en [bootstrap.sh](bootstrap.sh).

> [!IMPORTANT]
> Cada paso que se complete debe eliminarse de este archivo y, además, debe borrarse el código o fichero específico correspondiente dentro de `.old`.

## Resumen rápido pendiente

Ordenado por prioridad práctica y por valor para bootstrap:

1. Instalar Oh My Zsh si no está ya presente y preparar extensiones/plugins iniciales para la terminal.
2. Portar la gestión inicial de repositorios Git desde [.old/scripts/initialize_git_repository.sh](.old/scripts/initialize_git_repository.sh).
3. Portar la creación y selección de claves SSH desde [.old/scripts/set_github_ssh_key.sh](.old/scripts/set_github_ssh_key.sh).
4. Portar la configuración de terminal GNOME desde [.old/scripts/preferences/ubuntu/terminal.sh](.old/scripts/preferences/ubuntu/terminal.sh).
5. Portar la configuración visual de GNOME desde [.old/scripts/preferences/ubuntu/interface.sh](.old/scripts/preferences/ubuntu/interface.sh).
6. Portar la activación y ajuste de extensiones GNOME desde [.old/scripts/preferences/ubuntu/extensions.sh](.old/scripts/preferences/ubuntu/extensions.sh).
7. Portar la instalación de GNOME Extensions CLI desde [.old/scripts/installs/ubuntu/extensions.sh](.old/scripts/installs/ubuntu/extensions.sh).
8. Portar el ajuste de Wayland desde [.old/scripts/preferences/ubuntu/wayland.sh](.old/scripts/preferences/ubuntu/wayland.sh).
9. Separar la instalación Ubuntu antigua en piezas equivalentes: [.old/scripts/installs/ubuntu/build-essentials.sh](.old/scripts/installs/ubuntu/build-essentials.sh), [.old/scripts/installs/ubuntu/devtools.sh](.old/scripts/installs/ubuntu/devtools.sh), [.old/scripts/installs/ubuntu/python.sh](.old/scripts/installs/ubuntu/python.sh), [.old/scripts/installs/ubuntu/node.sh](.old/scripts/installs/ubuntu/node.sh), [.old/scripts/installs/ubuntu/misc.sh](.old/scripts/installs/ubuntu/misc.sh), [.old/scripts/installs/ubuntu/cleanup.sh](.old/scripts/installs/ubuntu/cleanup.sh) y [.old/scripts/installs/ubuntu/utils.sh](.old/scripts/installs/ubuntu/utils.sh).

## Falta portar

### Preferencias GNOME y escritorio

El bloque más claro que sigue sin portar es el de preferencias de escritorio. En `.old` estaba repartido entre:

- [.old/scripts/preferences/ubuntu/interface.sh](.old/scripts/preferences/ubuntu/interface.sh)
- [.old/scripts/preferences/ubuntu/terminal.sh](.old/scripts/preferences/ubuntu/terminal.sh)
- [.old/scripts/preferences/ubuntu/extensions.sh](.old/scripts/preferences/ubuntu/extensions.sh)
- [.old/scripts/preferences/ubuntu/set_terminal_theme.sh](.old/scripts/preferences/ubuntu/set_terminal_theme.sh)
- [.old/scripts/preferences/ubuntu/wayland.sh](.old/scripts/preferences/ubuntu/wayland.sh)

En el sistema nuevo solo hay una adaptación puntual de GNOME para Flameshot en [scripts/install-flameshot.sh](scripts/install-flameshot.sh).

### Flujo SSH y Git inicial

El árbol viejo incluía automatización para la identidad Git y las claves SSH en:

- [.old/scripts/initialize_git_repository.sh](.old/scripts/initialize_git_repository.sh)
- [.old/scripts/set_github_ssh_key.sh](.old/scripts/set_github_ssh_key.sh)

En el nuevo sistema sí existe gestión de perfiles de Git en [src/zsh/functions/git.zsh](src/zsh/functions/git.zsh), y el contexto de usuarios se documenta en [README.md](README.md), pero no veo portado el flujo de creación/gestión de claves.

### Actualización y reinicio

El sistema antiguo separaba actualización y reinicio en:

- [.old/scripts/update.sh](.old/scripts/update.sh)
- [.old/scripts/update_content.sh](.old/scripts/update_content.sh)
- [.old/scripts/restart.sh](.old/scripts/restart.sh)

En el sistema nuevo hay un alias de actualización en [src/zsh/aliases.zsh](src/zsh/aliases.zsh), pero todavía apunta al flujo antiguo y no al nuevo bootstrap.

### Instalación Ubuntu más granular

El árbol viejo dividía la instalación en muchos scripts pequeños bajo [.old/scripts/installs/ubuntu/](.old/scripts/installs/ubuntu/), por ejemplo:

- [.old/scripts/installs/ubuntu/build-essentials.sh](.old/scripts/installs/ubuntu/build-essentials.sh)
- [.old/scripts/installs/ubuntu/devtools.sh](.old/scripts/installs/ubuntu/devtools.sh)
- [.old/scripts/installs/ubuntu/python.sh](.old/scripts/installs/ubuntu/python.sh)
- [.old/scripts/installs/ubuntu/node.sh](.old/scripts/installs/ubuntu/node.sh)
- [.old/scripts/installs/ubuntu/misc.sh](.old/scripts/installs/ubuntu/misc.sh)
- [.old/scripts/installs/ubuntu/cleanup.sh](.old/scripts/installs/ubuntu/cleanup.sh)
- [.old/scripts/installs/ubuntu/utils.sh](.old/scripts/installs/ubuntu/utils.sh)

Parte de eso parece haber sido concentrada en [scripts/install-packages.sh](scripts/install-packages.sh), pero no existe una migración completa 1:1.

## Mejor dejar fuera

### Wayland forzado a desactivado

El comportamiento de [.old/scripts/preferences/ubuntu/wayland.sh](.old/scripts/preferences/ubuntu/wayland.sh) encaja mal con una base nueva que asume Ubuntu limpio y más estándar. Si se mantiene, conviene hacerlo como ajuste opcional, no como parte del flujo principal.

### Extensiones GNOME automáticas

La automatización agresiva de GNOME en [.old/scripts/preferences/ubuntu/interface.sh](.old/scripts/preferences/ubuntu/interface.sh), [.old/scripts/preferences/ubuntu/extensions.sh](.old/scripts/preferences/ubuntu/extensions.sh) y [.old/scripts/installs/ubuntu/extensions.sh](.old/scripts/installs/ubuntu/extensions.sh) parece demasiado opinada para la filosofía nueva, salvo que queráis una workstation muy cerrada.

### SSH por máquina

La generación y selección de claves SSH de [.old/scripts/set_github_ssh_key.sh](.old/scripts/set_github_ssh_key.sh) y el flujo asociado de [.old/scripts/initialize_git_repository.sh](.old/scripts/initialize_git_repository.sh) pueden quedar fuera si la idea es no tocar secretos ni identidad local durante bootstrap.

### Bootstrap remoto antiguo

El arranque antiguo de [.old/scripts/setup.sh](.old/scripts/setup.sh) queda reemplazado por [bootstrap.sh](bootstrap.sh). No merece portarse como compatibilidad.

## Ya portado o absorbido

### Orquestación y bootstrap

La nueva base ya vive en [bootstrap.sh](bootstrap.sh), con apoyo en [core/config.sh](core/config.sh), [core/platform.sh](core/platform.sh), [core/runner.sh](core/runner.sh), [core/output.sh](core/output.sh), [core/plan.sh](core/plan.sh) y [core/symlink.sh](core/symlink.sh).

### Directorios, symlinks y templates

El viejo bloque de creación y enlace está ahora repartido entre:

- [scripts/create-directories.sh](scripts/create-directories.sh)
- [scripts/link-dotfiles.sh](scripts/link-dotfiles.sh)
- [scripts/init-templates.sh](scripts/init-templates.sh)
- [templates/common.template](templates/common.template)
- [templates/config.template](templates/config.template)
- [templates/git-users.template](templates/git-users.template)

### Fuentes

La instalación de fuentes ya quedó portado en [scripts/install-fonts.sh](scripts/install-fonts.sh) y está integrado en [bootstrap.sh](bootstrap.sh). La carpeta destino se prepara desde [scripts/create-directories.sh](scripts/create-directories.sh) y el script realiza la comprobación de instalación, la descarga mínima necesaria y la regeneración final de la caché de fuentes.

### Shell y terminal

La base de zsh está en:

- [scripts/install-zsh.sh](scripts/install-zsh.sh)
- [src/zsh/zshrc](src/zsh/zshrc)
- [src/zsh/zshenv](src/zsh/zshenv)
- [src/zsh/zshopt](src/zsh/zshopt)
- [src/zsh/styles.zsh](src/zsh/styles.zsh)
- [src/zsh/aliases.zsh](src/zsh/aliases.zsh)
- [src/zsh/functions/git.zsh](src/zsh/functions/git.zsh)
- [src/zsh/functions/docker.zsh](src/zsh/functions/docker.zsh)
- [src/zsh/functions/dotfiles.zsh](src/zsh/functions/dotfiles.zsh)

### Instaladores ya existentes

Ya hay scripts específicos para:

- [scripts/install-packages.sh](scripts/install-packages.sh)
- [scripts/install-docker.sh](scripts/install-docker.sh)
- [scripts/install-vscode.sh](scripts/install-vscode.sh)
- [scripts/install-postman.sh](scripts/install-postman.sh)
- [scripts/install-chrome.sh](scripts/install-chrome.sh)
- [scripts/install-brave-origin.sh](scripts/install-brave-origin.sh)
- [scripts/install-flameshot.sh](scripts/install-flameshot.sh)
- [scripts/install-lsd.sh](scripts/install-lsd.sh)
- [scripts/install-starship.sh](scripts/install-starship.sh)

### Agentes IA

El árbol de agentes es superficie nueva y no parece venir del backup antiguo:

- [src/agents/claude/CLAUDE.md](src/agents/claude/CLAUDE.md)
- [src/agents/codex/AGENTS.md](src/agents/codex/AGENTS.md)
- [src/agents/copilot/copilot-instructions.md](src/agents/copilot/copilot-instructions.md)
- [src/agents/copilot/settings.json](src/agents/copilot/settings.json)
- [src/agents/claude/settings.json](src/agents/claude/settings.json)
- [src/agents/codex/config.toml](src/agents/codex/config.toml)
- [src/agents/shared/agent-guidelines.md](src/agents/shared/agent-guidelines.md)
- [src/agents/shared/skills/dotfiles-development/SKILL.md](src/agents/shared/skills/dotfiles-development/SKILL.md)
- [src/agents/shared/skills/api-development/SKILL.md](src/agents/shared/skills/api-development/SKILL.md)
- [src/agents/shared/skills/architecture-review/SKILL.md](src/agents/shared/skills/architecture-review/SKILL.md)
- [src/agents/shared/skills/python-development/SKILL.md](src/agents/shared/skills/python-development/SKILL.md)
- [src/agents/shared/skills/python-code-review/SKILL.md](src/agents/shared/skills/python-code-review/SKILL.md)
- [src/agents/shared/skills/testing-and-validation/SKILL.md](src/agents/shared/skills/testing-and-validation/SKILL.md)

## Resumen corto

Si hubiera que priorizar, los huecos reales son: GNOME/desktop, SSH/Git inicial y, si se quiere, una revisión del flujo de update. Lo que más encaja con la filosofía nueva es dejar fuera Wayland forzado, extensiones GNOME automáticas y la gestión de claves SSH como parte del bootstrap principal.
