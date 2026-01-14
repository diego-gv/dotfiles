<!-- markdownlint-disable MD041 -->
<div align="center">
    <img src=".github/logo.png" alt="dotfiles" width="128"/>
</div>
<div align="center">
  <h1><i>dotfiles</i> ⚡ de <a href="https://github.com/diego-gv">diego-gv</a></h1>
  <strong><i>Dotfiles</i> personales para 🍏 Apple (macOS) y 🐧 Linux (🍊 Ubuntu/🎩 Fedora)</strong>
</div>
<br>
<p align="center">
    <a href="https://www.gnu.org/software/bash/"><img src="https://img.shields.io/badge/shell-bash-4EAA25?logo=gnu-bash&logoColor=white" alt="shell"/></a>
    <a href="https://www.apple.com/macos/"><img src="https://img.shields.io/badge/Apple-000000.svg?style=flat&logo=apple&logoColor=white" alt="apple"/></a>
    <a href="https://ubuntu.com/"><img src="https://img.shields.io/badge/Ubuntu-E95420.svg?style=flat&logo=ubuntu&logoColor=white" alt="ubuntu"/></a>
    <a href="https://getfedora.org/"><img src="https://img.shields.io/badge/Fedora-51A2DA.svg?style=flat&logo=fedora&logoColor=white" alt="fedora"/></a>
    <a href="https://www.docker.com/"><img src="https://img.shields.io/badge/docker-2496ED.svg?style=flat&logo=docker&logoColor=white" alt="docker"/></a>
    <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-750014.svg?style=flat&logoColor=white" alt="license"/></a>
</p>
<p align="center"><a href="https://github.com/diego-gv/dotfiles/blob/main/README.md">🇬🇧 Prefer to read this in English?</a></p>

Este repositorio contiene todos los **dotfiles** y scripts que utilizo para configurar un nuevo equipo o entorno de trabajo.

> [!IMPORTANT]
> **Por favor, lea atentamente antes de instalar:**
>
> - Este repositorio está en construcción y puede contener errores o configuraciones incompletas.
> - **NO** ejecutes el script de instalación si no comprendes completamente [lo que hace][setup]. **¡En serio, NO lo hagas!**
> - **NO** almacenes configuraciones sensibles o personales (por ejemplo, credenciales de Git).

## 🧩 Compatibilidad

- 🍊 **Ubuntu:** Soportado y probado en `24.04 LTS` (requiere `>=22.04`)
- 🍏 **macOS:** Soporte en progreso, se aceptan contribuciones
- 🎩 **Fedora:** Soporte en progreso, se aceptan contribuciones
- 🐳 **Docker:** Usado solo para entornos de prueba

## ✨ _Dotfiles_: ¿qué son y por qué usarlos?

Los _dotfiles_ son archivos ocultos (generalmente, su nombre comienza por un punto o _'dot'_, `.`) donde se localizan las configuraciones que controlan cómo se comportan tus programas y tu entorno de desarrollo (terminal, shell, editor, etc.).
Mantenerlos organizados permite **personalizar tu setup** y **llevar tu entorno a cualquier equipo** de forma rápida y consistente.

## 🚀 Instalación

El proceso consiste en:

- Descargar los _dotfiles_ en tu máquina (por defecto `~/.dotfiles`).
- Crear [directorios personalizados][directories].
- Instalar aplicaciones y herramientas CLI para [macOS][install macos], [Ubuntu][install ubuntu] o [Fedora][install fedora].
- Crear [enlaces simbólicos][symlink] para los archivos de configuración.
- Generar [ficheros de configuración desde plantillas][templates-symlink].
- Instalar fuentes de sistema para IDEs y terminal.
- Aplicar preferencias personalizadas para [macOS][preferences macos] / [Ubuntu][preferences ubuntu] / [Fedora][preferences fedora].

### Opción 1: One-liner (instalación rápida)

Con **wget**:

```sh
bash <(wget -qO - https://raw.github.com/diego-gv/dotfiles/main/scripts/setup.sh)
```

Con **cURL**:

```sh
bash <(curl -LsS https://raw.github.com/diego-gv/dotfiles/main/scripts/setup.sh)
```

### Opción 2: Clonar e instalar manualmente

```sh
git clone https://github.com/diego-gv/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
make install
```

¡Y eso es todo! ✨

