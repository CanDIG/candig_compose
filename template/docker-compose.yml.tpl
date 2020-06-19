version: '3.3'
services:
  ${CONTAINER_NAME_CANDIG_GATEWAY}:
    image: tykio/tyk-gateway:v2.9.3.1
    container_name: ${CONTAINER_NAME_CANDIG_GATEWAY}
    ports:
    - "${TYK_GATW_LOCAL_PORT}:8080"
    networks:
    - tyk
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
    depends_on:
    - tyk-redis
  tyk-redis:
    image: redis:4.0.14-alpine
    volumes:
    - redis-data:/data
    networks:
    - tyk
  ${CONTAINER_NAME_POSTGRES_DB}:
    image: postgres
    container_name: ${CONTAINER_NAME_POSTGRES_DB}
    ports:
    - "${POSTGRES_PORT}:5432"
    restart: always
    environment:
        POSTGRES_USER: ${POSTGRES_USER}
        POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
    volumes:
      - ${LOCAL_POSTGRES_CONFIG_PATH}/scripts/postgres_setup.sh:/tmp/postgres_setup.sh
    networks:
    - tyk
  ${CONTAINER_NAME_CANDIG_AUTH}:
    image: jboss/keycloak:9.0.2
    container_name: ${CONTAINER_NAME_CANDIG_AUTH}
    command: ["-b", "0.0.0.0", "-Dkeycloak.migration.strategy=IGNORE_EXISTING"]
    depends_on:
    - ${CONTAINER_NAME_POSTGRES_DB}
    ports:
    - "${KC_LOCAL_PORT}:8081"
    env_file:
    - ${LOCAL_KC_CONFIG_PATH}/secrets.env
    environment:
      DB_VENDOR: POSTGRES
      DB_ADDR: ${CONTAINER_NAME_POSTGRES_DB}
      DB_DATABASE: keycloak
      DB_USER: ${POSTGRES_USER}
      DB_PASSWORD: ${POSTGRES_PASSWORD}
    networks:
    - tyk
    volumes:
    - ${DATA_DIR}/keycloak-db:/opt/jboss/keycloak/standalone/data
  candig_server:
    image: c3genomics/candig_server
    container_name: candig_server
    entrypoint:
    - candig_server
    - --host
    - "0.0.0.0"
    - --port
    - "80"
    - --workers
    - "1"
    - --gunicorn
    - -f
    - /opt/candig_server/config.py
    networks:
    - tyk
    volumes:
    - ${LOCAL_CANDIG_CONFIG_PATH}/config.py:/opt/candig_server/config.py
    - ${LOCAL_CANDIG_CONFIG_PATH}/access_list.tsv:/data/access_list.tsv

volumes:
  redis-data:

networks:
  tyk:
