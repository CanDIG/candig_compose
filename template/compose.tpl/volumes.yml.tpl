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
    - -  ${LOCAL_KC_CONFIG_PATH}/keycloak-add-user.json:/opt/jboss/keycloak/standalone/configuration/keycloak-add-user.json
  tyk-pump:
    volumes:
    - ${LOCAL_TYK_CONFIG_PATH}/pump.conf:/opt/tyk-pump/pump.conf
  ga4gh_server:
    volumes:
    - ${LOCAL_GA4GH_CONFIG_PATH}/config.py:/opt/ga4gh_server/config.py
    - ${LOCAL_GA4GH_CONFIG_PATH}/access_list.txt:/usr/lib/python2.7/site-packages/ga4gh/access_list.txt