> [!NOTE]
> Para actualizar el sistema, se ha creado un alias `up` que lanza un script de actualización de paquetería (`apt`, `snap`, etc.).

## 📦 Aplicaciones y herramientas recomendadas

### Aplicaciones GUI vía Snap

Algunas aplicaciones como **Spotify** u **Obsidian**, entre otras, pueden instalarse fácilmente usando [Snap][snap]. Por ejemplo:

```sh
snap install spotify
snap install obsidian --classic
```

### Aplicaciones web recomendadas

Algunas aplicaciones suelen presentar problemas de compatibilidad o estabilidad en entornos Linux. Por ello, se recomienda utilizar sus versiones web oficiales a través del navegador para una mejor experiencia y soporte.

- [Microsoft Teams Web][teams-web]
- [Slack Web][slack-web]
- [Outlook Web][outlook-web]
- [Zoom Web][zoom-web]

### Herramientas CLI

Algunas herramientas de terminal como **AWS CLI**, **Azure CLI** o **FortiClient**, entre otras, se instalan manualmente siguiendo su documentación oficial:

- [AWS CLI][aws-cli-link]
- [Azure CLI][azure-cli-link]
- [FortiClient][forticlient-link]

> [!NOTE]
> La instalación de estas aplicaciones y herramientas no está automatizada en este repositorio, ya que su utilización depende del flujo de trabajo y stack utilizado.

## 🛠️ Configuración local

### Uso de plantillas

Durante la instalación, para proteger información sensible, algunos _dotfiles_ se generan a partir de ficheros `.template`, versiones **neutrales** que son inocuas al sistema.

Actualmente, las plantillas disponibles son:

- `src/ssh/config.template`: configuración de SSH (→ `~/.ssh/config`)
- `src/secrets/common.template`: secretos y variables de entorno (→ `~/.secrets/common`)

Estos ficheros se copian a su ubicación final (en el `HOME`) y, posteriormente, se crean **symlinks en el repositorio** para acceder y modificar fácilmente.

> [!WARNING]
> Los ficheros generados y sus symlinks **NO deben añadirse al repositorio**. Toda configuración sensible debe permanecer **local**.

### Alias y funciones útiles

- `up`: ejecuta script de actualización unificada.
- `clear-cache` / `clear-ram`: mejora el rendimiento en sobrecarga de cache/ram.
- `azlogin <name>`: login simplificado a Azure.
- `git list-gone` / `git prune-gone`: gestiona ramas locales sin origen remoto.
- `docker ps`: salida estilizada.

### Gestión de usuarios de Git (`~/.gitusers`)

El archivo `~/.gitusers` contiene los perfiles de Git disponibles en el sistema. La información es almacenada en el siguiente formato:

```bash
nombre:email@ejemplo.com
```

> [!NOTE]
> Este archivo es gestionado mediante el comando `git user`.

### Añadir secretos o variables de entorno

- Para definir **secretos** o **variables sensibles**, edita el fichero `~/.secrets/common`.
- Para añadir **variables genéricas y seguras** (por ejemplo `EDITOR="nvim"` o rutas locales) se pueden añadir en `~/.zshenv` o `~/.zshrc`.

### Configuración SSH para múltiples identidades

Si utilizas **distintas cuentas o servidores de Git** (por ejemplo, personal y trabajo) desde la misma máquina, es necesaria la configuración de **múltiples claves SSH** para asegurar que Git use la identidad correcta en cada repositorio.

#### Paso 1: Generar las claves

```sh
ssh-keygen -t ed25519 -f ~/.ssh/github_personal -C "diego-personal@gmail.com"
ssh-keygen -t ed25519 -f ~/.ssh/github_work -C "diego-work@company.com"
```

#### Paso 2: Actualizar `~/.ssh/config`

```ssh
Host github.com
  User git
  # IdentityFile ~/.ssh/github_personal
  # IdentityFile ~/.ssh/github_work
  IdentitiesOnly yes
```

#### Paso 3: Seleccionar manualmente la clave adecuada

Si la clave no está configurada correctamente y el repositorio es privado o tiene ramas protegidas, verás un error como este:

```bash
ERROR: Permission to diego-gv/dotfiles.git denied to diego-work.
fatal: Could not read from remote repository.
```

> [!IMPORTANT]
> Para usar la clave correcta en cada momento, deberás comentar o descomentar el `IdentityFile` adecuado en el archivo `~/.ssh/config`.

