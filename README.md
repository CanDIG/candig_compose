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

For this setup to work without a lot of changes, please make sure should
be available on the machine where the CanDIG containers are deployed.

* `3000`
* `8081`
* `8080`

Any other ports as more APIs are added.


### Caveats

#### In case of failure

You maybe able to use the previously generated configurations. However,
if you see errors such as

```
CREATING A TYK API
Traceback (most recent call last):
    ...
API ID:
Creating policy Candig policy for API Candig Api:
Policy ID: Not authorised
Updating Api with Policy Not authorised
    ...
{"Status":"Error","Message":"Not authorised","Meta":null}
DONE
```
then, you must `docker prune` *everything* with the command

```bash
docker system prune -a -f --volumes
```

After this, you can continue recreating the docker containers via
`docker-compose` (step 3 below).

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

This creates the file `docker-compose.yml`.

This file contains the container definitions, networking of the candig servers,
and controls the volumes that are mounted from the host to the container.

Note that the files to be mounted in `docker-compose.yml` have been created locally
in the `${OUPTUT_CONFIGURATION_DIR}` folder has defined in the `config`
file.

### 3. Spin up the Docker containers

```
docker-compose up -d
```

#### To check logs of the said containers

```
docker-compose logs -f

```

### 4. Configure your CanDIG setup

#### Development

When all servers run on the localhost, true if you used the docker-compose recipe.

```
./candig_setup.sh \
-o  $WORKDIR/config -k localhost:8081 -t localhost
```

#### Production

It might happen in production that the keycloak and tyk server are not running on the local host and that they have 
not been started with compose or container. You can still configure then with the  `candig_setup.sh` script: 
```
./candig_setup.sh \
-o  $WORKDIR/config -k keycloachost:8081 -t tykhost
```

## Adding new API behind Tyk authentication

This will allow you to add your new API behind Tyk authentication so that your users
will have to log in before seeing that API endpoint. This helps with single sign-on.

**Note**: Before adding an API behind Tyk, you will have to make sure it can be launched. A good
approach to avoid a lot of headaches is to create sections within the `docker-compose`
file(s) for the new API. This way you can make sure that your other containers can access
and link to the containers for the new API. This is the most tedious part of this process
and needs to be improved, among other things.

### Steps to add new API

1. *Create an API file*: Look at the [tyk/confs] directory. You can use [api_candig.json.tpl]
as an example and modify from step 2.
2. Edit the newly created API JSON file with following
   * `api_id` - a unique value amongst all API JSON files.
   * `proxy.target_url` - HOST:PORT of the target API.
   * `proxy.listen_path` - note if you give the path a trailing slash.
   * `slug` - this is what tyk exposes your API for edits.
   * `name` - a unique name.
   * `config_data.SESSION_ENDPOINTS` -  note if you give it a trailing slash.
