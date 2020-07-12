#!/usr/bin/env bash
source "$(dirname $0)/utils.sh"
export PYTHON_KEYRING_BACKEND=keyring.backends.null.Keyring

# poetry is installed
if not_installed "poetry"; then

    printf "Installing poetry...\n"

    # Install poetry
    pip3 install --user poetry

fi
printf "poetry is installed, upgrading...\n"
pip3 install --upgrade poetry
poetry --version
