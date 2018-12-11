#! /bin/bash

usage (){

echo
echo "usage: $0 -o <config_file> [OPTIONS]"
echo
echo "   -o    path"
echo "         default is ./config_resource. File is created with the help"
echo "         of config_resource.tpl"
echo "   -k hostname:port"
echo "         Keycloak host name or ip and port from where the script is"
echo "         executed"
echo "   -t hostname"
echo "         Tyk host name or ip"
}




CONFIG_FILE=./config_resource

T_HOST=""
K_HOST=""
K_PORT=""

while getopts "t:k:o:" opt; do
  case $opt in
    o)
      CONFIG_FILE=$OPTARG
      ;;
    t)
      T_HOST=$OPTARG
      ;;
    k)
      K_PORT=$(echo $OPTARG | cut -f2 -d:)
      K_HOST=$(echo $OPTARG | cut -f1 -d:)
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



source  ${CONFIG_FILE}
source ./script/kc_setup.sh $K_HOST $K_PORT
./script/tyk_setup.sh $T_HOST
