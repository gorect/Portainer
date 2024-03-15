#!/usr/bin/env bash

PortainerVersion='2.11.0'

Err() {
	printf 'Err: %s\n' "$2" 1>&2
	(( $1 > 0 )) && exit $1
}

DockerCMD() {
	docker run -d -p 8000:8000 -p 9443:9443 --name portainer \
		--restart=always -v /var/run/docker.sock:/var/run/docker.sock \
		-v portainer_data:/data portainer/portainer-ce:"$1"
}

DockerInstall() {
    #Add Docker's official GPG key:
    sudo apt-get update
    sudo apt-get install ca-certificates curl gnupg
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg

    #Add the repository to Apt sources:
    echo \
    "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update

    #Install the latest version
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    
    #Use docker without Sudo
    USER=$(whoami)
    sudo usermod -aG docker $USER
    sudo systemctl enable --now docker
    read -p "For " $USER " to run docker commands without 'sudo' please log out and log back in again."
}

ChkVerStr() {
	if [[ $1 =~ ^[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+$ ]]; then
		return 0
	else
		Err 0 'Invalid version string -- try again.'
		return 1
	fi
}

#Checking for Docker installation
if ! type -P docker &> /dev/null; then
	Err 1 "Dependency 'docker' not found."
    read -p 'Would you like to install docker? [Y/N/Q] ? '
	case ${REPLY,,} in
		y|yes)
			DockerInstall
			exit $? ;;
		n|no)
			read -p 'Docker will not be installed. Quitting'
            sleep 3
            exit 0 ;;
		q|quit)
			exit 0 ;;
		'')
			Err 0 'Empty response -- try again.' ;;
		*)
			Err 0 'Invalid response -- try again.' ;;
	esac
fi

#Presenting the version of Portainer that will be installed
printf 'This script will install Portainer v%s.\n' "$PortainerVersion"

while :; do
	read -p 'Proceed with this version? [Y/N/Q] ? '
	case ${REPLY,,} in
		y|yes)
			DockerCMD "$PortainerVersion"
			exit $? ;;
		n|no)
			while :; do
				read -p 'Enter version: '
				if [[ -n $REPLY ]]; then
					ChkVerStr "$REPLY" || continue
					DockerCMD "$REPLY"
					exit $?
				else
					Err 0 'Empty response -- try again.'
				fi
			done ;;
		q|quit)
			exit 0 ;;
		'')
			Err 0 'Empty response -- try again.' ;;
		*)
			Err 0 'Invalid response -- try again.' ;;
	esac
done
