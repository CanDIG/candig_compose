#! /bin/bash
# This script will set up a full tyk environment on your cluster
# you need to provide the host adress (and port) of the tyk gateway server


# USAGE
# -----
#
# $> ./tyk_setup.sh {IP ADDRESS:PORT of the tyk gateway}


TYK_ORGANOSATION="Secure Cloud CQ"
TYK_ORG_SHORT_NAME="SCCQ"
TYK_DASH_PORT="3000"

# the path where config and secrets are stored
CONFIG_PATH=/media/candig_conf/tyk/confs
# Tyk dashboard settings
source $CONFIG_PATH/tyk_secret
#set a default user
TYK_DASHBOARD_USERNAME=$CANDIG_TYK_USERNAME
TYK_DASHBOARD_PASSWORD=$CANDIG_TYK_PASSWORD
TYK_ADMIN_API_PASSWORD=$(cat $CONFIG_PATH/tyk_analytics.conf  | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["admin_secret"]')
TYK_ORG_FN="Omni"
TYK_ORG_LN="Potent"


#API CONFIG
export API_NAME="Candig Api"
export TYK_SERVER="http://tyk-gateway:8080"
export KC_REALM='CanDIG'
export KC_CLIENT_ID='ga4gh'
export KC_SECRET=
export KC_SERVER='http://keycloak:8080'
export KC_LOGIN_REDIRECT_PATH="login_iocd"
export TYK_LISTEN=
export CANDIG_SERVER="http://server"
export KC_ISSUER=${KC_SERVER}/auth/realms/${KC_REALM}


# POLICY CONFIGs
export POLICY_NAME="Candig policy"



# Tyk portal settings
TYK_PORTAL_DOMAIN="www.tyk-portal-local.com"
TYK_DASH_DOMAIN="www.tyk-local.com"
source ${CONFIG_PATH}/hosts
TYK_PORTAL_PATH="/portal/"

DOCKER_IP="127.0.0.1"

if [ -n "$DOCKER_HOST" ]
then
		echo "Detected a Docker VM..."
		REMTCP=${DOCKER_HOST#tcp://}
		DOCKER_IP=${REMTCP%:*}
fi

if [ -n "$1" ]
then
		DOCKER_IP=$1
		echo "Docker host address explicitly set."
		echo "Using $DOCKER_IP as Tyk host address."
fi

if [ -n "$2" ]
then
		TYK_PORTAL_DOMAIN=$2
		echo "Docker portal domain address explicitly set."
		echo "Using $TYK_PORTAL_DOMAIN as Tyk host address."
fi

if [ -z "$1" ]
then
        echo "Using $DOCKER_IP as Tyk host address."
        echo "If this is wrong, please specify the instance IP address (e.g. ./setup.sh 192.168.1.1)"
fi

echo "Creating Organisation"
ORG_DATA=$(curl --silent --header "admin-auth: $TYK_ADMIN_API_PASSWORD" --header "Content-Type:application/json" --data '{"owner_name": "'"$TYK_ORGANOSATION"'","owner_slug": "'"$TYK_ORG_SHORT_NAME"'", "cname_enabled":true, "cname": "'"$TYK_PORTAL_DOMAIN"'"}' http://$DOCKER_IP:$TYK_DASH_PORT/admin/organisations 2>&1)
ORG_ID=$(echo $ORG_DATA | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["Meta"]')

echo "ORG ID: $ORG_ID"

echo "Adding new user"
USER_DATA=$(curl --silent --header "admin-auth: $TYK_ADMIN_API_PASSWORD" --header "Content-Type:application/json" --data '{"first_name": "'$TYK_ORG_FN'","last_name": "'$TYK_ORG_LN'","email_address": "'$TYK_DASHBOARD_USERNAME'","active": true,"org_id": "'$ORG_ID'"}' http://$DOCKER_IP:$TYK_DASH_PORT/admin/users 2>&1)
USER_AUTH=$(echo $USER_DATA | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["Message"]')
USER_LIST=$(curl --silent --header "authorization: $USER_AUTH" http://$DOCKER_IP:$TYK_DASH_PORT/api/users 2>&1)
USER_ID=$(echo $USER_LIST | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["users"][0]["id"]')
echo "USER AUTH: $USER_AUTH"
echo "USER ID: $USER_ID"

echo "Setting password"
OK=$(curl --silent --header "authorization: $USER_AUTH" --header "Content-Type:application/json" http://$DOCKER_IP:$TYK_DASH_PORT/api/users/$USER_ID/actions/reset --data '{"new_password":"'$TYK_DASHBOARD_PASSWORD'"}')

echo "Setting up the Portal catalogue"
CATALOGUE_DATA=$(curl --silent --header "Authorization: $USER_AUTH" --header "Content-Type:application/json" --data '{"org_id": "'$ORG_ID'"}' http://$DOCKER_IP:$TYK_DASH_PORT/api/portal/catalogue 2>&1)
CATALOGUE_ID=$(echo $CATALOGUE_DATA | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["Message"]')
OK=$(curl --silent --header "Authorization: $USER_AUTH" http://$DOCKER_IP:$TYK_DASH_PORT/api/portal/catalogue 2>&1)

echo "Creating the Portal Home page"
OK=$(curl --silent --header "Authorization: $USER_AUTH" --header "Content-Type:application/json" --data '{"is_homepage": true, "template_name":"", "title":"Tyk Developer Portal", "slug":"home", "fields": {"JumboCTATitle": "Tyk Developer Portal", "SubHeading": "Sub Header", "JumboCTALink": "#cta", "JumboCTALinkTitle": "Your awesome APIs, hosted with Tyk!", "PanelOneContent": "Panel 1 content.", "PanelOneLink": "#panel1", "PanelOneLinkTitle": "Panel 1 Button", "PanelOneTitle": "Panel 1 Title", "PanelThereeContent": "", "PanelThreeContent": "Panel 3 content.", "PanelThreeLink": "#panel3", "PanelThreeLinkTitle": "Panel 3 Button", "PanelThreeTitle": "Panel 3 Title", "PanelTwoContent": "Panel 2 content.", "PanelTwoLink": "#panel2", "PanelTwoLinkTitle": "Panel 2 Button", "PanelTwoTitle": "Panel 2 Title"}}' http://$DOCKER_IP:$TYK_DASH_PORT/api/portal/pages 2>&1)

echo "Fixing Portal URL"
URL_DATA=$(curl --silent --header "admin-auth: $TYK_ADMIN_API_PASSWORD" --header "Content-Type:application/json" http://$DOCKER_IP:$TYK_DASH_PORT/admin/system/reload 2>&1)
CAT_DATA=$(curl -X POST --silent --header "Authorization: $USER_AUTH" --header "Content-Type:application/json" --data "{}" http://$DOCKER_IP:$TYK_DASH_PORT/api/portal/configuration 2>&1)

echo ""

echo "===="
echo "Login at http://$TYK_DASH_DOMAIN:$TYK_DASH_PORT/"
echo "Username: $TYK_DASHBOARD_USERNAME"
echo "Password: $TYK_DASHBOARD_PASSWORD"
echo "Portal: http://$TYK_PORTAL_DOMAIN:$TYK_DASH_PORT$TYK_PORTAL_PATH"
echo ""


source api.sh
source policies.sh
source update_api.sh

echo "DONE"
