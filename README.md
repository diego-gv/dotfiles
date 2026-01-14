<!-- markdownlint-disable MD041 -->
<div align="center">
    <img src=".github/logo.png" alt="dotfiles" width="128"/>
</div>
<div align="center">
  <h1><i>dotfiles</i> ⚡ by <a href="https://github.com/diego-gv">diego-gv</a></h1>
  <strong>Personal <i>dotfiles</i> for 🍏 Apple (macOS) and 🐧 Linux (🍊 Ubuntu/🎩 Fedora)</strong>
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
<p align="center"><a href="https://github.com/diego-gv/dotfiles/blob/main/README-es.md">🇪🇸 Prefer to read this in Spanish?</a></p>

This repository contains all the **dotfiles** and scripts I use to set up a new machine or working environment.

> [!IMPORTANT]
> **Please read carefully before installing:**
>
> - This repository is a work in progress and may contain bugs or incomplete configurations.
> - **DO NOT** run the install script unless you fully understand [what it does][setup]. **Seriously, DO NOT.**
> - **DO NOT** store sensitive or personal configuration (for example, Git credentials) in the repository.

## 🧩 Compatibility

- 🍊 **Ubuntu:** Supported and tested on `24.04 LTS` (requires `>=22.04`)
- 🍏 **macOS:** Support in progress; contributions welcome
- 🎩 **Fedora:** Support in progress; contributions welcome
- 🐳 **Docker:** Used only for testing environments

## ✨ _Dotfiles_: what they are and why use them

_Dotfiles_ are hidden files (usually their names begin with a dot `.`) that store configurations controlling how your programs and development environment behave (terminal, shell, editor, etc.). Keeping them organized lets you **customize your setup** and **carry your environment to any machine** quickly and consistently.

## 🚀 Installation

The process consists of:

- Downloading the _dotfiles_ to your machine (by default `~/.dotfiles`).
- Creating [custom directories][directories].
- Installing applications and CLI tools for [macOS][install macos], [Ubuntu][install ubuntu] or [Fedora][install fedora].
- Creating [symbolic links][symlink] for configuration files.
- Generating configuration files from [templates][templates-symlink].
- Installing system fonts for IDEs and terminal.
- Applying custom preferences for [macOS][preferences macos] / [Ubuntu][preferences ubuntu] / [Fedora][preferences fedora].

### Option 1: One-liner (quick install)

With **wget**:

```sh
bash <(wget -qO - https://raw.github.com/diego-gv/dotfiles/main/scripts/setup.sh)
```

With **cURL**:

```sh
bash <(curl -LsS https://raw.github.com/diego-gv/dotfiles/main/scripts/setup.sh)
```

### Option 2: Clone and install manually

```sh
git clone https://github.com/diego-gv/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
make install
```

That's it! ✨

> [!NOTE]
> To update the system, an alias `up` is provided that runs a unified update script (`apt`, `snap`, etc.).

## 📦 Recommended applications and tools

### GUI apps via Snap

Some applications such as **Spotify** or **Obsidian** can be installed easily using [Snap][snap]. For example:

```sh
snap install spotify
snap install obsidian --classic
```

### Web app recommendations

Some desktop apps may have compatibility or stability issues on Linux. For that reason, it is recommended to use their official web versions in the browser for a better experience and support.

- [Microsoft Teams Web][teams-web]
- [Slack Web][slack-web]
- [Outlook Web][outlook-web]
- [Zoom Web][zoom-web]

### CLI tools

Some command-line tools like **AWS CLI**, **Azure CLI** or **FortiClient** are installed manually following their official documentation:

- [AWS CLI][aws-cli-link]
- [Azure CLI][azure-cli-link]
- [FortiClient][forticlient-link]

> [!NOTE]
> Installation of these applications and tools is not automated in this repository because their usage depends on your workflow and stack.

## 🛠️ Local configuration

### Using templates

During installation, and to protect sensitive information, some _dotfiles_ are generated from `.template` files — neutral versions that are safe to place in the repository.

Currently available templates are:

- `src/ssh/config.template`: SSH configuration (→ `~/.ssh/config`)
- `src/secrets/common.template`: secrets and environment variables (→ `~/.secrets/common`)

These files are copied to their final locations (in `HOME`) and then symlinks are created in the repository so they can be easily accessed and edited.

