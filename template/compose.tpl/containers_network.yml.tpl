version: '3.3'
services:
  candig:
    image: tykio/tyk-gateway:v2.9.3
    ports:
    - "${TYK_GATW_LOCAL_PORT}:8080"
    networks:
    - tyk
    depends_on:
    - tyk-redis
  tyk-pump:
    image: tykio/tyk-pump-docker-pub:v0.5.3
    networks:
    - tyk
    depends_on:
    - tyk-redis
    - tyk-mongo
    - candig
  tyk-redis:
    image: redis:4.0.14-alpine
    volumes:
    - redis-data:/data
    networks:
    - tyk
  tyk-mongo:
    image: mongo:3.2
    command: ["mongod", "--smallfiles"]
    volumes:
    - mongo-data:/data/db
    networks:
    - tyk
  candigauth:
    image: jboss/keycloak:4.7.0.Final
    ports:
    - "${KC_LOCAL_PORT}:8081"
    env_file:
    - ${LOCAL_KC_CONFIG_PATH}/secrets.env
    networks:
    - tyk
  candig_server:
    image: c3genomics/candig_server
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
  redis-data:
  mongo-data:

networks:
  tyk:
