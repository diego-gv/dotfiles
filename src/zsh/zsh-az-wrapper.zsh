#!/usr/bin/env zsh
# vim: set filetype=zsh

# Wrapper function to automate Azure CLI login and Azure Container Registry login.
#
# - Runs Azure CLI non-interactively with TLS certificate verification enabled using the system CA bundle.
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
    local ca_bundle="/etc/ssl/certs/ca-certificates.crt"

    yes | REQUESTS_CA_BUNDLE="$ca_bundle" env -u AZURE_CLI_DISABLE_CONNECTION_VERIFICATION az login \
        && REQUESTS_CA_BUNDLE="$ca_bundle" env -u AZURE_CLI_DISABLE_CONNECTION_VERIFICATION az acr login -n "$1"
}
