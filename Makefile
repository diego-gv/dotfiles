include test.mk

.DEFAULT_GOAL := all
.PHONY: git

all: system git containers terminal tools system-reboot ## Install and configure everything (default)
help: ## Display help
	@grep -hE '^[a-zA-Z_0-9%-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

system: system-install system-configure ## Install and configure
system-install: ## Install system packages
	@./scripts/system.sh install
system-configure: ## Create directories, install fonts, etc.
	@./scripts/system.sh configure
git: ## Configure git
	@./scripts/git.sh configure
gnome-terminal: ## Install themes for gnome-terminal
	@./scripts/gnome-terminal.sh configure
system-reboot:
	@./scripts/system.sh reboot

containers: docker docker-compose ## Setup docker and docker-compose
docker: docker-install docker-configure ## Install and configure
docker-install: ## Install docker packages
	@./scripts/docker.sh install
docker-configure: ## Configure docker
	@./scripts/docker.sh configure
docker-compose: docker-compose-install docker-compose-configure ## Install and configure
docker-compose-install: ## Install docker-compose packages
	@./scripts/docker-compose.sh install
docker-compose-configure: ## Configure docker-compose
	@./scripts/docker-compose.sh configure

terminal: zsh ohmyzsh fzf ## Setup the terminal
zsh: ## Configure zsh
	@./scripts/zsh.sh configure
ohmyzsh: ohmyzsh-install ohmyzsh-configure ## Install and configure Oh My Zsh
ohmyzsh-install: ## Install Oh My Zsh
	@./scripts/ohmyzsh.sh install
ohmyzsh-configure: ## Configure Oh My Zsh
	@./scripts/ohmyzsh.sh configure
fzf: ## Install FZF
	@./scripts/fzf.sh install

tools: lsd bat
lsd: ## Install lsd
	@./scripts/lsd.sh install
bat: bat-install bat-configure ## Install and configure bat
bat-install: ## Install bat
	@./scripts/bat.sh install
bat-configure: ## Configure bat
	@./scripts/bat.sh configure