> [!WARNING]
> Generated files and their symlinks **must NOT** be added to the repository. All sensitive configuration should remain **local**.

### Useful aliases and functions

- `up`: runs unified update script.
- `clear-cache` / `clear-ram`: improve performance when caches or RAM are overloaded.
- `azlogin <name>`: simplified Azure login.
- `git list-gone` / `git prune-gone`: manage local branches without a remote.
- `docker ps`: styled output.

### Git users management (`~/.gitusers`)

The file `~/.gitusers` contains available Git profiles on the system. Each entry is stored in the following format:

```bash
name:email@example.com
```

> [!NOTE]
> This file is managed by the `git user` command.

### Adding secrets or environment variables

- To define **secrets** or **sensitive variables**, edit `~/.secrets/common`.
- To add **non-sensitive generic variables** (for example `EDITOR="nvim"` or local paths) add them in `~/.zshenv` or `~/.zshrc`.

### SSH configuration for multiple identities

If you use different Git accounts or servers (for example personal and work) from the same machine, you will need multiple SSH keys so Git uses the correct identity for each repository.

#### Step 1: Generate the keys

```sh
ssh-keygen -t ed25519 -f ~/.ssh/github_personal -C "diego-personal@gmail.com"
ssh-keygen -t ed25519 -f ~/.ssh/github_work -C "diego-work@company.com"
```

#### Step 2: Update `~/.ssh/config`

```ssh
Host github.com
  User git
  # IdentityFile ~/.ssh/github_personal
  # IdentityFile ~/.ssh/github_work
  IdentitiesOnly yes
```

#### Step 3: Manually select the correct key

If the key is not configured correctly and the repository is private or has protected branches, you will see an error like:

```bash
ERROR: Permission to diego-gv/dotfiles.git denied to diego-work.
fatal: Could not read from remote repository.
```

> [!IMPORTANT]
> To use the correct key at any given time, edit `~/.ssh/config` and enable (uncomment) the desired `IdentityFile`.

## ✨ Additional features

### Custom Git helpers

Some Git commands have been extended to help manage **multiple user identities**, which is useful when combining personal and work accounts on the same machine.

These helpers let you select, switch and view the active user quickly within a repository to avoid misconfiguration.

#### `git clone`

Clones a repository and allows selecting or creating a user profile from `~/.gitusers`:

```sh
git clone git@github.com:user/repo.git
```

At the end of the process, the cloned repository will have `user.name` and `user.email` configured automatically.

#### `git user`

Inside a Git repository, lets you change the configured user:

```sh
git user
```

You can also list available profiles and show which one is currently active:

```sh
git user --list
```

Example output:

```bash
📋 Available Git user profiles:
  1 - Diego <diego-personal@gmail.com>
  2 - Diego (Work) <diego-work@company.com> (current)
```

## 🧪 Testing

### Virtual environments

To test in virtualized GUI environments, you can use tools like [VirtualBox][virtualbox link] or [Qemu][qemu link]. For Qemu, a lightweight wrapper that's very useful is [Quickemu][quickemu link].

Once inside the virtual machine, you can simulate the installation described in the [Installation](#-installation) section.

### Docker

```sh
make test ubuntu
make test fedora
# make test macos
```

> [!NOTE]
> **It's currently not possible to test macOS via Docker**, additional documentation is required. Some useful resources include a [blog post][sickcodes-post] and a [repository][sickcodes-repo] by sickcodes.

## 📝 TODO

1. **Additional features**
    - Multi-host support in `~/.gitusers`.
    - Improve wrapper system in `~/.wrappers`.

2. **GNOME extensions**
    - Automatic configuration of GNOME extensions using [`gsettings`](https://wiki.gnome.org/dconf).
    - Document manual GNOME extension configuration.
    - Include installation of [`gnome-extensions-cli`](https://github.com/essembeh/gnome-extensions-cli).

3. **Cross-platform compatibility**
    - Add specific configurations, scripts and preferences for **macOS** and **Fedora**.

## 👏 Credits

This repository is inspired by the _dotfiles_ of [Cătălin][alrra-credit] and [frankroeder][frankroeder-credit].

## ⚖️ License

Code is available under the [MIT license][license].

<!-- Link tags: -->

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
