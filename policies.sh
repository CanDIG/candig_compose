#!/bin/bash
POLICY_NAME="Candig policy"

curl -X POST -H "authorization: $USER_AUTH" \
  -s \
  -H "Content-Type: application/json" \
  -X POST \
-d '{
    "access_rights": {
      "$API_ID": {
        "allowed_urls": [],
        "api_id": "$API_ID",
        "api_name": "$API_NAME",
        "versions": [
          "Default"
        ]
      }
    },
    "active": true,
    "name": "$POLICY_NAME",
    "rate": 100,
    "per": 1,
    "quota_max": 10000,
    "quota_renewal_rate": 3600,
    "tags": ["Startup Users"]
}' http://$DOCKER_IP:3000/api/portal/policies | python -mjson.tool

