#!/usr/bin/env bash

Err() {
	printf 'Err: %s\n' "$2" 1>&2
	(( $1 > 0 )) && exit $1
}

DockerCMD() {
    docker stop portainer
    docker rm portainer
    docker pull portainer/portainer-ce:"$PortainerVersion"
    docker run -d -p 8000:8000 -p 9000:9000 -p 9443:9443 \
     --name=portainer --restart=always \
     -v /var/run/docker.sock:/var/run/docker.sock \
     -v portainer_data:/data \
     portainer/portainer-ce:"$PortainerVersion"
}

ChkVerStr() {
	if [[ $1 =~ ^[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+$ ]]; then
		return 0
	else
		Err 0 'Invalid version string -- try again.'
		return 1
	fi
}

if ! type -P docker &> /dev/null; then
	Err 1 "Dependency 'docker' not found."
fi

read -p "What Portainer version would you like to upgrade to? " PortainerVersion

#Future goal, add a check to make sure that you are not upgrading to the same version that is already running.

while :; do
    read -p 'Proceed with v'"$PortainerVersion"'? [Y/N/Q] ? '
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
