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
