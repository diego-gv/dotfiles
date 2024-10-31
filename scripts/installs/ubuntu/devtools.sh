#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh" \
    && . "./utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

install_postman() {

    if ! dir_exists "/opt/Postman"; then
        tar -C /tmp/ -xzf <(curl -L https://dl.pstmn.io/download/latest/linux64) && sudo mv /tmp/Postman /opt/
    fi
    
}

create_postman_desktop_file() {

    echo "[Desktop Entry]
Name=Postman
Exec=/opt/Postman/Postman
Icon=/opt/Postman/app/resources/app/assets/icon.png
Terminal=false
Type=Application
Categories=Development;" | \
    sudo tee /usr/share/applications/postman.desktop &> /dev/null

}

add_dbeaver_repository() {

    if ! package_is_installed "dbeaver-ce"; then
        add_ppa "serge-rider/dbeaver-ce"
    fi
    
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

execute "install_postman" "Postman"
create_postman_desktop_file

add_dbeaver_repository
install_package "DBeaver" "dbeaver-ce"
