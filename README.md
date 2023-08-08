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

**Basic features**
- zsh - works :heavy_check_mark:
- oh-my-zsh - works :heavy_check_mark:
- starship - works :heavy_check_mark:
- fzf - works :heavy_check_mark: but not configured :o:
- bat - works :heavy_check_mark:
- lsd - works :heavy_check_mark: but not configured :o:
- docker - works :heavy_check_mark:
- docker-compose - works :heavy_check_mark:

**Other features**
- backup - to remove :heavy_minus_sign:

**Last packages to try to set up**
- zoxide - pending :heavy_plus_sign: maybe replace fzf :x:
- timeshift - pending :heavy_plus_sign:
- flameshot - pending :heavy_plus_sign:
- diodon - pending :heavy_plus_sign:
- ubuntu extensions - pending :heavy_plus_sign:

**List of packages that require manual configuration**
- vscode - manual login :interrobang:
- postman - manual login :interrobang:
- chrome - manual login :interrobang:

_**Legend**:_ _OK_ :heavy_check_mark: | _To complete_ :o: | _To Remove_ :heavy_minus_sign: | _Pending_ :heavy_plus_sign: | _Discarded_ :x: | _Non-programmatic_ :interrobang:

## Useful Links

- [powerlevel10k] Powerlevel10k is a theme for Zsh. It emphasizes speed,
flexibility and out-of-the-box experience.

[powerlevel10k]: https://github.com/romkatv/powerlevel10k "Powerlevel10k"

### References

1. [Original Project: Georgi's dotfiles](https://github.com/georgijd/dotfiles)
2. [Setup multiple git identities & git user informations](https://gist.github.com/bgauduch/06a8c4ec2fec8fef6354afe94358c89e)
3. [Makefile help version](https://gist.github.com/prwhite/8168133?permalink_comment_id=2833138#gistcomment-2833138)
