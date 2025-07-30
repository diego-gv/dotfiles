#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

add_key() {

    wget -qO - "$1" | sudo apt-key add - &> /dev/null
    #     │└─ write output to file
    #     └─ don't show output

}

add_ppa() {
    sudo add-apt-repository -y ppa:"$1" &> /dev/null
}

add_repo() {
    sudo add-apt-repository -y "$1" &> /dev/null
}

add_cache() {
    sudo apt-cache "$1" &> /dev/null
}

add_to_source_list() {
    sudo sh -c "printf 'deb $1' >> '/etc/apt/sources.list.d/$2'"
}

autoremove() {

    # Remove packages that were automatically installed to satisfy
    # dependencies for other packages and are no longer needed.

    execute \
        "sudo aptitude remove -yq" \
        "Aptitude (autoremove)"

}

install_package() {

    declare -r EXTRA_ARGUMENTS="$3"
    declare -r PACKAGE="$2"
    declare -r PACKAGE_READABLE_NAME="$1"

    if ! package_is_installed "$PACKAGE"; then
        execute  \
            "export DEBIAN_FRONTEND=\"noninteractive\" \
                && sudo aptitude install -yq $EXTRA_ARGUMENTS $PACKAGE" "$PACKAGE_READABLE_NAME"
        #           assume "yes" as the answer ─┘│
        #                      suppress output ──┘
    else
        print_success "$PACKAGE_READABLE_NAME"
    fi

}

package_is_installed() {
    dpkg -s "$1" &> /dev/null
}

install_aptitude() {

    # Install aptitude package manager

    if ! package_is_installed "aptitude"; then

        execute \
            "sudo apt-get install -yq $EXTRA_ARGUMENTS aptitude" \
            "Aptitude (install)"

    fi

}

update() {

    # Resynchronize the package index files from their sources.

    execute \
        "export DEBIAN_FRONTEND=\"noninteractive\" \
            && sudo aptitude update -yq" \
        "Aptitude (update)"

}

upgrade() {

    # Install the newest versions of all packages installed.

    execute \
        "export DEBIAN_FRONTEND=\"noninteractive\" \
            && sudo aptitude -o Dpkg::Options::=\"--force-confnew\" safe-upgrade -yq" \
        "Aptitude (upgrade)"

}

refresh() {

    # Update snap packages
    execute \
        "sudo snap refresh --list" \
        "SNAP (refresh)"

    # Update monitors configuration for login screen
    local dest="/var/lib/gdm3/.config/monitors.xml"
    execute \
        "sudo rm -rf ${dest} && sudo cp -f ${HOME}/.config/monitors.xml ${dest}" \
        "Monitors config (refresh)"


}

cleanup() {

    # Clean up system
    execute \
        "rm -rf $HOME/.zcompdump*" \
        "Compinit results (clear)"
    autoremove
}
