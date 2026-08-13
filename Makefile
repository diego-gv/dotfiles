IMAGE_NAME ?= dotfiles-new-hope
IMAGE_TAG ?= ubuntu-25.04
DOCKER_IMAGE := $(IMAGE_NAME):$(IMAGE_TAG)
DOCKERFILE := .docker/ubuntu.Dockerfile

.PHONY: test run _docker-build _docker-build-force

test: _docker-build
	docker run --rm --pull=never \
		-e TERM=xterm-256color \
		-v "$(CURDIR):/home/garvi/.dotfiles" \
		-w /home/garvi/.dotfiles \
		$(DOCKER_IMAGE) \
		bash -lc "set -euo pipefail; shellcheck bootstrap.sh scripts/*.sh core/*.sh; bash ./bootstrap.sh"

run: _docker-build
	docker run --hostname $(DOCKER_IMAGE) --rm -it --pull=never \
		-v "$(CURDIR):/home/garvi/.dotfiles" \
		-w /home/garvi/.dotfiles \
		$(DOCKER_IMAGE)

_docker-build:
	@docker image inspect $(DOCKER_IMAGE) >/dev/null 2>&1 || $(MAKE) _docker-build-force

_docker-build-force:
	docker build -t $(DOCKER_IMAGE) -f $(DOCKERFILE) .
