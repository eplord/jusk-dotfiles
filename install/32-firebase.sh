#!/usr/bin/env bash

if not_installed "firebase"; then
    echo "Installing firebase..."
    run "https://firebase.tools" "bash"
fi

echo "firebase is installed, upgrading..."
curl -sL firebase.tools | upgrade=true bash
firebase --version