include test.mk
include colors.mk

.DEFAULT_GOAL := all
.PHONY: git

##@ Commands
all: system # git containers terminal tools system-reboot ## Install and configure everything (default)
help: ## Display help
	@awk 'BEGIN {FS = ":.*##"; printf "${BNC}Usage${NC}: make ${CYAN}<target>${NC}\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  ${CYAN}%-20s${NC} %s\n", $$1, $$2 } /^##@/ { printf "\n${BYELLOW}%s${NC}\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ System
system: system-backup system-install system-configure ## Install system packages and configure system (directories, fonts, etc)
system-install:
	@./scripts/system.sh install
system-configure:
	@./scripts/system.sh configure
system-backup: ## Create backup
	@./scripts/system.sh backup
system-restore:	## Restore backup
	@./scripts/system.sh restore
system-reboot: ## Reboot system
	@./scripts/system.sh reboot

##@ Git
git: ## Configure git
	@./scripts/git.sh configure

##@ Gnome Terminal
gnome-terminal: ## Configure gnome-terminal (install themes)
	@./scripts/gnome-terminal.sh configure

##@ Containers
containers: docker docker-compose ## Setup docker and docker-compose
docker: docker-install docker-configure ## ├ Install and configure docker
docker-install:
	@./scripts/docker.sh install
docker-configure:
	@./scripts/docker.sh configure
docker-compose: docker-compose-install docker-compose-configure ## └ Install and configure docker-compose
docker-compose-install:
	@./scripts/docker-compose.sh install
docker-compose-configure:
	@./scripts/docker-compose.sh configure

##@ Terminal
terminal: zsh ohmyzsh fzf ## Setup the terminal (zsh+ohmyzsh+fzf)
zsh: ## ├ Configure zsh (already install with system)
	@./scripts/zsh.sh configure
ohmyzsh: ohmyzsh-install ohmyzsh-configure ## ├ Install and configure Oh My Zsh
ohmyzsh-install:
	@./scripts/ohmyzsh.sh install
ohmyzsh-configure:
	@./scripts/ohmyzsh.sh configure
fzf: ## └ Install FZF
	@./scripts/fzf.sh install

##@ Tools
tools: lsd bat  ## Setup other tools (like lsd or bat)
lsd: ## ├ Install lsd
	@./scripts/lsd.sh install
bat: bat-install bat-configure ## └ Install and configure bat
bat-install:
	@./scripts/bat.sh install
bat-configure:
	@./scripts/bat.sh configure