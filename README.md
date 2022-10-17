# diego-gv's dotfiles

## Original project
https://github.com/georgijd/dotfiles

## How to install

### Requirements
```
apt install make
```

### Install with git
```sh
git clone https://github.com/diego-gv/dotfiles.git ~/dotfiles
cd ~/dotfiles
make
```

### Install witout git
```sh
wget https://github.com/diego-gv/dotfiles/archive/refs/heads/master.zip -O ~/dotfiles.zip
unzip ~/dotfiles.zip
cd ~/dotfiles-master
make
```

### Reboot
```sh
reboot
```

> For more information run `make help`

## TODO

- zsh - installed :heavy_check_mark: but not configured :gear:
- docker - works :heavy_check_mark:
- docker-compose - pending :clock130:
- vscode - pending :clock130:
- flameshot - pending :clock130:
- timeshift - pending :clock130:
- ubuntu extensions - pending :clock130:
- diodon - pending :clock130:

## Useful Links

- [ohmyzsh] Oh My Zsh is an open source, community-driven
framework for managing your zsh configuration.
- [powerlevel10k] Powerlevel10k is a theme for Zsh. It emphasizes speed,
flexibility and out-of-the-box experience.
- [fzf] A command-line fuzzy finder
- [bat] A cat(1) clone with wings.
- [lsd] The next gen ls command

[ohmyzsh]: https://github.com/ohmyzsh/ohmyzsh "Oh My Zsh"
[powerlevel10k]: https://github.com/romkatv/powerlevel10k "Powerlevel10k"
[fzf]: https://github.com/junegunn/fzf "FZF"
[bat]: https://github.com/sharkdp/bat "Bat"
[lsd]: https://github.com/Peltoche/lsd "lsd"
