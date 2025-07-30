# Environment
SHELL := /bin/bash
DOTFILES := $(PWD)
OSTYPE := $(shell uname -s)
ARCHITECTURE := $(shell uname -m)
DEVNUL := /dev/null
WHICH := which

# Docker arch
DOCKER_IMAGE := ubuntu
PATH := $(PATH):/usr/local/bin:/usr/local/sbin:/usr/bin:$(HOME)/bin:/$(HOME)/.local/bin
ifeq ($(ARCHITECTURE), arm64)
DOCKER_BUILD_CMD := build --platform linux/amd64 --quiet --rm
PATH := $(PATH):/opt/homebrew/bin:/opt/homebrew/sbin
else
DOCKER_BUILD_CMD := build --quiet --rm
endif

# Colors
NC := \033[0m
BNC := \033[1m

BLACK := \033[0;30m
RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[0;33m
BLUE := \033[0;34m
PURPLE := \033[0;35m
CYAN := \033[0;36m
WHITE := \033[0;37m

BBLACK := \033[1;30m
BRED := \033[1;31m
BGREEN := \033[1;32m
BYELLOW := \033[1;33m
BBLUE := \033[1;34m
BPURPLE := \033[1;35m
BCYAN := \033[1;36m
BWHITE := \033[1;37m

# Messages
MSG := ""

print_title:
	@printf "${BPURPLE}${MSG}${NC}"

print_subtitle:
	@printf "${BBLUE}${MSG}${NC}"

print_debug:
	@printf "${BCYAN}${MSG}${NC}"

print_info:
	@printf "${BGREEN}${MSG}${NC}"

print_warning:
	@printf "${BYELLOW}${MSG}${NC}"

print_error:
	@printf "${BRED}${MSG}${NC}"


## Compatibility with easy-to-use arguments
# If the first argument is "logs"...
ifeq (test,$(firstword $(MAKECMDGOALS)))
  # use the rest as arguments for "logs"
  RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  # ...and turn them into do-nothing targets
  $(eval $(RUN_ARGS):;@:)
endif


.PHONY: colorlog
colorlog:
	@$(MAKE) MSG="\n • Title message\n\n" print_title
	@$(MAKE) MSG="\n • Subtitle message\n\n" print_subtitle
	@$(MAKE) MSG="\n • Test debug message\n\n" print_debug
	@$(MAKE) MSG="\n • Test info message\n\n" print_info
	@$(MAKE) MSG="\n • Test warning message\n\n" print_warning
	@$(MAKE) MSG="\n • Test error message\n\n" print_error

.PHONY: calltest
calltest:
	@$(MAKE) colorlog
