# MOVE THIS FILE OUT OF THE GIT REPO e.g. $HOME/.config/candigrc and fill the file there
# Source it form there before executing the setups


# Directory to store the configuration
export OUTPUT_CONFIGURATION_DIR=/tmp/candig_conf

# directory to keep permanent data
export DATA_DIR=~/home/candig_data

##  This should be a good key:
## cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1
export SECRET_KEY=GENERATE_A_NEW_KEY_jfksljrk32kwrl

# You will be able to log this user and have acces to a test dataset
export KC_TEST_USER=a_user
export KC_TEST_USER_PW=a_password

# Keycloak admin
export KC_ADMIN_USER=a_default_to_change_admin_per
export KC_PW=a_default_to_change_kfjaskdihfowiehsgdv

# Postgres admin
export POSTGRES_USER=keycloak
export POSTGRES_PASSWORD=password

#Tyk admin
export CANDIG_TYK_USERNAME=a_default_to_change_test_bed@mail.com
export CANDIG_TYK_PASSWORD=a_default_to_change_my.only.bonne.idee.pour.un.good.pasword
export TYK_DASH_FROM_EMAIL="maybe_you@my_mail.com"
export TYK_DASH_FROM_NAME="your name"


# typically the ports will be 443 and 443 for https adresses
export CANDIG_PUBLIC_URL=http://candig.you_site.org
export CANDIG_PUBLIC_PORT=8080
export KC_PUBLIC_URL=http://candigauth.you_site.org
export KC_PUBLIC_PORT=8081

# true if the keycoak is behind a TLS encrypted proxy,
# typically nginx or apache. false otherwise
export PROXY_ADDRESS_FORWARDING=false

# True for https False for http
export SESSION_COOKIE_SECURE=False

#The full path of the template/ dir in this repo!
# put the full path id you intend to run the setup from somehere remote folder
export INPUT_TEMPLATE_DIR=${PWD}/template


export TYK_GATW_LOCAL_URL=candig.you_site.org
# the local port number for tyk this cannot be change at this time
export TYK_GATW_LOCAL_PORT=8080



export KC_LOCAL_PORT=8081
export KC_LOCAL_PORT_SSL=443

export POSTGRES_PORT=5432


export LOCAL_TYK_CONFIG_PATH=${OUTPUT_CONFIGURATION_DIR}/tyk/confs
export LOCAL_KC_CONFIG_PATH=${OUTPUT_CONFIGURATION_DIR}/keycloak/configuration
export LOCAL_CANDIG_CONFIG_PATH=${OUTPUT_CONFIGURATION_DIR}/candig_server
export LOCAL_POSTGRES_CONFIG_PATH=${OUTPUT_CONFIGURATION_DIR}/postgres

# Docker-compose naming
export CONTAINER_NAME_CANDIG_GATEWAY=candig
export CONTAINER_NAME_CANDIG_AUTH=candig_auth
export CONTAINER_NAME_POSTGRES_DB=postgres_kc

# Do not touch, this is the adress seen by tyk (in compose its the name)
export LOCAL_CANDIG_SERVER="http://candig_server:80"

############################

# listen_path is empty "", put a slash only if there is a path "/<path>"
export TYK_LISTEN_PATH=""
export TYK_POLICY_NAME="Candig policy"


# Keycloak settings with redirection through tyk
export KC_REALM='candig'
export KC_SERVER="${KC_PUBLIC_URL}:${KC_PUBLIC_PORT}"
export KC_CLIENT_ID='cq_candig'
export KC_CLIENT_ID_64=$(echo -n ${KC_CLIENT_ID} | base64)
export KC_LOGIN_REDIRECT_PATH='/auth/login'

export TYK_POLICY_ID="candig_policy"

export AUTH_API_NAME="Authentication"
export AUTH_API_ID="11"
export AUTH_API_SLUG="authentication"

export CANDIG_API_NAME="Candig Api"
export CANDIG_API_ID="21"
export CANDIG_API_SLUG="candig"

# do not change
export TYK_DASHB_LOCAL_PORT=3000
