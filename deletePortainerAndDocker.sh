#!/usr/bin/env bash

#Remove Portainer
docker container rm -f portainer

#Remove Docker
sudo apt-get purge docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras

#Exit Message
read -p "docker ps " docker ps
