#!/bin/bash

# Variables
DOCKER_PACKAGES="docker.io docker-doc docker-compose podman-docker containerd runc"
DOCKER_INSTALL_PACKAGES="docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin"
DOCKER_KEYRING_PATH="/etc/apt/keyrings/docker.gpg"
DOCKER_LIST_PATH="/etc/apt/sources.list.d/docker.list"

# Functions
update_system() {
  echo "Update system ...\n"
  sudo apt-get update -y
  sudo apt-get upgrade -y
}

clean_old_docker() {
  echo "Cleaning old docker installation ..."
  for pkg in $DOCKER_PACKAGES; do sudo apt-get remove $pkg; done
}

install_docker() {
  echo "Installing docker ...\n"
  sudo apt-get install ca-certificates curl gnupg -y

  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o $DOCKER_KEYRING_PATH
  sudo chmod a+r $DOCKER_KEYRING_PATH

  echo \
    "deb [arch="$(dpkg --print-architecture)" signed-by=$DOCKER_KEYRING_PATH] https://download.docker.com/linux/ubuntu \
    "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
    sudo tee $DOCKER_LIST_PATH > /dev/null

  sudo apt-get update -y
  sudo apt-get install $DOCKER_INSTALL_PACKAGES -y
  sudo chmod 666 /var/run/docker.sock
}

install_docker_compose() {
  echo "\n\nInstalling docker-compose ...\n"
  sudo apt-get install docker-compose -y
  sudo ln -s /usr/bin/docker-compose /usr/local/bin/docker-compose
}

install_fish() {
  echo "\n\nInstalling Fish Shell...'n"
  sudo apt-get install fish -y
}

# Main
update_system
clean_old_docker
install_docker
install_docker_compose
install_fish