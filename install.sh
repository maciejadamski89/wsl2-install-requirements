#!/bin/bash

# Install all needed stuffs for WSL2

echo "Update system ...\n"
sudo apt-get update -y
sudo apt-get upgrade -y

echo "Cleaning old docker installation ..."
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done

echo "Installing docker ...\n"
sudo apt-get update -y
sudo apt-get install ca-certificates curl gnupg -y

sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update -y
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
sudo chmod 666 /var/run/docker.sock

echo "\n\nInstalling docker-compose ...\n"
sudo apt-get install docker-compose -y
sudo ln -s /usr/bin/docker-compose /usr/local/bin/docker-compose

echo "\n\nInstalling Fish Shell...'n"
sudo apt-get install fish -y