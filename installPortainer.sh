#!/bin/bash

PortainerVersion=2.11.0

echo "The following script will install Portainer version "$PortainerVersion""
read -r -p "Do you wish to proceed with this version? [Y/N] " input 

case $input in
	[yY][eE][sS]|[yY])
	      #test echo
	      echo "Answered Yes..."
	      #actual command to run
	      echo "docker volume create portainer_data"
	      docker volume create portainer_data
	      echo "docker run -d -p 8000:8000 -p 9443:9443 --name portainer \
	      --restart=always \
	      -v /var/run/docker.sock:/var/run/docker.sock \
	      -v portainer_data:/data \
	      portainer/portainer-ce:"$PortainerVersion""
	      docker run -d -p 8000:8000 -p 9443:9443 --name portainer \
	        --restart=always \
	        -v /var/run/docker.sock:/var/run/docker.sock \
	        -v portainer_data:/data \
	        portainer/portainer-ce:"$PortainerVersion"
	      ;;
	[nN][oO]|[nN])
	      #test echo
	      echo "Answered No..."
	      read -r -p "What version number do you want installed? " newversion
	      PortainerVersion=$newversion
	      echo "newversion = $newversion"
	      echo "PortainerVersion = $PortainerVersion"
	      
	      echo "docker volume create portainer_data"
	      docker volume create portainer_data
	
              echo "docker run -d -p 8000:8000 -p 9443:9443 --name portainer \
	        --restart=always \
	        -v /var/run/docker.sock:/var/run/docker.sock \
	        -v portainer_data:/data \
	        portainer/portainer-ce:"$PortainerVersion""
	      docker run -d -p 8000:8000 -p 9443:9443 --name portainer \
	        --restart=always \
	        -v /var/run/docker.sock:/var/run/docker.sock \
	        -v portainer_data:/data \
	        portainer/portainer-ce:"$PortainerVersion"
	      ;;
	*)
	      echo "Invalid input... quiting installer."
	      exit 1
	      ;;

esac
