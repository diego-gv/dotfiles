<!-- markdownlint-disable MD041 -->
<div align="center">
    <img src=".github/logo.png" alt="dotfiles" width="128"/>
</div>
<div align="center">
  <h1><a href="https://github.com/diego-gv">diego-gv</a>’s ⚡ dotfiles</h1>
  <strong>Personal dotfiles for 🍎 Apple (macOS) and 🐧 Linux (Ubuntu/Fedora)</strong>
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

These are the base dotfiles that I start with when I set up a new environment (for more specific local needs I use the [`*.local`](#local-settings) files).

> [!IMPORTANT]
> **Please read before using these dotfiles:**
>
> - This repository is under construction and may contain errors or incomplete configurations.
> - **DO NOT** run the setup script if you do not fully understand [what it does][setup]. Seriously, **DON'T**!
> - Use `.local` files to store sensitive or personal configuration (e.g., Git credentials).

## 🧩 Compatibility

- 🐧 **Ubuntu:** Supported and tested (latest: 24.04 LTS)
- 🍎 **macOS:** Support in progress, contributions welcome
- 🎩 **Fedora:** Support in progress, contributions welcome
- 🐳 **Docker:** Used only for testing environments

## 🚀 Setup

The setup process will:

- Download the dotfiles on your computer (by default it will suggest `~/.dotfiles`).
- Create custom [directories][directories].
- Install applications / command-line tools for [macOS][install macos] / [Ubuntu][install ubuntu] / [Fedora][install fedora].
- [Symlink][symlink] the installation applications and packages related files.
- Install of programming and terminal fonts.
- Set custom [macOS][preferences macos] / [Ubuntu][preferences ubuntu] / [Fedora][preferences fedora] preferences.

### Run

To set up the dotfiles, you can use one of the following methods in your terminal:

**Option 1: One-liner (recommended for quick setup)**

Using **wget**:

```sh
bash <(wget -qO - https://raw.github.com/diego-gv/dotfiles/main/scripts/setup.sh)
```

Or using **cURL**:

```sh
bash <(curl -LsS https://raw.github.com/diego-gv/dotfiles/main/scripts/setup.sh)
```

**Option 2: Clone and install manually**

```sh
git clone https://github.com/diego-gv/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
make install
```

That's it! ✨

> [!NOTE]
> To update the system, an alias has been created called `up` to run the update script.

### Usage

To update the system, use the `up` alias.

### Recommended applications and CLI tools

#### GUI applications via Snap

Some applications such as **Spotify**, **Obsidian**, and others can be easily installed using [Snap][snap]. For example:

```sh
snap install spotify
snap install obsidian --classic
```

#### Productivity applications: recommended use of the web version

Some productivity applications such as **Microsoft Teams**, **Slack**, **Outlook**, **Zoom**, and others often present compatibility or stability issues on Linux environments, especially on distributions like Ubuntu or Fedora. For this reason, it is recommended to use their official web versions through your browser for a better experience and support.

- [Microsoft Teams Web][teams-web]
- [Slack Web][slack-web]
- [Outlook Web][outlook-web]
- [Zoom Web][zoom-web]

> [!TIP]
> Using the web versions ensures access to the latest features and greater stability, avoiding common issues found in the

#### Additional CLI assistants and tools

Some terminal assistants and tools such as **AWS CLI** (`aws`), **Azure CLI** (`az`), **FortiClient**, and others are also commonly used.
If you need any of these tools, please refer to their official documentation for installation instructions:

- [AWS CLI][aws-cli-link]
- [Azure CLI][azure-cli-link]
- [FortiClient][forticlient-link]

> [!NOTE]
> The installation of these applications and tools is not automated in this repository, as their necessity depends on your workflow and stack. Use Snap or the official documentation to install them

### Customize

#### Local settings

##### `~/.gitconfig.local`

The `~/.gitconfig.personal` and `~/.gitconfig.workspace` files will be automatically included after the configurations from `~/.gitconfig`, thus, allowing its content to overwrite or add to the existing Git configurations.

For example:

> ```gitconfig
> [user]
>     name = Your Name
>     email = account@example.com
> ```

## 🧪 Testing

### Virtual environment

For testing in virtualized environments via GUI, tools such as [VirtualBox][virtualbox link] or [Qemu][qemu link] can be used. Regarding the latter, a very useful, lightweight and fast wrapper is [Quickemu][quickemu link].

Once in the virtual machine, you can simulate the installation described in the [Setup](#-setup) section.

### Docker

```sh
make test ubuntu
make test fedora
# make test macos
```

> [!NOTE]
> **Currently testing on macOS through Docker is not possible**, it requires extra documentation. Some promising docs are a [blog post][sickcodes-post] and a [repository][sickcodes-repo] of sickcodes.

## 📝 TODO

- Install **spotify** and **obsidian** and **AutoFirma**.
- Hotfix installation instructions for **Google Chrome** (_currently broken_).
- Hotfix installation instructions for **VScode** and **VScode Insiders** (_currently broken_).
- Add configuration steps for GNOME extensions using `gsettings`.
- Add configuration, scripts, and preferences for **macOS** o **Fedora**.

## 👏 Credits

These dotfiles are based on the dotfiles of [Cătălin's][alrra-credit] and [frankroeder's][frankroeder-credit]. Therefore, this repository contains code snippets and ideas from these, which have served as guidance and inspiration.

## ⚖️ License

The code is available under the [MIT license][license].

<!-- Link labels: -->
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
