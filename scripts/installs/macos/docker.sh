#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh" \
    && . "./utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Docker
# ---------------
# https://www.cprime.com/resources/blog/docker-for-mac-with-homebrew-a-step-by-step-tutorial/
# https://formulae.brew.sh/formula/docker
# https://formulae.brew.sh/formula/docker-completion
# https://docs.docker.com/engine/cli/completion/

# Docker-compose
# ---------------
# https://docs.docker.com/compose/install/

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

brew_install "Install" "docker-ce"
