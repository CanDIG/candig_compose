#!/usr/bin/env bash



usage (){

echo 
echo "usage: $0 -o <config_file>"
echo 
echo "   -o        default is ./config_resource."
echo "              To be created with the help of config_resource.tpl"
 
}




CONFIG_FILE=./config_resource

while getopts "o:" opt; do
  case $opt in
    o)
      CONFIG_FILE=$OPTARG  
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

CANDIG_HOST_NAME="${CANDIG_PUBLIC_URL#http://}"
export CANDIG_HOST_NAME="${CANDIG_HOST_NAME=#https://}"

KC_HOST_NAME="${KC_PUBLIC_URL#http://}"
export KC_HOST_NAME="${KC_HOST_NAME=#https://}"



mkdir -p ${OUPTUT_CONFIGURATION_DIR}

cp -r ${INPUT_TEMPLATE_DIR}/config.tpl/*  ${OUPTUT_CONFIGURATION_DIR}

echo Creating the Candig config files 
find ${INPUT_TEMPLATE_DIR}/config.tpl -type f -name '*.tpl' -print0 |
    while IFS= read -r -d $'\0' line; do

        output=${line#${INPUT_TEMPLATE_DIR}/config.tpl/}
        output=${output%.tpl}
        
       cat $line | envsubst > ${OUPTUT_CONFIGURATION_DIR}/${output}
       

    done

echo "${KC_TEST_USER}:clinical_metadata_tier:4" > ${LOCAL_GA4GH_CONFIG_PATH}/access_list.txt

echo Done

mkdir -p ./yml/

echo Creating the Candig compose yml 
 cat ${INPUT_TEMPLATE_DIR}/compose.tpl/volumes.yml.tpl | envsubst > ./yml/volumes.yml
 cat ${INPUT_TEMPLATE_DIR}/compose.tpl/containers_network.yml.tpl | envsubst > ./yml/containers_network.yml

 echo KEYCLOAK_USER=${KEYCLOAK_USER} > ${OUPTUT_CONFIGURATION_DIR}/secret.env
 echo KEYCLOAK_PASSWORD=${KEYCLOAK_PASSWORD} >> ${OUPTUT_CONFIGURATION_DIR}/secret.env
 
 
 echo Done
