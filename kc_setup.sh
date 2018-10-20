#!/bin/bash

source $CONFIG_PATH/keycloak/configuration/secrets
source $CONFIG_PATH/ga4gh_server/config.py 2> /dev/null

# Default values
export KC_HOST=$(echo $KC_SERVER | cut -f1 -d:)
export KC_PORT=$(echo $KC_SERVER | cut -f2 -d:)
TYK_DOMAIN=$(echo $TYK_SERVER | cut -f1 -d:)


usage () {

  echo "${0} [<keycloak host> <keycloak api port>]"

}


if [[ $# -eq 1 ]]; then
   usage
   exit 1
elif [[ $# -eq 2 ]]; then
  KC_HOST=$1
  KC_PORT=$2
elif [[ $# -gt 2 ]]; then
  usage
  exit 1
fi


# FUNCTIONS

valid_json () {

  putative=${1}

  echo $putative | python -c 'import json,sys;obj=json.load(sys.stdin)' 2> /dev/null
  ret_val=$?
  if [ $ret_val = 0 ]; then
     echo JSON is valid
  else
     echo JSON is not valid
     exit $ret_val
  fi

}

###############

get_token () {
  BID=$(curl \
    -d "client_id=admin-cli" \
    -d "username=$KC_ADMIN_USER" \
    -d "password=$KC_PW" \
    -d "grant_type=password" \
    "http://${KC_HOST}:${KC_PORT}/auth/realms/master/protocol/openid-connect/token" 2> /dev/null )
  echo ${BID} | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["access_token"]'
}

######################

set_realm () {
  realm=$1

  JSON='{
  "realm": "'"${realm}"'",
  "enabled": true
}'


  curl \
    -H "Authorization: bearer ${KC_TOKEN}" \
    -X POST -H "Content-Type: application/json"  -d "${JSON}" \
    "http://${KC_HOST}:${KC_PORT}/auth/admin/realms"

}

#######################

get_realm () {
  realm=$1
curl \
  -H "Authorization: bearer ${KC_TOKEN}" \
  "http://${KC_HOST}:${KC_PORT}/auth/admin/realms/${realm}" | jq .
}


get_realm_clients () {
  realm=$1

curl \
  -H "Authorization: bearer ${KC_TOKEN}" \
  "http://${KC_HOST}:${KC_PORT}/auth/admin/realms/${realm}/clients" | jq -S .
}


#################################
set_client () {
realm=$1
client=$2
listen=$3
redirect=$4

# Will add / to listen onlu if it is present


  JSON='{
  "clientId": "'"${client}"'",
  "enabled": true,
  "protocol": "openid-connect",
  "implicitFlowEnabled": true,
  "standardFlowEnabled": true,
  "publicClient": false,
  "redirectUris": [
   "'${TYK_SERVER%/}/${listen}${redirect}'"
   ],
  "attributes": {
    "saml.assertion.signature": "false",
    "saml.authnstatement": "false",
    "saml.client.signature": "false",
    "saml.encrypt": "false",
    "saml.force.post.binding": "false",
    "saml.multivalued.roles": "false",
    "saml.onetimeuse.condition": "false",
    "saml.server.signature": "false",
    "saml.server.signature.keyinfo.ext": "false",
    "saml_force_name_id_format": "false"
  }
}'


  curl \
    -H "Authorization: bearer ${KC_TOKEN}" \
    -X POST -H "Content-Type: application/json"  -d "${JSON}" \
    "http://${KC_HOST}:${KC_PORT}/auth/admin/realms/${realm}/clients"
}

get_secret () {

  id=$(curl -H "Authorization: bearer ${KC_TOKEN}" \
    http://${KC_HOST}:${KC_PORT}/auth/admin/realms/candig/clients 2> /dev/null \
    | python -c 'import json,sys;obj=json.load(sys.stdin); print [l["id"] for l in obj if l["clientId"] == "'"$KC_CLIENT_ID"'" ][0]')

  curl -H "Authorization: bearer ${KC_TOKEN}" \
    http://${KC_HOST}:${KC_PORT}/auth/admin/realms/candig/clients/$id/client-secret 2> /dev/null |\
    python -c 'import json,sys;obj=json.load(sys.stdin); print obj["value"]'

}
##################################

# SCRIPT START

KC_TOKEN=$(get_token)

echo Create realm ${KC_REALM}
set_realm ${KC_REALM}


echo create_client ${KC_CLIENT_ID}
set_client ${KC_REALM} ${KC_CLIENT_ID} "${TYK_LISTEN_PATH}" ${KC_LOGIN_REDIRECT_PATH}

echo getting kc client secret
export KC_SECRET=$(get_secret)
