include test.mk
include colors.mk

.DEFAULT_GOAL := all
.PHONY: git zsh starship fzf lsd bat docker docker-compose gnome-terminal alacritty

##@ Commands
all: system git terminal tools containers system-reboot ## Install and configure everything (default)
help: ## Display help
	@awk 'BEGIN {FS = ":.*##"; printf "${BNC}Usage${NC}: make ${CYAN}<target>${NC}\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  ${CYAN}%-20s${NC} %s\n", $$1, $$2 } /^##@/ { printf "\n${BYELLOW}%s${NC}\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ System
system: system-install system-configure ## Install system packages and configure system (directories, fonts, etc)
system-install:
	@./scripts/system.sh install
system-configure:
	@./scripts/system.sh configure
system-reboot: ## Reboot system
	@./scripts/system.sh reboot

##@ Git
git: ## Configure git (already install with system)
	@./scripts/git.sh configure

##@ Terminal
terminal: alacritty zsh ohmyzsh starship ## Setup the terminal (zsh+ohmyzsh+starship)
gnome-terminal: ## ├ Configure gnome-terminal (install themes)
	@./scripts/gnome-terminal.sh configure
alacritty: ## ├ Configure alacritty (already install with system)
	@./scripts/alacritty.sh configure
zsh: ## ├ Configure zsh (already install with system)
	@./scripts/zsh.sh configure
ohmyzsh: ohmyzsh-install ohmyzsh-configure ## ├ Install and configure Oh My Zsh
ohmyzsh-install:
	@./scripts/ohmyzsh.sh install
ohmyzsh-configure:
	@./scripts/ohmyzsh.sh configure
starship: starship-install starship-configure ## └ Install and configure Starship
starship-install:
	@./scripts/starship.sh install
starship-configure:
	@./scripts/starship.sh configure

##@ Tools
tools: fzf lsd bat ## Setup other tools (like FZF, lsd or bat)
fzf: fzf-install fzf-configure ## ├ Install and configure FZF
fzf-install: 
	@./scripts/fzf.sh install
fzf-configure:
	@./scripts/fzf.sh configure
lsd: ## ├ Install lsd
	@./scripts/lsd.sh install
bat: bat-install bat-configure ## └ Install and configure bat
bat-install:
	@./scripts/bat.sh install
bat-configure:
	@./scripts/bat.sh configure

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