5. Add the docker mount of the file in docker-compose volumes under Tyk's settings.
6. Recreate the container by running `docker-compose` command again.
7. Edit [policies.json] to add a section of new API under `access_rights`.
8. Restart Tyk container to be sure.
9. Edit [key_request.json.tpl] to add a section of new API under `access_rights`.
10. Use the edited [key_request.json.tpl] with key generation Tyk-API call
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
$ curl -H "x-tyk-authorization: ${TYK_SECRET}" -s ${TYK_HOST}:${TYK_PORT}/tyk/reload/group
```
You should see your API at the path you specified. Please note that this is all slash-sensitive.

[tyk/confs]: ./template/config.tpl/tyk/confs
[api_candig.json.tpl]: ./template/config.tpl/tyk/confs/api_candig.json.tpl
[policies.json.tpl]: ./template/config.tpl/tyk/confs/policies.json.tpl
[key_request.json.tpl]: ./template/config.tpl/tyk/confs/key_request.json.tpl

## Deployment Behind an HTTPS proxy

If you have a working http deployement, you can add these modification 
to the candig and httpd configs.
  
Here, the proxy is using a encryption certificate while the candig_container
tools are all unencrypted. This mean that to use this setup, you need to 
consider the network behind the proxy to be secure.

#### The config file
Specific `$WORKDIR/config` setup:

Make sure the public address starts with `https` and that the public PORT 
are `443`, the you will be behind a proxy, so `PROXY_ADDRESS_FORWARDING=true`
```
export CANDIG_PUBLIC_URL=https://<public  TYK address>
export CANDIG_PUBLIC_PORT=443
export KC_PUBLIC_URL=https://<public KC address>
export KC_PUBLIC_PORT=443
export PROXY_ADDRESS_FORWARDING=true
```

#### The Apache httpd config

```
<VirtualHost <public KC ip>:443>
   ServerName <public KC address>
   RemoteIPHeader X-Forwarded-For 
   RequestHeader set X-Forwarded-Proto "https"
   SSLProxyEngine On
   SSLProxyVerify none
   SSLProxyCheckPeerCN Off
   SSLProxyCheckPeerExpire Off
   ProxyPreserveHost On
   ProxyPass /auth http://<local KC ip>:<local KC port>/auth
   ProxyPassReverse /auth http://<local KC ip>:<local KC port>/auth

   SSLEngine on
   SSLProtocol all -SSLv2 -SSLv3 +TLSv1.2
   SSLCertificateFile       /<path_to>/cert.pem
   SSLCertificateKeyFile    /<path_to>/privkey.pem
   SSLCertificateChainFile  /<path_to>/fullchain.pem
</VirtualHost>


<VirtualHost <public  TYK ip>:443>
   ServerName <public  TYK address>
   RemoteIPHeader X-Forwarded-For
   RequestHeader set X-Forwarded-Proto "https"
   SSLProxyEngine On
   SSLProxyVerify none
   SSLProxyCheckPeerCN Off
   SSLProxyCheckPeerExpire Off
   ProxyPreserveHost On
   ProxyPass / http://<local  TYK ip>:<local  TYK port>/
   ProxyPassReverse / http://<local  TYK ip>:<local  TYK port>/

   SSLEngine on
   SSLProtocol all -SSLv2 -SSLv3  +TLSv1.2
   SSLCertificateFile       /<path_to>/cert.pem
   SSLCertificateKeyFile    /<path_to>/privkey.pem
   SSLCertificateChainFile  /<path_to>/fullchain.pem
</VirtualHost>


# If you want to redirect http to https use the folowing virtual host
<VirtualHost *:80> 
   ServerName  candig.calculquebec.ca
   #RemoteIPHeader X-Forwarded-For
   #ProxyPreserveHost On
   Redirect permanent / https://candig.calculquebec.ca/
</VirtualHost>

<VirtualHost *:80> 
   ServerName  candigauth.calculquebec.ca
   #RemoteIPHeader X-Forwarded-For
   #ProxyPreserveHost On
   Redirect permanent / https://candigauth.calculquebec.ca/
</VirtualHost>


```


#### Get a letsencrypt certificate

Get the certificate bot from (https://certbot.eff.org)
```
wget https://dl.eff.org/certbot-auto
sudo mv certbot-auto /usr/local/bin/certbot-auto
sudo chown root /usr/local/bin/certbot-auto
sudo chmod 0755 /usr/local/bin/certbot-auto
```

Get your certificate:

```
certbot-auto certonly   --apache -d <public TYK address>   -d <public KC address>
```
The certificate will be good for both address but will be saved in `/etc/letsencrypt/live/<public TYK address>` since
 it uses the first `-d` input has the reference. 

Note that you might need to use:
```
certbot-auto certonly   --standalone -d <public TYK address>   -d <public KC address>
```

if you have no VirtualHost, redirection or other, running on port 80.



Add the following to a cron tab ran by root (eg `sudo crontab -e`)

```
34 0 * * * /root/certbot-auto -q renew --post-hook "systemctl reload httpd"
```

and you are good to go.
