#!/bin/bash

KC_ISSUER=$KC_SERVER/auth/realms/$KC_REALM
 
ID_64=$(echo ${KC_CLIENT_ID} | base64)

up='{
"openid_options": {
      "providers": [
        {
          "issuer": "'"${KC_ISSUER}"'",
          "client_ids": {
            "'"${ID_64}"'": "'"$POL_ID"'"
          }
        }
      ],
      "segregate_by_client": false
}
}'



API_NEW=$(echo $API_DEF __TOTO__ $up | python -c 'import json,sys;l=sys.stdin.read().split("__TOTO__"); d=json.loads(l[0]); d.update(json.loads(l[1]));nd={"api_definition": d} ; print json.dumps(nd)')


curl  -X PUT   -H "Content-Type: application/json" -d  "${API_NEW}"  -H "authorization: $USER_AUTH" http://$DOCKER_IP:3000/api/apis/$API_DB_ID

