version: '3.3'
services:
  tyk-dashboard:
    volumes:
    - ${LOCAL_TYK_CONFIG_PATH}/tyk_analytics.conf:/opt/tyk-dashboard/tyk_analytics.conf
  candig.calculquebec.ca:
    volumes:
    - ${LOCAL_TYK_CONFIG_PATH}/authMiddleware.js:/opt/tyk-gateway/middleware/authMiddleware.js
    - ${LOCAL_TYK_CONFIG_PATH}/tyk.conf:/opt/tyk-gateway/tyk.conf
  tyk-pump:
    volumes:
    - ${LOCAL_TYK_CONFIG_PATH}/pump.conf:/opt/tyk-pump/pump.conf
  candigauth.calculquebec.ca:
    volumes:
    - ${LOCAL_KC_CONFIG_PATH}/secrets:/opt/keycloak_conf/secrets
  ga4gh_server:
    volumes:
    - ${LOCAL_GA4GH_CONFIG_PATH}/config.py:/opt/ga4gh_server/config.py
    - ${LOCAL_GA4GH_CONFIG_PATH}/access_list.txt:/usr/lib/python2.7/site-packages/ga4gh/access_list.txt
