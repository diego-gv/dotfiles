#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh" \
    && . "./utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

easy_install_application "teams-for-linux" "Teams (for Linux)"
easy_install_application "outlook-for-linux" "Outlook (for Linux)"
easy_install_application "slack" "Slack"

