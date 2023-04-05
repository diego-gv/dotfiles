ifdef UBUNTU_VERSION
UBUNTU_VERSION := $(subst ubuntu-,,$(UBUNTU_VERSION))
else
UBUNTU_VERSION = 22.04
endif

##@ Testing makefile
test: build ## Build and run tests
	docker run -t --rm dotfiles/test make
build: ## └ Build a docker image
	docker build -t dotfiles/test --build-arg UBUNTU_VERSION=$(UBUNTU_VERSION) .
