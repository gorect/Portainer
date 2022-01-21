#!/bin/bash
PortainerVersion=2.11.0
echo "The following script will install Portainer version "$PortainerVersion""

read -r -p "Do you wish to proceed with this version? [Y/n] " input
 
case $input in
      [yY][eE][sS]|[yY])
            echo "Do you wish to install this program?"
            select yn in "Yes" "No"; do
            case $yn in
                Yes ) echo "docker volume create portainer_data"
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
                      ; break;;
                      No ) exit;;
                  esac
            ;;
      [nN][oO]|[nN])
            read -r -p "What version do you want to install?" PortainerVersion
            ;;
      *)
            echo "Invalid input..."
            exit 1
            ;;
esac

## Script needs am if else to complete.
## Ideal function is, Script will install version 2.11.0 by default. Do you want to install that or another version?
## If neither, option to exit script.
## Once done below script should install with no problems. (Maybe add check for prexisting portainer_data volume?)






#echo "docker volume create portainer_data"
#docker volume create portainer_data
#
#echo "docker run -d -p 8000:8000 -p 9443:9443 --name portainer \
#    --restart=always \
#    -v /var/run/docker.sock:/var/run/docker.sock \
#    -v portainer_data:/data \
#    portainer/portainer-ce:"$PortainerVersion""
#docker run -d -p 8000:8000 -p 9443:9443 --name portainer \
#    --restart=always \
#    -v /var/run/docker.sock:/var/run/docker.sock \
#    -v portainer_data:/data \
#    portainer/portainer-ce:"$PortainerVersion"
