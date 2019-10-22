version: '3.3'
services:
  tyk-dashboard:
    image: tykio/tyk-dashboard:v1.8.5
    ports:
    - "3000:3000"
    - "5000:5000"
    networks:
    - tyk
    depends_on:
    - tyk-redis
    - tyk-mongo
  candig:
    image: tykio/tyk-gateway:v2.8.4
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
    ports:
    - "${KC_LOCAL_PORT}:8081"
    env_file:
    - ${LOCAL_KC_CONFIG_PATH}/secrets.env
    networks:
    - tyk
  candig_server:
    image: c3genomics/candig_server
    ports:
    - "80:80"
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
