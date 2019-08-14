version: '3.3'
services:
  tyk-dashboard:
    volumes:
    - ${LOCAL_TYK_CONFIG_PATH}/tyk_analytics.conf:/opt/tyk-dashboard/tyk_analytics.conf
  candig:
    volumes:
    - ${LOCAL_TYK_CONFIG_PATH}/authMiddleware.js:/opt/tyk-gateway/middleware/authMiddleware.js
    - ${LOCAL_TYK_CONFIG_PATH}/tyk.conf:/opt/tyk-gateway/tyk.conf
  candigauth:
    volumes:
    - ${LOCAL_KC_CONFIG_PATH}/standalone-ha.xml:/opt/jboss/keycloak/standalone/configuration/standalone-ha.xml
  tyk-pump:
    volumes:
    - ${LOCAL_TYK_CONFIG_PATH}/pump.conf:/opt/tyk-pump/pump.conf
  candig_server:
    volumes:
    - ${LOCAL_CANDIG_CONFIG_PATH}/config.py:/opt/candig_server/config.py
    - ${LOCAL_CANDIG_CONFIG_PATH}/access_list.tsv:/data/access_list.tsv
