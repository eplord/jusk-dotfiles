#!/usr/bin/env bash

# docker is installed
DOCKER_FOLDER="$HOME/.docker"
if not_installed "docker"; then

    printf "Installing docker...\n"
    
    # Create folder
    mkdir -p "$DOCKER_FOLDER"

    # Requirements
    install apt-transport-https ca-certificates curl gnupg-agent \
        software-properties-common

    # Add repository
    add_key "https://download.docker.com/linux/ubuntu/gpg"
    sudo add-apt-repository -y \
        "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) \
        stable"
    update

    # Install
    install docker-ce

    # Chown
    sudo chown "$USER":"$USER" "$DOCKER_FOLDER" -R
    sudo chmod g+rwx "$DOCKER_FOLDER" -R

fi
printf "docker is installed\n"
docker --version

# docker-compose if installed
if not_installed "docker-compose"; then

    printf "Installing docker-compose...\n"

    # Docker-compose
    pip3 install --user docker-compose

fi
printf "docker-compose is installed, upgrading\n"
pip3 install --upgrade docker-compose
docker-compose --version

# docker group exists
readonly docker_group='docker'
if ! grep -q "$docker_group" /etc/group; then
    sudo groupadd "$docker_group"
fi
printf "group '$docker_group' is created\n"

# user is in docker group
if ! groups "$USER" | grep -q "\b$docker_group\b"; then
    sudo usermod -aG docker "$USER"
fi
printf "user '$USER' is in '$docker_group' group\n"