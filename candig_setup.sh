#! /bin/bash

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



source  ${CONFIG_FILE}
source ./script/kc_setup.sh
./script/tyk_setup.sh
