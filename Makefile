.PHONY: lint validate shell

DOCKER_IMAGE := dotfiles-ubuntu-validation:local

lint:
	shellcheck install.sh scripts/components/base.sh .docker/entrypoint.sh
	bash -n install.sh scripts/components/base.sh .docker/entrypoint.sh

validate: lint
	docker build --tag $(DOCKER_IMAGE) --file .docker/Dockerfile.ubuntu .docker
	docker run --rm --mount type=bind,src="$(CURDIR)",dst=/root/.dotfiles,readonly $(DOCKER_IMAGE)

shell:
	docker build --tag $(DOCKER_IMAGE) --file .docker/Dockerfile.ubuntu .docker
	docker run --rm --interactive --tty --entrypoint bash --mount type=bind,src="$(CURDIR)",dst=/root/.dotfiles,readonly $(DOCKER_IMAGE)
