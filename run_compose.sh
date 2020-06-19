#! /bin/bash

# Wrapper to set up docker containers and modify the postgres container
# Run this instead of docker-compose
# OR
# Run docker-compose and then run `docker exec postgres ./tmp/postgres_setup.sh`

echo "Running Docker Compose"
docker-compose up -d

echo "Modifying Postgres Container"
docker exec postgres_kc ./tmp/postgres_setup.sh
wait

echo "Finished"