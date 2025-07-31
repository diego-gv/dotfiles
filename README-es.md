<!-- markdownlint-disable MD041 -->
<div align="center">
    <img src=".github/logo.png" alt="dotfiles" width="128"/>
</div>
<div align="center">
  <h1>dotfiles ⚡ de <a href="https://github.com/diego-gv">diego-gv</a></h1>
  <strong>Dotfiles personales para 🍏 Apple (macOS) y 🐧 Linux (🍊 Ubuntu/🎩 Fedora)</strong>
</div>
<br>
<p align="center">
    <a href="https://www.gnu.org/software/bash/"><img src="https://img.shields.io/badge/shell-bash-4EAA25?logo=gnu-bash&logoColor=white" alt="shell"/></a>
    <a href="https://www.apple.com/macos/"><img src="https://img.shields.io/badge/Apple-000000.svg?style=flat&logo=apple&logoColor=white" alt="apple"/></a>
    <a href="https://ubuntu.com/"><img src="https://img.shields.io/badge/Ubuntu-E95420.svg?style=flat&logo=ubuntu&logoColor=white" alt="ubuntu"/></a>
    <a href="https://getfedora.org/"><img src="https://img.shields.io/badge/Fedora-51A2DA.svg?style=flat&logo=fedora&logoColor=white" alt="fedora"/></a>
    <a href="https://www.docker.com/"><img src="https://img.shields.io/badge/docker-2496ED.svg?style=flat&logo=docker&logoColor=white" alt="docker"/></a>
    <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-750014.svg?style=flat" alt="license"/></a>
</p>
<p align="center"><a href="https://github.com/diego-gv/dotfiles/blob/main/README.md">🇬🇧 Prefer to read this in English?</a></p>

