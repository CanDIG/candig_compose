# CanDIG Server Configuration and Deployment


## Prerequisites

### Docker

See instructions to install Docker: https://runnable.com/docker/getting-started/

### Docker Compose (docker-compose)

* You will need `docker-compse`.  If compose is not available on you machine you can download its binary
    ```
    wget -O docker-compose \
    "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)")
    ```
* Save the binary somewhere in your `$PATH`.
* Make it executable
    ```
    chmod 755 /path/to/docker-compose
    ```

### Ports

For this setup to work without a lot of changes, please make sure should be available on the machine where the CanDig containers are deployed.

* `3000`
* `8081`
* `8080`


## Deploy on `localhost`

### 0. Create a working directory

E.g. `/path/to/my/candig/workdir`

Let's say that is your `$WORKDIR`.

### 1. Create your config from template: `config_resources` file

`config_resource.tpl` is a template of a config file.

WARNING: This file will contain the configuration of your CanDIG server
deployement but also password, keys and username all in clear! Be careful
of where you will copy that file and who has acess to it.

```
cp config_resource.tpl $WORKDIR/config/config_resources
```

Make changes to `$WORKDIR/config/config_resources` according to your needs.

### 2. Create your compose files

```
./create_compose.sh -o $WORKDIR/config
```

This creates two files `yml/containers_network.yml` and `yml/volumes.yml`.

One has the container definition and networking of the candig servers
while the other one controls the volumes that are mounted from the host to the
container.

Note that the files to be mounted in `yml/volumes.yml` have been created locally
in the `${OUPTUT_CONFIGURATION_DIR}` folder has defined in the `config_resource`
file.

### 3. Spin up the Docker containers

```
docker-compose -f yml/containers_network.yml -f yml/volumes.yml up -d
```

#### To check logs of the said containers

```
docker-compose -f yml/containers_network.yml -f yml/volumes.yml logs -f

```

### 4. Configure your CanDIG setup

#### Development

```
./candig_setup.sh \
-o  $WORKDIR/config -k localhost:8081 -t localhost
```

#### Production

```
./candig_setup.sh \
-o  $WORKDIR/config -k keycloachost:8081 -t tykhost
```