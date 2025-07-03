<!-- markdownlint-disable MD041 -->
<div align="center">
    <img src=".github/logo.png" alt="dotfiles" width="128"/>
</div>
<div align="center">
  <h1>dotfiles ⚡ de <a href="https://github.com/diego-gv">diego-gv</a></h1>
  <strong>Dotfiles personales para 🍎 Apple (macOS) y 🐧 Linux (Ubuntu/Fedora)</strong>
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

- 🐧 **Ubuntu:** Soportado y probado (última: 24.04 LTS)
- 🍎 **macOS:** Soporte en progreso, se aceptan contribuciones
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

### Ejecución

Para instalar los dotfiles, puedes usar uno de los siguientes métodos en tu terminal:

**Opción 1: One-liner (recomendado para instalación rápida)**

Usando **wget**:

```sh
bash <(wget -qO - https://raw.github.com/diego-gv/dotfiles/main/scripts/setup.sh)
```

O usando **cURL**:

```sh
bash <(curl -LsS https://raw.github.com/diego-gv/dotfiles/main/scripts/setup.sh)
```

**Opción 2: Clonar e instalar manualmente**

```sh
git clone https://github.com/diego-gv/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
make install
```

¡Eso es todo! ✨

> [!NOTE]
> Para actualizar el sistema, se ha creado un alias llamado `up` que ejecuta el script de actualización.

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

### Personalización

#### Configuración local

##### `~/.gitconfig.local`

Los archivos `~/.gitconfig.personal` y `~/.gitconfig.workspace` se incluirán automáticamente después de las configuraciones de `~/.gitconfig`, permitiendo que su contenido sobrescriba o añada configuraciones de Git existentes.

Por ejemplo:

> ```gitconfig
> [user]
>     name = Tu Nombre
>     email = cuenta@ejemplo.com
> ```

#### Configuración de Git y claves SSH

Este repositorio está preparado para trabajar con múltiples identidades de Git (personal y trabajo) usando claves SSH y una configuración SSH personalizada. A continuación, un resumen de la configuración:

##### Configuración de Git

- La configuración principal de Git está en `src/git/gitconfig`.
- La información personal del usuario se incluye desde `src/git/gitconfig.personal`.
- Si trabajas en un directorio bajo `~/workspace`, también se incluye la configuración de `src/git/gitconfig.workspace`, permitiendo usar un usuario/email diferente para los repositorios de trabajo.

Ejemplo de `~/.gitconfig.personal`:

```ini
[user]
    name = diego-gv
    email = diegosalvador.gv@gmail.com
```

##### Claves SSH y configuración SSH

Para gestionar diferentes claves SSH para repositorios personales y de trabajo, se usa el archivo de configuración SSH (`src/ssh/config`). Ejemplo:

```ssh
Host github.com
  User git
  IdentityFile ~/.ssh/github_personal

Host github.com-<company>
  HostName github.com
  User git
  IdentityFile ~/.ssh/github_work
```

- El host `github.com` usa tu clave SSH personal (`~/.ssh/github_personal`).
- El host `github.com-<company>` usa tu clave SSH de trabajo (`~/.ssh/github_work`).

##### ¿Cómo funciona?

- Para repositorios personales, usa la URL SSH estándar: `git@github.com:diego-gv/tu-repo.git`. Esto usará tu clave personal.
- Para repositorios de trabajo, usa la siguiente URL SSH: `git@github.com-<company>:<company-user>/tu-repo.git`. Esto usará tu clave de trabajo.
- Hay una función/alias (`gitclone`) que reescribe automáticamente la URL SSH para los repositorios de trabajo, así no tienes que hacerlo manualmente.

> [!TIP]
> Sustituye `<company>` por el nombre real de tu empresa u organización tanto en la configuración SSH como en las URLs de los repositorios.

##### ¿Por qué esta configuración?

- Permite mantener completamente separadas tus identidades y claves SSH personales y de trabajo.
- Evita errores de autenticación y commits accidentales con la identidad equivocada.
- El archivo de configuración SSH asegura que se use la clave correcta para cada repositorio, y la configuración de Git asegura que se use el usuario/email correcto.

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

- Instalar **spotify**, **obsidian** y **AutoFirma**.
- Corregir instrucciones de instalación para **Google Chrome** (_actualmente roto_).
- Corregir instrucciones de instalación para **VScode** y **VScode Insiders** (_actualmente roto_).
- Añadir pasos de configuración para extensiones GNOME usando `gsettings`.
- Añadir configuración, scripts y preferencias para **macOS** o **Fedora**.
- Añadir `alias` para cambiar la fecha de un _commit_

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
