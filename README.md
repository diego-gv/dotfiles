<!-- markdownlint-disable MD041 -->
<div align="center">
    <img src=".github/images/logo.png" alt="dotfiles" width="128"/>
</div>
<div align="center">
  <h1><i>dotfiles</i> ⚡ by <a href="https://github.com/diego-gv">diego-gv</a></h1>
  <strong>Configuración personalizada para 🐧 Linux (Ubuntu)</strong>
</div>
<br>
<p align="center">
  <a href="https://www.gnu.org/software/bash/"><img src="https://img.shields.io/badge/shell-bash-4EAA25?logo=gnu-bash&logoColor=white" alt="shell"/></a>
  <a href="https://ubuntu.com/"><img src="https://img.shields.io/badge/Ubuntu-E95420.svg?style=flat&logo=ubuntu&logoColor=white" alt="ubuntu"/></a>
  <a href="https://www.docker.com/"><img src="https://img.shields.io/badge/docker-2496ED.svg?style=flat&logo=docker&logoColor=white" alt="docker"/></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-750014.svg?style=flat&logoColor=white" alt="license"/></a>
</p>

Este repositorio contiene la base de configuración personal para un entorno de desarrollo reproducible en Linux/Ubuntu. Está pensado para instalar, enlazar y mantener la shell, los dotfiles y las herramientas más habituales de trabajo con una estructura modular, segura e idempotente.

> [!IMPORTANT]
> Este proyecto está pensado para automatizar la configuración de tu entorno personal y no debe ejecutarse sin entender el flujo que se va a desplegar. La instalación sigue un modelo claro de bootstrap + scripts + symlinks + plantillas locales.

## 🧩 Compatibilidad

- 🍊 Ubuntu: compatible con entornos Ubuntu/Linux de trabajo.
- 🐚 zsh: configuración principal de shell.
- 🐳 Docker: soporte para uso de contenedores dentro del flujo y validación.
- 🧰 Bash: base del scripting y ejecución del instalador.

## 🚀 Instalación

### Clonar el repositorio

```bash
git clone https://github.com/diego-gv/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

### Ejecutar la instalación

Desde la raíz del repositorio:

```bash
bash ./bootstrap.sh
```

### Qué hace la instalación

El flujo principal de `bootstrap.sh` realiza una secuencia ordenada:

- detecta la plataforma y distro;
- prepara la estructura general del entorno;
- instala paquetes base y herramientas clave;
- configura shell y prompt;
- aplica enlaces de dotfiles desde `src/`;
- genera o prepara archivos locales a partir de templates.

## ✨ Características instaladas y configuradas

### Shell y terminal

- `zsh` como shell principal.
- archivos de configuración bajo `src/zsh/`.
- `starship` como prompt moderno.
- `lsd` para una mejor visualización de archivos.
- `fzf`, `bat`, `btop` y `fastfetch` para productividad y observabilidad.

### Herramientas de desarrollo

- Docker y CLI asociada.
- VS Code.
- Postman.
- Google Chrome y Brave.
- Flameshot.

### Sistema de configuración

- estructura modular por capas: `core/`, `scripts/`, `src/`, `templates/`.
- idempotencia en la ejecución de scripts.
- detección de plataforma centralizada en `core/platform.sh`.
- gestión de symlinks y enlaces de configuración.
- skills de agente compartidas en `src/agents/skills/`, expuestas como `~/.claude/skills` y `~/.agents/skills`.

### Git y entorno local

- configuración de Git desde `src/git/gitconfig`.
- organización de usuarios y perfiles locales a partir de plantillas.
- preparación segura de rutas y archivos recomendados por el sistema.

## 🧩 Ficheros de configuración local mediante templates

El proyecto usa `templates/` como base para crear archivos locales sin comprometer secretos reales.

Los templates principales son:

- `templates/common.template`
- `templates/config.template`
- `templates/git-users.template`

Durante la ejecución del flujo, se preparan archivos del usuario como:

- `~/.secrets/common`
- `~/.ssh/config`
- `~/.config/git/users`

> [!WARNING]
> Nunca se debe versionar información sensible. Los templates deben permanecer neutros y seguros, con placeholders claros y sin tokens, claves ni secretos reales.

## 🔧 Alias y comandos útiles

La configuración añade algunos aliases y comandos de utilidad para facilitar la gestión del entorno.

Algunos de los disponibles en la configuración de zsh son:

```bash
ll='ls -laht'
ls='lsd --color=always --long --group-dirs first'
la='ls -a'
lt='ls -t --reverse'
cat='batcat'
top='btop'
system='fastfetch'
grepi='grep -i'
up="bash ${HOME}/.dotfiles/update.sh"
clear-cache="sudo sh -c 'echo 3 > /proc/sys/vm/drop_caches'"
clear-ram="sudo sysctl -w vm.drop_caches=3"
```

Estos aliases ayudan a simplificar tareas habituales de listado, inspección, actualización del sistema y limpieza de caché.

`up` intenta primero hacer un `git pull --ff-only` del repositorio, luego actualiza el sistema, refresca herramientas clave cuando procede y, al final, relanza `bootstrap.sh` para consolidar los cambios.

## 🧪 Pruebas y validación

El repositorio define dos comandos públicos en `Makefile` para validar y probar el instalador en un entorno aislado:

```bash
make test
```

`make test`:

- construye (si hace falta) una imagen Docker local de pruebas;
- ejecuta `shellcheck` sobre `bootstrap.sh`, `scripts/*.sh` y `core/*.sh`;
- ejecuta `bash ./bootstrap.sh` dentro del contenedor.

Todo ocurre dentro de la imagen/contenedor, sin montar el directorio del host, por lo que no se aplican cambios fuera de Docker.

Para abrir una terminal interactiva en ese mismo entorno y lanzar comandos manuales (por ejemplo, volver a ejecutar bootstrap o probar scripts puntuales):

```bash
make run
```

`make run` levanta un contenedor efímero con una shell Bash interactiva y totalmente aislada del sistema anfitrión.

### Notas sobre la imagen Docker

El `Makefile` incluye targets internos para la construcción de la imagen y su reutilización. De esta manera no es necesario reconstruirla en cada ejecución:

```bash
make _docker-build-force
```

Ese target es interno (no forma parte de la interfaz pública), pero puede usarse cuando quieras forzar un rebuild manual.

## 🏗️ Estructura del repositorio

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
└── .gitignore
```

## 📘 Documentación y mantenimiento

Este repositorio considera dos niveles de documentación:

- [AGENTS.md](AGENTS.md): documentación técnica para comprender el repositorio, la arquitectura, las convenciones, los protocolos y cómo deben trabajar usuarios o agentes con el proyecto.
- [README.md](README.md): documentación orientada a usuarios y desarrolladores, centrada en cuán instalar, qué configura, qué herramientas añade y cómo validarlo.

Ambos archivos deben mantenerse actualizados conforme evoluciona el repositorio y se incorporan nuevas funcionalidades o cambios en el procedimiento de instalación.

## ⚖️ Licencia

El código de este repositorio se distribuye bajo la licencia MIT. Consulta [LICENSE](LICENSE).
