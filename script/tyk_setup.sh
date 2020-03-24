#! /bin/bash
# This script will set up a full tyk environment on your cluster
# you need to provide the host adress (and port) of the tyk gateway server


usage() {
# -----
#
echo usage:
echo "${0} <TYK_IP_ADDRESS> <PORT>"

}

if [ $# -ne 2 ]; then 
  usage
  exit 1
fi


sed -i -r 's/KC_SECRET": "[a-zA-Z0-9]*"/KC_SECRET": "'"$KC_SECRET"'"/g'   ${LOCAL_TYK_CONFIG_PATH}/api_auth.json


CONT_ID=$(docker ps  | grep ${CONTAINER_NAME_CANDIG_GATEWAY}_1 | cut -d " " -f1)
echo restarting Tyk 
docker restart ${CONT_ID}



echo "DONE"
