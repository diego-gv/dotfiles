# AGENTS.md

## Rol

Actúa como agente técnico especializado en mantenimiento de dotfiles, automatización reproducible de estaciones de trabajo y configuración de entornos Linux/Ubuntu.

Tu función es evolucionar este repositorio manteniendo una estructura clara, segura, idempotente y consistente con la arquitectura real del proyecto.

## Objetivo del repositorio

Este proyecto configura un entorno de desarrollo personal a partir de una base reproducible de dotfiles, scripts de instalación y enlaces simbólicos.

Su propósito principal es:

- instalar dependencias y herramientas de desarrollo;
- configurar la shell, prompts y utilidades del sistema;
- centralizar la configuración versionada en `src/`;
- mantener la instalación segura y repetible;
- permitir que la misma base se aplique en un entorno nuevo con mínimo esfuerzo.

## Estructura actual del repositorio

```text
.
├── AGENTS.md
├── LICENSE
├── Makefile
├── README.md
├── bootstrap.sh
├── core/
│   ├── config.sh
│   ├── output.sh
│   ├── plan.sh
│   ├── platform.sh
│   ├── runner.sh
│   └── symlink.sh
├── scripts/
│   ├── install-brave-origin.sh
│   ├── install-chrome.sh
│   ├── install-docker.sh
│   ├── install-flameshot.sh
│   ├── install-lsd.sh
│   ├── install-packages.sh
│   ├── install-postman.sh
│   ├── install-starship.sh
│   ├── install-vscode.sh
│   ├── install-zsh.sh
│   ├── create-directories.sh
│   ├── link-dotfiles.sh
│   └── init-templates.sh
├── src/
│   ├── agents/
│   ├── bat/
│   ├── btop/
│   ├── fzf/
│   ├── git/
│   ├── starship/
│   └── zsh/
├── templates/
│   ├── common.template
│   ├── config.template
│   └── git-users.template
└── .gitignore (si existe en el repo local)
```

## Cómo interpretar este repositorio

### `bootstrap.sh`

Es el punto de entrada principal.

Debe actuar como orquestador y delegar la lógica concreta a `core/` y `scripts/`.

No debe:

- instalar paquetes directamente;
- crear symlinks directamente;
- contener lógica específica de una herramienta;
- mezclar responsabilidades de configuración y ejecución.

### `core/`

Contiene lógica reutilizable para la operación del instalador.

Los módulos reales del proyecto son:

- `core/config.sh`: variables globales del flujo de instalación.
- `core/output.sh`: mensajes y formato visual.
- `core/platform.sh`: detección de sistema operativo, arquitectura, distro y versión.
- `core/plan.sh`: gestión de etapas y pasos (si se usa en el flujo).
- `core/runner.sh`: ejecución controlada de comandos y de scripts.
- `core/symlink.sh`: utilidades para crear enlaces simbólicos seguros e idempotentes.

Las variables globales deben seguir el prefijo `DOTFILES_`.

### `scripts/`

Cada script debe tener una responsabilidad clara y concreta.

Ejemplos válidos:

- `install-zsh.sh`
- `install-starship.sh`
- `install-vscode.sh`
- `install-packages.sh`
- `create-directories.sh`
- `link-dotfiles.sh`
- `init-templates.sh`

En este repositorio no existen scripts gigantes de “todo en uno”; la preferencia es un diseño modular y granular.

### `src/`

Es la fuente de verdad de los dotfiles versionados.

Aquí viven los archivos que luego se enlazan al `$HOME` o a rutas de configuración del sistema. Ejemplos reales del repo:

- `src/zsh/`
- `src/git/gitconfig`
- `src/starship/starship.toml`
- `src/bat/config`
- `src/btop/btop.conf`

Las skills versionadas viven en `src/agents/skills/` como formato canónico compartido.

Para adaptarse al descubrimiento estándar de cada herramienta, el repo las expone mediante rutas de proyecto:

- `.claude/skills/` para Claude Code.
- `.agents/skills/` para Codex y GitHub Copilot.

En el sistema del usuario, los scripts enlazan esas mismas skills en:

- `~/.claude/skills/` para Claude Code.
- `~/.agents/skills/` para Codex y GitHub Copilot.

### `templates/`

Son plantillas de configuración.

Deben ser seguras y reutilizables, pero no deben contener secretos reales, tokens, claves privadas ni configuración sensible. El repositorio usa templates como base para generar archivos locales.

## Convenciones y reglas de trabajo

### 1. Simplicidad por encima de la sofisticación

Cuando haya varias soluciones válidas, priorizar:

1. simplicidad;
2. mantenibilidad;
3. explicitud;
4. seguridad;
5. consistencia con el proyecto actual.

No introducir abstracciones innecesarias ni dependencias nuevas sin necesidad clara.

### 2. Idempotencia

Todos los scripts deben ser seguros al ejecutarse varias veces.

Debe comprobarse antes de instalar, crear o modificar algo:

- si un comando ya está instalado;
- si un destino ya existe;
- si un enlace simbólico ya apunta a la ruta correcta;
- si un archivo debe protegerse con backup antes de sobrescribirse.

La instalación debe ser repetible, no destructiva.

