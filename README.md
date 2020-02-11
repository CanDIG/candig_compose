# CanDIG Server Configuration and Deployment

## Prerequisites

### Docker

See instructions to install Docker: https://runnable.com/docker/getting-started/

### Docker Compose (docker-compose)

* You will need `docker-compose`.  If compose is not available on you machine you can download its binary
    ```
    wget -O docker-compose \
    "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)"
    ```
* Save the binary somewhere in your `$PATH`.
* Make it executable
    ```
    chmod 755 /path/to/docker-compose
    ```

### Ports

For this setup to work without a lot of changes, please make sure should be available on the machine where the CanDIG containers are deployed.

* `3000`
* `8081`
* `8080`

Any other ports as more APIs are added.

## Deploy on `localhost`

### 0. Create a working directory

E.g. `/path/to/my/candig/workdir`

Let's say that is your `$WORKDIR`.

### 1. Create your config from template: `config_resources.tpl` file

`config_resource.tpl` is a template of a config file.

WARNING: This file will contain the configuration of your CanDIG server
deployement but also password, keys and username all in clear! Be careful
of where you will copy that file and who has acess to it.

```
cp config_resource.tpl $WORKDIR/config/config
```

Make changes to `$WORKDIR/config/config` according to your needs.

### 2. Create your compose files

```
./create_compose.sh -o $WORKDIR/config/config
```

This creates two files `yml/containers_network.yml` and `yml/volumes.yml`.

One has the container definition and networking of the candig servers
while the other one controls the volumes that are mounted from the host to the
container.

Note that the files to be mounted in `yml/volumes.yml` have been created locally
in the `${OUPTUT_CONFIGURATION_DIR}` folder has defined in the `config`
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

## Adding new API behind Tyk authentication

To add new API, you will need to follow this order:

1. *Create an API file*: Look at the [tyk/confs] directory. You can use [api_candig.json]
as an example and modify from step 2.
2. Edit the newly created API JSON file with following
   * "api_id" - a unique value amongst all API JSON files.
   * "proxy.target_url" - HOST:PORT of the target API.
   * "proxy.listen_path" - note if you give the path a trailing slash.
   * "slug" - this is what tyk exposes your API for edits.
   * "name" - a unique name.
   * "config_data.SESSION_ENDPOINTS" -  note if you give it a trailing slash.
5. Add the docker mount of the file in docker-compose volumes under Tyk's settings.
6. Recreate the container by running `docker-compose` command again.
7. Edit [policies.json] to add a section of new API under "access_rights".
8. Restart Tyk container to be sure.
9. Edit [key_request.json] to add a section of new API under "access_rights".
10. Use the edited [key_request.json] with key generation Tyk-API call
```
$ curl ${TYK_HOST}:${TYK_PORT}/tyk/keys/create -H "x-tyk-authorization: ${TYK_SECRET}" -s -H "Content-Type: application/json" -X POST -d '{
   ...
    "access_rights": {
        "21": {
            "api_id": "21",
            "api_name": "CanDIG",
            "versions": ["Default"]
        },
        "31": {
            "api_id": "31",
            "api_name": "Beacon",
            "versions": ["Default"]
        }
    },
    "meta_data": {}
}
'
```
11. Reload
```
$ curl -H "x-tyk-authorization: &{TYK_SECRET}" -s ${TYK_HOST}:${TYK_PORT}/tyk/reload/group
```
You should see your API at the path you specified. Please note that this is all slash-sensitive.

[tyk/confs]: ./template/config.tpl/tyk/confs
[api_candig.json]: ./template/config.tpl/tyk/confs/api_candig.json
[policies.json]: ./template/config.tpl/tyk/confs/policies.json
[key_request.json]: ./template/config.tpl/tyk/confs/key_request.json

