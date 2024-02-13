ifdef UBUNTU_VERSION
UBUNTU_VERSION := $(subst ubuntu-,,$(UBUNTU_VERSION))
else
UBUNTU_VERSION = 22.04
endif

##@ Testing makefile
test: build ## Build and run tests
	docker run -t --rm dotfiles/test make
bash: build ## Build and entry bash
	docker run -it --rm -v ${PWD}:/home/test/dotfiles dotfiles/test /bin/bash
interactive: build ## Build, run tests and entry zsh
	docker run -it --rm -v ${PWD}:/home/test/dotfiles dotfiles/test bash -c "make ; zsh"
build: ## └ Build a docker image
	docker build -t dotfiles/test --build-arg UBUNTU_VERSION=$(UBUNTU_VERSION) .
