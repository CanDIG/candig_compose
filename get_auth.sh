CONFIG_PATH=/media/candig_conf/tyk/confs
# Tyk dashboard settings
source $CONFIG_PATH/tyk_secret
#set a default user
TYK_DASHBOARD_USERNAME=$CANDIG_TYK_USERNAME
TYK_DASHBOARD_PASSWORD=$CANDIG_TYK_PASSWORD
TYK_ADMIN_API_PASSWORD=$(cat $CONFIG_PATH/tyk_analytics.conf  | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["admin_secret"]')


export DOCKER_IP="127.0.0.1"

curl --silent --header "admin-auth: $TYK_ADMIN_API_PASSWORD" http://$DOCKER_IP:3000/admin/users
