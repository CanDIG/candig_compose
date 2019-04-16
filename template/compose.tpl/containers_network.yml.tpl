version: '3.3'
services:
  tyk-dashboard:
    image: tykio/tyk-dashboard:v1.7.1
    ports:
    - "3000:3000"
    - "5000:5000"
    networks:
    - tyk
    depends_on:
    - tyk-redis
    - tyk-mongo
  candig:
    image: tykio/tyk-gateway:v2.6.2
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
    image: redis:4.0.11-stretch
    ports:
    - "6379:6379"
    volumes:
    - redis-data:/data
    networks:
    - tyk
  tyk-mongo:
    image: mongo:3.2
    command: ["mongod", "--smallfiles"]
    ports:
    - "27017:27017"
    volumes:
    - mongo-data:/data/db
    networks:
    - tyk
  candigauth:
    image: jboss/keycloak:4.7.0.Final
    user: root
    env_file:
    - ${LOCAL_KC_CONFIG_PATH}/secret.env
    networks:
    - tyk
  ga4gh_server:
    image: c3genomics/ga4gh_server:0.6
    networks:
    - tyk

volumes:
  redis-data:
  mongo-data:

networks:
  tyk:
