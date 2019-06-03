## Configure the Candig server in a couple of steps!

For it to work without too much reconfiguration port 3000, 8081 and 8080
should be available on the machine where the CanDig containers are deployed.

### Deploy on a local host
1- Fill you config_resources file

`config_resource.tpl` is a template of a config file. It will contain the
configuration of your candig deployement but also password, keys and username
all in clear! Be carefull of where you will copy that file and who hass acess
to it.  

```
cp config_resource.tpl ~/place_not_in_git_repo/config
```
and edit the file there!

2- Create your compose files.

```
create_compose.sh -o ~/place_not_in_git_repo/config
```

This creates two files `yml/containers_network.yml` and `yml/volumes.yml`

One has the container definition and networking of the candig servers
while the other one controls the volumes that are monter from the host to the
container.

Note that the files to be monted in `yml/volumes.yml` have been created localy
in the ${OUPTUT_CONFIGURATION_DIR} folder has defined in the config_resource
file.

3- spin the Docker containers


Run:

```
docker-compose -f yml/containers_network.yml -f yml/volumes.yml up -d
```

you can check to log to make sure that all is well:

```
docker-compose -f yml/containers_network.yml -f yml/volumes.yml logs -f

```

If compose is not available on you machine you can download its binary here
```
wget -O docker-compose \
 "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)")
```
and make it executable with `chmod 755 docker-compose`.


4- Configure you Candig setup

Run the following
```
./candig_setup.sh \
-o  ~/place_not_in_git_repo/config -k keycloachost:8081 -t tykhost
```
