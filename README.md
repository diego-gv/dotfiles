# diego-gv's dotfiles

## Compatibility
- Ubuntu 22.04.2

## How to install

**Requirements**
```
apt install make
```

**Install with git**
```sh
git clone https://github.com/diego-gv/dotfiles.git ~/dotfiles
cd ~/dotfiles
make
```

**Install witout git**
```sh
wget https://github.com/diego-gv/dotfiles/archive/refs/heads/master.zip -O ~/dotfiles.zip
unzip ~/dotfiles.zip && mv ~/dotfiles-master ~/dotfiles
cd ~/dotfiles
make
```

**Reboot**
```sh
reboot
```

> For more information run `make help`

## TODO

- backup - pending :clock130:
- zsh - installed :heavy_check_mark:
- oh-my-zsh - installed :heavy_check_mark:
- starship - installed :heavy_check_mark: but not configured :gear:
- fzf - installed :heavy_check_mark: maybe replace by zoxide :clock130:
- zoxide - pending :clock130:
- bat - installed :heavy_check_mark:
- lsd - installed :heavy_check_mark: but not configured :gear:
- docker - works :heavy_check_mark:
- docker-compose - pending :clock130:
- flameshot - pending :clock130:
- diodon - pending :clock130:
- ubuntu extensions - pending :clock130:

**Last packages to configure**
- vscode - pending :clock130:
- timeshift - pending :clock130:
- postman - pending :clock130:

**Other tasks**
- Move installers to the .local folder
  - fzf - pending :clock130:
  - starship - pending :clock130:
  - others - pending :clock130:

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

### References

1. [Original Project: Georgi's dotfiles](https://github.com/georgijd/dotfiles)
2. [Setup multiple git identities & git user informations](https://gist.github.com/bgauduch/06a8c4ec2fec8fef6354afe94358c89e)
3. [Makefile help version](https://gist.github.com/prwhite/8168133?permalink_comment_id=2833138#gistcomment-2833138)