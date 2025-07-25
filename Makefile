DEFAULT_GOAL := help
MAKEFLAGS += --no-print-directory

.PHONY: help
help: ## Display this help message
	@awk 'BEGIN {FS = ":.*##"; printf "${BNC}Usage${NC}: make ${CYAN}<target>${NC}\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  ${CYAN}%-20s${NC} %s\n", $$1, $$2 } /^##@/ { printf "\n${BYELLOW}%s${NC}\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ Commands
.PHONY: install
install: ## Run install and configure system
	@./scripts/setup.sh -y

##@ Testing
.PHONY: test
test: --build ## Test dotfiles with docker
	@docker run -e SKIP_QUESTIONS=true -it --rm -v ${PWD}:/home/garvi/.dotfiles --name test dotfiles/test /bin/bash -c "make install ; zsh"

--build:
	@RUN_ARGS_EFFECTIVE=$$(echo "$(RUN_ARGS)" | tr -d ' '); \
    if [ -z "$$RUN_ARGS_EFFECTIVE" ]; then RUN_ARGS_LOWER=ubuntu; \
    else RUN_ARGS_LOWER=$$(echo "$(RUN_ARGS)" | tr '[:upper:]' '[:lower:]' | tr ' ' '-'); fi; \
	case "$$RUN_ARGS_LOWER" in \
		ubuntu|fedora) ;; \
		macos) echo "It is not possible to test with macOS" && exit 1 ;; \
		*) echo "Invalid value: '$(RUN_ARGS)'. Only the following values are allowed: ubuntu or fedora" && exit 1 ;; \
	esac; \
	docker $(DOCKER_BUILD_CMD) -t dotfiles/test ${PWD} -f .docker/$$RUN_ARGS_LOWER.Dockerfile > ${DEVNUL}

include utils.mk