En ese caso, edita el archivo `~/.ssh/config` y asegúrate de que sólo está activa la clave deseada.

## ✨ Funcionalidades adicionales

### Funciones personalizadas de Git

Algunos comandos de Git se han extendido para facilitar la gestión de **múltiples identidades de usuario**, especialmente útil en entornos donde se combinan multiples cuentas.

Estas funciones permiten seleccionar, cambiar y visualizar rápidamente el usuario activo en cada repositorio, evitando errores de configuración.

#### `git clone`

Clona un repositorio y permite seleccionar o crear un perfil de usuario desde `~/.gitusers`:

```sh
git clone git@github.com:usuario/repositorio.git
```

Al finalizar el proceso, el repositorio clonado tendrá configurado automáticamente el `user.name` y `user.email` seleccionados.

#### `git user`

Dentro de un repositorio Git, permite cambiar el usuario configurado:

```sh
git user
```

También es posible listar los perfiles existentes e indicar cuál está actualmente activo:

```sh
git user --list
```

Ejemplo de salida:

```bash
📋 Available Git user profiles:
  1 - Diego <diego-personal@gmail.com>
  2 - Diego (Work) <diego-work@company.com> (current)
```

## 🧪 Pruebas

### Entorno virtual

Para probar en entornos virtualizados con GUI, puedes usar herramientas como [VirtualBox][virtualbox link] o [Qemu][qemu link]. Para este último, un wrapper muy útil, ligero y rápido es [Quickemu][quickemu link].

Una vez en la máquina virtual, puedes simular la instalación descrita en la sección [Instalación](#-instalación).

### Docker

```sh
make test ubuntu
make test fedora
# make test macos
```

> [!NOTE]
> **Actualmente no es posible probar en macOS a través de Docker**, requiere documentación adicional. Algunos recursos prometedores son un [post de blog][sickcodes-post] y un [repositorio][sickcodes-repo] de sickcodes.

## 📝 TODO

1. **Funcionalidades adicionales**
    - Soporte multi-host en `~/.gitusers`.
    - Mejorar sistema de wrappers en `~/.wrappers`.

2. **Extensiones de GNOME**
    - Configuración automática de extensiones de GNOME usando [`gsettings`](https://wiki.gnome.org/dconf).
    - Documentar configuración manual de extensiones de GNOME.
    - Incluir la instalación de [`gnome-extensions-cli`](https://github.com/essembeh/gnome-extensions-cli).

3. **Compatibilidad multiplataforma**
    - Añadir configuraciones, scripts y preferencias específicas para **macOS** y **Fedora**.

## 👏 Créditos

Este repositorio está inspirado en los _dotfiles_ de [Cătălin][alrra-credit] y [frankroeder][frankroeder-credit].

## ⚖️ Licencia

El código está disponible bajo la [licencia MIT][license].

<!-- Etiquetas de enlaces: -->

[setup]: scripts/setup.sh
[symlink]: scripts/create_symbolic_links.sh
[templates-symlink]: scripts/create_templates_and_symlinks.sh
[directories]: scripts/create_directories.sh
[install macos]: scripts/installs/macos
[install ubuntu]: scripts/installs/ubuntu
[install fedora]: scripts/installs/fedora
[preferences macos]: scripts/preferences/macos
[preferences ubuntu]: scripts/preferences/ubuntu
[preferences fedora]: scripts/preferences/fedora
[aws-cli-link]: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
[azure-cli-link]: https://learn.microsoft.com/en-us/cli/azure/install-azure-cli
[forticlient-link]: https://www.fortinet.com/support/product-downloads
[snap]: https://snapcraft.io/
[teams-web]: https://teams.microsoft.com/
[slack-web]: https://slack.com/signin
[outlook-web]: https://outlook.office.com/
[zoom-web]: https://zoom.us/signin
[virtualbox link]: https://www.virtualbox.org/
[qemu link]: https://www.qemu.org/
[quickemu link]: https://github.com/quickemu-project/quickemu
[alrra-credit]: https://github.com/alrra/dotfiles
[frankroeder-credit]: https://github.com/frankroeder/dotfiles
[sickcodes-post]: https://sick.codes/how-to-install-macos-virtual-machine-on-linux-arch-manjaro-catalina-mojave-or-high-sierra-xcode-working/
[sickcodes-repo]: https://github.com/sickcodes/Docker-OSX
[license]: LICENSE
