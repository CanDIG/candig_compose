# MOVE THIS FILE OUT OF THE GIT REPO e.g. $HOME/.config/candigrc and fill the file there
# Source it form there before executing the setups


# Where you what the output to be stored
# it is where they will be looked for by the candig_setup.sh too
# need to be RW by the user who execute the setup.sh step
# This folder will need to be mounted ont the compose host
export OUPTUT_CONFIGURATION_DIR=/tmp/candig_conf


## Change the
export SECRET_KEY=a_default_to_change_jfsaljfLKdjflKSJD

export KC_ADMIN_USER=a_default_to_change_admin_per
export KC_PW=a_default_to_change_kfjaskdihfowiehsgdv

export CANDIG_TYK_USERNAME=a_default_to_change_test_bed@mail.com
export CANDIG_TYK_PASSWORD=a_default_to_change_my.only.bonne.idee.pour.un.good.pasword

export TYK_DASH_FROM_EMAIL="maybe_you@my_mail.com"
export TYK_DASH_FROM_NAME="you name"

export TYK_NODE_SECRET=a_default_to_change_0rwejfkzp09uenjkfcspcajl
export TYK_ANALYTIC_ADMIN_SECRET=a_default_to_change_oweuifhnsEWFSiwhqetutbsvbdf
# Get this lic from TYK here https://tyk.io/product/tyk-on-premises-free-edition/
export ANALYTIC_LIC_KEY=""



###############################################
# Local address is th one seen when running the setup
# Public address resolve in the public dns



# True for https False for http
export SESSION_COOKIE_SECURE=False

#The full path of the template/ dir in this repo! 
# put the full path id you intend to run the setup from somehere remote folder 
export INPUT_TEMPLATE_DIR=${PWD}/template

export CANDIG_PUBLIC_URL=http://candig.you_site.org
export CANDIG_PUBLIC_PORT=8080

export TYK_GATW_LOCAL_URL=candig.you_site.org
export TYK_GATW_LOCAL_PORT=8080

export TYK_DASHB_LOCAL_URL=candig.you_site.org
export TYK_DASHB_LOCAL_PORT=3000


export KC_PUBLIC_URL=http://candigauth.you_site.org
export KC_PUBLIC_PORT=8081

export KC_LOCAL_URL=candigauth.you_site.org
export KC_LOCAL_PORT=8081


export LOCAL_TYK_CONFIG_PATH=${OUPTUT_CONFIGURATION_DIR}/tyk/confs
export LOCAL_KC_CONFIG_PATH=${OUPTUT_CONFIGURATION_DIR}/keycloak/configuration
export LOCAL_GA4GH_CONFIG_PATH=${OUPTUT_CONFIGURATION_DIR}/ga4gh_server


# This is the adress seen by tyk (in compose its the name)
export LOCAL_CANDIG_SERVER="http://ga4gh_server:80"

############################

# listen_path is empty "", put a slash only if there is a path "/<path>"
export TYK_LISTEN_PATH=""

export TYK_POLICY_NAME="Candig policy"


# Keycloak settings with redirection through tyk
export KC_REALM='candig'
export KC_SERVER="${KC_PUBLIC_URL}:${KC_PUBLIC_PORT}"
export KC_CLIENT_ID='cq_candig'
export KC_LOGIN_REDIRECT_PATH='/login_oidc'

export API_NAME="Candig Api"