### 3. Bash y scripting seguro

Usar Bash con convenciones estrictas:

```bash
#!/usr/bin/env bash
set -euo pipefail
```

- citar variables cuando haya riesgo de espacios o expansion issues;
- usar funciones descriptivas;
- evitar `|| true` salvo que sea una excepción bien justificada;
- fallar temprano con mensajes claros.

### 4. Symlinks y dotfiles

Los symlinks se gestionan desde scripts de `scripts/` y apuntan a archivos de `src/`.

Antes de crear un enlace:

1. comprobar si el destino ya existe;
2. si ya es el enlace correcto, no hacer nada;
3. si existe pero no es correcto, guardar backup cuando sea necesario;
4. crear el enlace de forma segura.

### 5. Plataforma

La detección del sistema debe centralizarse en `core/platform.sh`.

Se usan variables como:

- `DOTFILES_OS`
- `DOTFILES_DISTRO`
- `DOTFILES_VERSION`
- `DOTFILES_VERSION_ID`
- `DOTFILES_CODENAME`
- `DOTFILES_ARCH`

Los scripts específicos deben validar la plataforma antes de ejecutar acciones que dependan de Ubuntu/Linux, etc.

### 6. Secretos y configuración local

No versionar:

- claves SSH reales;
- tokens;
- `.env` reales;
- archivos con secretos del usuario;
- credenciales de proveedores.

Los templates deben contener placeholders bien identificados en lugar de valores reales.

## Organización del trabajo antes de modificar el repositorio

1. Identificar claramente la capa afectada: `core/`, `scripts/`, `src/` o `templates/`.
2. Reusar el patrón existente antes de crear lógica nueva.
3. Mantener el cambio pequeño y enfocado en el problema.
4. Evitar refactors colaterales no necesarios.
5. Verificar que el resultado sigue siendo idempotente y seguro.
6. Si se completa una tarea relevante del backlog o se cambia el estado del proyecto, actualizar `TODO.md` con la información nueva y eliminar o reordenar los puntos que ya estén resueltos.

## Criterio de validación

Antes de considerar un cambio final, comprobar:

- que la ruta es consistente con la estructura real del repo;
- que el script sigue siendo idempotente;
- que no se han añadido secretos ni artefactos locales;
- que la lógica reutiliza `core/` antes que duplicarse;
- que el nombre del script y su responsabilidad coinciden;
- que el cambio encaja en el flujo de `bootstrap.sh`.

Si existe `Makefile` o herramientas locales de validación, deben usarse cuando sean aplicables para comprobar sintaxis o ejecución básica.

Para este repositorio, el contrato público esperado de validación/ejecución en Docker es:

- `make test`: validación e instalación dentro de contenedor aislado.
- `make run`: shell interactiva en la misma imagen aislada para pruebas manuales.

## Diferencia entre `AGENTS.md` y `README.md`

Es importante que quede claro que ambos documentos cumplen roles diferentes:

### `AGENTS.md`

`AGENTS.md` es la guía de comprensión técnica del repositorio.

Debe contener información orientada a:

- cómo está organizado el proyecto;
- qué hace cada capa (`core/`, `scripts/`, `src/`, `templates/`);
- qué convenciones y protocolos siguen los scripts;
- cómo se interpreta la arquitectura real del repo;
- cómo deben comportarse usuarios, agentes o asistentes al tocar el proyecto;
- qué reglas de seguridad, idempotencia y mantener la estructura se deben seguir.

Este archivo es de referencia para que una IA o un desarrollador entienda el repositorio de forma precisa y no se base en suposiciones, documentación antigua o referencias obsoletas.

### `README.md`

`README.md` es la documentación pública y amigable del proyecto.

Debe presentar información orientada a usuarios y desarrolladores con un enfoque de onboarding, por ejemplo:

- resumen del proyecto y su propósito;
- instalación y ejecución;
- compatibilidad y requisitos;
- herramientas y configuraciones que instala;
- lista de capacidades y personalizaciones;
- configuración local mediante templates;
- aliases o comandos útiles;
- cómo probar el proyecto y validarlo;
- licencia y uso general.

Es la cara visible del repositorio y debe tener un estilo más atractivo, legible y orientado a la tarea de instalación y comprensión rápida.

## Mantenimiento de la documentación del repositorio

Tanto `AGENTS.md` como `README.md` en la raíz del repositorio deben mantenerse actualizados conforme el proyecto evolucione.

Esto incluye, entre otros casos:

- nuevas features y funcionalidades;
- cambios en la arquitectura o estructura del proyecto;
- arreglos y correcciones de comportamiento;
- nuevos protocolos de instalación o ejecución;
- cambios en rutas, scripts, plantillas o symlinks;
- ajustes en seguridad, idempotencia, configuración o procedimientos de mantenimiento.

La documentación debe reflejar el estado real del repositorio y no quedar desactualizada respecto al código o a la forma en que se opera el entorno.

## Skill específico

Para cambios relacionados con Bash, bootstrap, instalación, enlaces simbólicos y gestión de dotfiles, usar el skill:

```text
src/agents/skills/dotfiles-development/SKILL.md
```
