#!/usr/bin/env zsh
# vim: set filetype=zsh

# Wrapper function to automate Azure CLI login and Azure Container Registry login.
#
# - Runs `az login` and automatically answers "yes" to any prompts.
# - Then logs in to the specified Azure Container Registry (ACR) using `az acr login -n <registry-name>`.
#
# Usage:
#   azlogin <registry-name>
#
# Example:
#   azlogin myregistry
#
# This simplifies the login process by chaining both commands,
# useful for scripts or frequent authentications.
azlogin() {
    yes | az login ; az acr login -n $1
}
