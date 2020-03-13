version: '3.3'
services:
  candig:
    volumes:
    - ${LOCAL_TYK_CONFIG_PATH}/authMiddleware.js:/opt/tyk-gateway/middleware/authMiddleware.js
    - ${LOCAL_TYK_CONFIG_PATH}/oidcDistributedClaimsConduitMiddleware.js:/opt/tyk-gateway/middleware/oidcDistributedClaimsConduitMiddleware.js
    - ${LOCAL_TYK_CONFIG_PATH}/tyk.conf:/opt/tyk-gateway/tyk.conf
    - ${LOCAL_TYK_CONFIG_PATH}/virtualLogin.js:/opt/tyk-gateway/middleware/virtualLogin.js
    - ${LOCAL_TYK_CONFIG_PATH}/virtualLogout.js:/opt/tyk-gateway/middleware/virtualLogout.js
    - ${LOCAL_TYK_CONFIG_PATH}/virtualToken.js:/opt/tyk-gateway/middleware/virtualToken.js
    - ${LOCAL_TYK_CONFIG_PATH}/api_candig.json:/opt/tyk-gateway/apps/api_candig.json
    - ${LOCAL_TYK_CONFIG_PATH}/api_auth.json:/opt/tyk-gateway/apps/api_auth.json
    - ${LOCAL_TYK_CONFIG_PATH}/policies.json:/opt/tyk-gateway/policies/policies.json
  tyk-pump:
    volumes:
    - ${LOCAL_TYK_CONFIG_PATH}/pump.conf:/opt/tyk-pump/pump.conf
  candigauth:
    volumes:
    - ${LOCAL_KC_CONFIG_PATH}/standalone-ha.xml:/opt/jboss/keycloak/standalone/configuration/standalone-ha.xml
  candig_server:
    volumes:
    - ${LOCAL_CANDIG_CONFIG_PATH}/config.py:/opt/candig_server/config.py
    - ${LOCAL_CANDIG_CONFIG_PATH}/access_list.tsv:/data/access_list.tsv
