#!/bin/bash

KC_CLIENT_ID_64=$(echo -n ${KC_CLIENT_ID} | base64)

echo Updating Api with Policy ${POL_ID}

up='{
"openid_options": {
      "providers": [
        {
          "issuer": "'"${KC_ISSUER}"'",
          "client_ids": {
            "'"${KC_CLIENT_ID_64}"'": "'"$POL_ID"'"
          }
        }
      ],
      "segregate_by_client": false,
      "custom_middleware": {
        "pre": [
            {
              "name": "authMiddleware",
              "path": "/opt/tyk-gateway/middleware/authMiddleware.js",
              "require_session": false
            }
         ],
        "id_extractor": {
          "extract_with": "",
          "extract_from": "",
          "extractor_config": {}
        },
        "driver": "",
        "auth_check": {
          "path": "",
          "require_session": false,
          "name": ""
        },
        "post_key_auth": [],
        "post": [],
        "response": []
      }
}
}'



API_NEW=$(echo $API_DEF __TOTO__ $up \
| python3 -c \
"import json,sys;
l=sys.stdin.read().split('__TOTO__');d=json.loads(l[0]);
d.update(json.loads(l[1]));
nd={'api_definition': d} ;
print(json.dumps(nd))"
)

curl  -X PUT   -H "Content-Type: application/json" -d  "${API_NEW}"  \
-H "authorization: $USER_AUTH" http://$DOCKER_IP:$TYK_DASH_PORT/api/apis/$API_DB_ID
echo
