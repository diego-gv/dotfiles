IMAGE_NAME ?= dotfiles-new-hope
IMAGE_TAG ?= ubuntu-25.04
DOCKER_IMAGE := $(IMAGE_NAME):$(IMAGE_TAG)
DOCKERFILE := .docker/ubuntu.Dockerfile

.PHONY: build test-bootstrap test-install run _docker-build

build:
	@docker build -t $(DOCKER_IMAGE) -f $(DOCKERFILE) .

test-bootstrap: _docker-build
	@docker run --rm --pull=never \
		-e TERM=xterm-256color \
		-v "$(CURDIR):/home/garvi/.dotfiles" \
		-w /home/garvi/.dotfiles \
		$(DOCKER_IMAGE) \
		bash -lc "set -euo pipefail; shellcheck bootstrap.sh scripts/*.sh core/*.sh; bash ./bootstrap.sh"

test-install: _docker-build
	@docker run --rm --pull=never \
		-e TERM=xterm-256color \
		-v "$(CURDIR):/workspace" \
		-w /tmp \
		$(DOCKER_IMAGE) \
		bash -lc "set -euo pipefail; rm -rf \"$$HOME/.dotfiles\"; cp /workspace/bootstrap.sh /tmp/bootstrap.sh; tar -czf /tmp/dotfiles.tar.gz -C /workspace .; DOTFILES_ARCHIVE_URL=file:///tmp/dotfiles.tar.gz bash /tmp/bootstrap.sh"

run: _docker-build
	@docker run --hostname $(DOCKER_IMAGE) --rm -it --pull=never \
		-v "$(CURDIR):/workspace" \
		-w /workspace \
		$(DOCKER_IMAGE)

_docker-build:
	@docker image inspect $(DOCKER_IMAGE) >/dev/null 2>&1 || $(MAKE) build
