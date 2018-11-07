#!/bin/bash


echo Creating policy "$TYK_POLICY_NAME" for API "$API_NAME":"$API_ID"

POL_DATA=$(curl -X POST -H "authorization: $USER_AUTH" \
  -s \
  -H "Content-Type: application/json" \
  -X POST \
-d '{
    "access_rights": {
      "'"$API_ID"'": {
        "allowed_urls": [],
        "api_id": "'"$API_ID"'",
        "api_name": "'"$API_NAME"'",
        "versions": [
          "Default"
        ]
      }
    },
    "active": true,
    "name": "'"$TYK_POLICY_NAME"'",
    "rate": 100,
    "per": 1,
    "quota_max": 10000,
    "quota_renewal_rate": 3600,
    "tags": ["Startup Users"]
}' http://$DOCKER_IP:$TYK_DASH_PORT/api/portal/policies)

export POL_ID=$(echo $POL_DATA | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["Message"]')

echo Policy ID: $POL_ID