Estos son los dotfiles base que utilizo al configurar un nuevo entorno (para necesidades locales más específicas uso los archivos [`*.local`](#local-settings)).

> [!IMPORTANT]
> **Por favor, lee antes de usar estos dotfiles:**
>
> - Este repositorio está en construcción y puede contener errores o configuraciones incompletas.
> - **NO** ejecutes el script de instalación si no entiendes completamente [lo que hace][setup]. ¡En serio, NO lo hagas!
> - Usa archivos `.local` para almacenar configuraciones sensibles o personales (por ejemplo, credenciales de Git).

## 🧩 Compatibilidad

- 🍊 **Ubuntu:** Soportado y probado (última: 24.04 LTS)
- 🍏 **macOS:** Soporte en progreso, se aceptan contribuciones
- 🎩 **Fedora:** Soporte en progreso, se aceptan contribuciones
- 🐳 **Docker:** Usado solo para entornos de prueba

## 🚀 Instalación

El proceso de instalación:

- Descarga los dotfiles en tu computadora (por defecto sugiere `~/.dotfiles`).
- Crea [directorios personalizados][directories].
- Instala aplicaciones/herramientas de línea de comandos para [macOS][install macos] / [Ubuntu][install ubuntu] / [Fedora][install fedora].
- [Crea enlaces simbólicos][symlink] de los archivos de instalación y paquetes relacionados.
- Instala fuentes de programación y terminal.
- Aplica preferencias personalizadas para [macOS][preferences macos] / [Ubuntu][preferences ubuntu] / [Fedora][preferences fedora].

---

### Ejecución

Para instalar los dotfiles, puedes usar uno de los siguientes métodos en tu terminal:

#### Opción 1: One-liner (recomendado para instalación rápida)

Usando **wget**:

```sh
bash <(wget -qO - https://raw.github.com/diego-gv/dotfiles/main/scripts/setup.sh)
```

O usando **cURL**:

```sh
bash <(curl -LsS https://raw.github.com/diego-gv/dotfiles/main/scripts/setup.sh)
```

#### Opción 2: Clonar e instalar manualmente

```sh
git clone https://github.com/diego-gv/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
make install
```

¡Eso es todo! ✨

> [!NOTE]
> Para actualizar el sistema, se ha creado un alias llamado `up` que ejecuta el script de actualización.

---

### Aplicaciones y herramientas recomendadas

#### Aplicaciones GUI vía Snap

Algunas aplicaciones como **Spotify**, **Obsidian** y otras pueden instalarse fácilmente usando [Snap][snap]. Por ejemplo:

```sh
snap install spotify
snap install obsidian --classic
```

#### Aplicaciones de productividad: uso recomendado de la versión web

Algunas aplicaciones de productividad como **Microsoft Teams**, **Slack**, **Outlook**, **Zoom**, y otras suelen presentar problemas de compatibilidad o estabilidad en entornos Linux, especialmente en distribuciones como Ubuntu o Fedora. Por ello, se recomienda utilizar sus versiones web oficiales a través del navegador para una mejor experiencia y soporte.

- [Microsoft Teams Web][teams-web]
- [Slack Web][slack-web]
- [Outlook Web][outlook-web]
- [Zoom Web][zoom-web]

> [!TIP]
> Usar las versiones web garantiza acceso a las últimas funciones y mayor estabilidad, evitando problemas comunes de las aplicaciones de escritorio en Linux.

#### Asistentes y herramientas CLI adicionales

Algunas herramientas de terminal como **AWS CLI** (`aws`), **Azure CLI** (`az`), **FortiClient**, y otras también son de uso común.
Si necesitas alguna de estas herramientas, consulta su documentación oficial para instrucciones de instalación:

- [AWS CLI][aws-cli-link]
- [Azure CLI][azure-cli-link]
- [FortiClient][forticlient-link]

> [!NOTE]
> La instalación de estas aplicaciones y herramientas no está automatizada en este repositorio, ya que su necesidad depende de tu flujo de trabajo y stack. Usa Snap o la documentación oficial para instalarlas.

---

### Configuración local

#### Alias de Git

- `git list-gone`: Lista las ramas locales cuyo origen remoto ha desaparecido (es decir, están marcadas como **gone**).
- `git prune-gone`: Elimina las ramas locales que están marcadas como **gone** porque su rama remota ya no existe.

#### Gestión de usuarios de Git (`~/.gitusers`)

El archivo `~/.gitusers` contiene los perfiles disponibles en el siguiente formato:

```bash
nombre:email@ejemplo.com
```

> [!NOTE]
> Este archivo se gestiona automáticamente mediante los comandos `git user` y `git clone`.

#### Funciones personalizadas de Git

Algunos comandos de Git se han extendido para facilitar la gestión de identidades de usuario en entornos con múltiples configuraciones.

##### `git clone`

Clona un repositorio y permite seleccionar o crear un perfil de usuario desde `~/.gitusers`:

```sh
git clone git@github.com:usuario/repositorio.git
```

Al finalizar, se configurará automáticamente el `user.name` y `user.email` en el repositorio clonado.

##### `git user`

Dentro de un repositorio Git, permite cambiar el usuario configurado:

```sh
git user
```

También es posible listar los perfiles existentes e indicar cuál está actualmente activo en el repositorio:

```sh
git user --list
```

Ejemplo de salida:

```bash
📋 Available Git user profiles:
  1 - Diego <diego-personal@gmail.com>
  2 - Diego (Work) <diego-work@company.com> (current)
```

#### Configuración SSH para múltiples identidades

##### Paso 1: Generar las claves

```sh
ssh-keygen -t ed25519 -f ~/.ssh/github_personal -C "diego-personal@gmail.com"
ssh-keygen -t ed25519 -f ~/.ssh/github_work -C "diego-work@company.com"
```

##### Paso 2: Actualizar `~/.ssh/config`

```ssh
Host github.com
  User git
  # IdentityFile ~/.ssh/github_personal
  # IdentityFile ~/.ssh/github_work
  IdentitiesOnly yes
```

##### Paso 3: Seleccionar manualmente la clave adecuada

> [!IMPORTANT]
> Para usar la clave correcta en cada momento, deberás comentar o descomentar el `IdentityFile` adecuado en el archivo `~/.ssh/config`.

Si no seleccionas correctamente la clave, y el repositorio es privado o tiene ramas protegidas, verás un error como este:

```bash
ERROR: Permission to diego-gv/dotfiles.git denied to diego-work.
fatal: Could not read from remote repository.
```

En ese caso, edita el archivo `~/.ssh/config` y asegúrate de que sólo está activa la clave deseada.

## 🧪 Pruebas

### Entorno virtual

Para probar en entornos virtualizados con GUI, puedes usar herramientas como [VirtualBox][virtualbox link] o [Qemu][qemu link]. Para este último, un wrapper muy útil, ligero y rápido es [Quickemu][quickemu link].

Una vez en la máquina virtual, puedes simular la instalación descrita en la sección [Instalación](#-instalación).

---

### Docker

```sh
make test ubuntu
make test fedora
# make test macos
```

> [!NOTE]
> **Actualmente no es posible probar en macOS a través de Docker**, requiere documentación adicional. Algunos recursos prometedores son un [post de blog][sickcodes-post] y un [repositorio][sickcodes-repo] de sickcodes.

## 📝 TODO

### Extensiones de GNOME

- Documentar los pasos necesarios para configurar extensiones de GNOME usando [`gsettings`](https://wiki.gnome.org/dconf).
- Incluir la instalación de [`gnome-extensions-cli`](https://github.com/essembeh/gnome-extensions-cli).

### Compatibilidad multiplataforma

- Añadir configuraciones, scripts y preferencias específicas para **macOS** y **Fedora**.

## 👏 Créditos

Estos dotfiles están basados en los dotfiles de [Cătălin][alrra-credit] y [frankroeder][frankroeder-credit]. Por tanto, este repositorio contiene fragmentos de código e ideas de estos, que han servido de guía e inspiración.

## ⚖️ Licencia

El código está disponible bajo la [licencia MIT][license].

<!-- Etiquetas de enlaces: -->
[setup]: scripts/setup.sh
[symlink]: scripts/create_symbolic_links.sh
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
