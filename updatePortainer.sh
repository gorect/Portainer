#!/bin/bash
read -p "What is the Portainer version that you would like to upgrade to? " PortainerVersion

#Future goal, add a check to make sure that you pick an approprate Portainer version, or that you are not upgrading to the same version that you are already running.

echo "docker stop portainer"
docker stop portainer
sleep 2
echo "docker rm portainer"
docker rm portainer
sleep 2
echo "docker pull portainer/portainer-ce:"$PortainerVersion""
docker pull portainer/portainer-ce:"$PortainerVersion"
sleep 2
echo "docker run -d -p 8000:8000 -p 9000:9000 -p 9443:9443 \
    --name=portainer --restart=always \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v portainer_data:/data \
    portainer/portainer-ce:"$PortainerVersion""
docker run -d -p 8000:8000 -p 9000:9000 -p 9443:9443 \
 --name=portainer --restart=always \
 -v /var/run/docker.sock:/var/run/docker.sock \
 -v portainer_data:/data \
 portainer/portainer-ce:"$PortainerVersion"
 
 echo "Your Portainer instance has been updated to version "$PortainerVersion"!"
