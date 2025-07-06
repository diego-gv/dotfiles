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
<p align="center"><a href="https://github.com/diego-gv/dotfiles/blob/main/README-es.md">🇪🇸 ¿Prefieres leer esto en español?</a></p>

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

#### Git configuration and SSH keys

This repository is designed to work with multiple Git identities (personal and work) using SSH keys and a custom SSH configuration. Below is a summary of the setup:

##### Git configuration

- The main Git configuration is in `src/git/gitconfig`.
- Personal user information is included from `src/git/gitconfig.personal`.
- If you work in a directory under `~/workspace`, the configuration in `src/git/gitconfig.workspace` is also included, allowing you to use a different user/email for work repositories.

Example of `~/.gitconfig.personal`:

```ini
[user]
    name = diego-gv
    email = diegosalvador.gv@gmail.com
```

##### SSH keys and SSH config

To manage different SSH keys for personal and work repositories, the SSH configuration file (`src/ssh/config`) is used. Example:

```ssh
Host github.com
  User git
  IdentityFile ~/.ssh/github_personal

Host github.com-<company>
  HostName github.com
  User git
  IdentityFile ~/.ssh/github_work
```

- The `github.com` host uses your personal SSH key (`~/.ssh/github_personal`).
- The `github.com-<company>` host uses your work SSH key (`~/.ssh/github_work`).

##### How it works

- For personal repositories, use the standard SSH URL: `git@github.com:diego-gv/your-repo.git`. This will use your personal key.
- For work repositories, use the following SSH URL: `git@github.com-<company>:<company-user>/your-repo.git`. This will use your work key.
- There is a helper function/alias (`gitclone`) that automatically rewrites the SSH URL for work repositories so you don't have to do it manually.

##### Why this setup?

- It allows you to keep your personal and work Git identities and SSH keys completely separate.
- You avoid authentication errors and accidental commits with the wrong identity.
- The SSH config ensures the correct key is used for each repository, and the Git config ensures the correct user/email is set.

> [!TIP]
> If you need to add a new SSH key, generate it with `ssh-keygen`, add the public key to your GitHub account, and update

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

- Add configuration steps for GNOME extensions using `gsettings`.
- Install [gnome-extensions-cli](https://github.com/essembeh/gnome-extensions-cli).
- Update the `gitclone` `alias` to ask which host the repository is being downloaded from.
- Add `alias` to create new host (with its ssh key) and ask if new user profile is needed (create it too).
- Add `alias` to change date of `commit`.
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
