#!/usr/bin/env bash



usage (){

echo
echo "usage: $0 -o <config_file>"
echo
echo "   -o        Config file path, default is ./config_resource."
echo "   -d        Deleted existing named volume for tyk db"
echo "              (redis-data and mongo-data). Docker cli needs to"
echo "              have been installed"
}




CONFIG_FILE=./config_resource

while getopts "do:" opt; do
  case $opt in
    o)
      CONFIG_FILE=$OPTARG
      ;;
    d)
      DELETE_CONFIG_VOLUME=true
      ;;
   \?)
      usage
      exit 1
      ;;
  esac
done



if [ ! -f ${CONFIG_FILE} ]; then
    echo ${CONFIG_FILE} not found
    usage
    exit 1
fi

source ${CONFIG_FILE}
# export all config file variables
# the sed remove comments

# admin to put in the .env file
export KEYCLOAK_USER=${KC_ADMIN_USER}
export KEYCLOAK_PASSWORD=${KC_PW}

# Some port cleaning and reordering,
# remove default port from http and https
CD_PUB_PORT=:${CANDIG_PUBLIC_PORT}
CD_PUB_PORT=${CD_PUB_PORT%:80}
export CD_PUB_PORT=${CD_PUB_PORT%:443}
KC_PUB_PORT=:${KC_PUBLIC_PORT}
KC_PUB_PORT=${KC_PUB_PORT%:80}
export KC_PUB_PORT=${KC_PUB_PORT%:443}


CANDIG_HOST_NAME="${CANDIG_PUBLIC_URL#http://}"
export CANDIG_HOST_NAME="${CANDIG_HOST_NAME=#https://}"

KC_HOST_NAME="${KC_PUBLIC_URL#http://}"
export KC_HOST_NAME="${KC_HOST_NAME=#https://}"


if [ -n "${DELETE_CONFIG_VOLUME}" ]; then
  echo deleting yml_mongo-data yml_redis-data if present
  docker volume rm yml_mongo-data yml_redis-data 2> /dev/null

fi

mkdir -p "${OUPTUT_CONFIGURATION_DIR}"

cp -r "${INPUT_TEMPLATE_DIR}"/config.tpl/*  "${OUPTUT_CONFIGURATION_DIR}"

echo Creating the Candig config files
find ${INPUT_TEMPLATE_DIR}/config.tpl -type f -name '*.tpl' -print0 |
    while IFS= read -r -d $'\0' line; do

        output=${line#${INPUT_TEMPLATE_DIR}/config.tpl/}
        output=${output%.tpl}

       cat $line | envsubst > ${OUPTUT_CONFIGURATION_DIR}/${output}

    done
mkdir -p ${LOCAL_CANDIG_CONFIG_PATH}
echo -e "issuer\tusername\tmock_data" > ${LOCAL_CANDIG_CONFIG_PATH}/access_list.tsv
echo -e "${KC_PUBLIC_URL}${KC_PUB_PORT}/auth/realms/${KC_REALM}\t${KC_TEST_USER}\t4" \
   >> ${LOCAL_CANDIG_CONFIG_PATH}/access_list.tsv

echo Done

mkdir -p ./yml/

echo Creating the Candig compose yml
 cat ${INPUT_TEMPLATE_DIR}/compose.tpl/volumes.yml.tpl | envsubst > ./yml/volumes.yml
 cat ${INPUT_TEMPLATE_DIR}/compose.tpl/containers_network.yml.tpl | envsubst > ./yml/containers_network.yml


 echo Done
