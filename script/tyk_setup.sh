#! /bin/bash
# This script will set up a full tyk environment on your cluster
# you need to provide the host adress (and port) of the tyk gateway server


# USAGE
# -----
#
# $> ./tyk_setup.sh {IP ADDRESS:PORT of the tyk gateway}



TYK_ORGANOSATION="Secure Cloud CQ"
TYK_ORG_SHORT_NAME="SCCQ"

TYK_ORG_FN="Omni"
TYK_ORG_LN="Potent"

TYK_API_SECRET=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
sed -r 's/secret": "[a-zA-Z0-9]*"/secret": "'"$TYK_API_SECRET"'"/g'   ${LOCAL_TYK_CONFIG_PATH}/tyk.conf

sed -i -r 's/KC_SECRET": "[a-zA-Z0-9]*"/KC_SECRET": "'"$KC_SECRET"'"/g'   ${LOCAL_TYK_CONFIG_PATH}/api_auth.json


#API CONFIG Source the python file like a bash one, Only vars are define,
# make sure they are written in a BASH WAY, (no space around "=")
export KC_LOGIN_REDIRECT_PATH
export TYK_LISTEN_PATH
export KC_ISSUER=${KC_PUBLIC_URL}${KC_PUB_PORT}/auth/realms/${KC_REALM}


# Tyk portal settings

TYK_PORTAL_PATH="/portal/"

DOCKER_IP="127.0.0.1"

if [ -n "$DOCKER_HOST" ]
then
		echo "Detected a Docker VM..."
		REMTCP=${DOCKER_HOST#tcp://}
		DOCKER_IP=${REMTCP%:*}
fi

if [ -n "$1" ]
then
		DOCKER_IP=$1
		echo "Docker host address explicitly set."
		echo "Using $DOCKER_IP as Tyk host address."
fi

if [ -n "$2" ]
then
		CANDIG_PUBLIC_URL=$2
		echo "Docker portal domain address explicitly set."
		echo "Using ${CANDIG_PUBLIC_URL} as Tyk host address."
fi

if [ -z "$1" ]
then
        echo "Using $DOCKER_IP as Tyk host address."
        echo "If this is wrong, please specify the instance IP address (e.g. ./setup.sh 192.168.1.1)"
fi


SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

# reload
curl -s "http://${CANDIG_PUBLIC_URL}/tyk/reload/group" -H "Content-Type: application/json" -H "x-tyk-authorization: ${TYK_API_SECRET}"


echo "DONE"
