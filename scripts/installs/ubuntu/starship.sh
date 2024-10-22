#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh"
    
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


install() {

    if ! cmd_exists "starship"; then
        sh -c "$(curl -sS https://starship.rs/install.sh)" "" --yes &> /dev/null
    fi

    
}


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    execute "install" "Starship"

}

main
