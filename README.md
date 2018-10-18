1- Spin the docker containers
```
docker-compose -f container_net.yml -f volumes.yml up -d
 docker-compose  -f volumes.yml -f container_net.yml logs -f
```
2- Config the containers
There is headers to set, but its not documented yet! But once it is documented, you can simply run:
```
./setup.sh
```
