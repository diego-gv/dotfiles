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
    <img src="https://img.shields.io/badge/Apple-000000.svg?style=flat&logo=apple&logoColor=white" alt="apple"/>
    <img src="https://img.shields.io/badge/Ubuntu-E95420.svg?style=flat&logo=ubuntu&logoColor=white" alt="ubuntu"/>
    <img src="https://img.shields.io/badge/Fedora-51A2DA.svg?style=flat&logo=fedora&logoColor=white" alt="fedora"/>
    <img src="https://img.shields.io/badge/docker-2496ED.svg?style=flat&logo=docker&logoColor=white" alt="docker"/>
    <img src="https://img.shields.io/badge/license-MIT-750014.svg?style=flat" alt="license"/>
</p>

These are the base dotfiles that I start with when I set up a new environment (for more specific local needs I use the [`*.local`](#local-settings) files).

> [!IMPORTANT]
> This repository (and the dotfiles hosted here) is currently under construction. Therefore, these files may contain errors or may not be fully configured.

## 🚀 Setup

The setup process will:

* Download the dotfiles on your computer (by default it will suggest `~/.dotfiles`).
* Create custom [directories][directories]
* Install applications / command-line tools for [macOS][install macos] / [Ubuntu][install ubuntu] / [Fedora][install fedora].
* [Symlink][symlink] the installation applications and packages related files.
* Install of programming and terminal fonts
* Set custom [macOS][preferences macos] / [Ubuntu][preferences ubuntu] / [Fedora][preferences fedora] preferences.

### Run

To set up the dotfiles run the appropriate snippet in the terminal:

> [!CAUTION]
> **DO NOT** run the setup script if you do not fully understand [what it does][setup]. Seriously, **DON'T**!

Using **wget**:

```zsh
bash <(wget -qO - https://raw.github.com/diego-gv/dotfiles/main/scripts/setup.sh)
```

Or using **cURL**:

```zsh
bash <(curl -LsS https://raw.github.com/diego-gv/dotfiles/main/scripts/setup.sh)
```

That's it! ✨

> [!NOTE]
> To update the system, an alias has been created called `up` to run the update script.

### Customize

#### Local settings

##### `~/.gitconfig.local`

The `~/.gitconfig.personal` and `~/.gitconfig.workspace` files will be automatically included after the configurations from `~/.gitconfig`, thus, allowing its content to overwrite or add to the existing Git configurations.

> [!NOTE]
> Use this files to store sensitive information such as the Git user credentials

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

* Add installation instructions for **AutoFirma**.
* Add startup applications in **GNOME Tweaks**.
* Replace `snap` installation with `aptitude` installation for the following apps: `teams-for-linux`, `slack`, `spotify`, `outlook-for-linux`, and `obsidian`.
* Hotfix installation instructions for **Google Chrome** (_currently broken_).
* Hotfix installation instructions for **VScode** and **VScode Insiders** (_currently broken_).
* Add configuration steps for GNOME extensions using `gsettings`.
* Add configuration, scripts, and preferences for **macOS** o **Fedora**.


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
[virtualbox link]: https://www.virtualbox.org/
[qemu link]: https://www.qemu.org/
[quickemu link]: https://github.com/quickemu-project/quickemu
[alrra-credit]: https://github.com/alrra/dotfiles
[frankroeder-credit]: https://github.com/frankroeder/dotfiles
[sickcodes-post]: https://sick.codes/how-to-install-macos-virtual-machine-on-linux-arch-manjaro-catalina-mojave-or-high-sierra-xcode-working/
[sickcodes-repo]: https://github.com/sickcodes/Docker-OSX
[license]: LICENSE
