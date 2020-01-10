DATA_SOURCE='/data/candig-example-data/registry.db'
REQUEST_VALIDATION=True
SESSION_COOKIE_SECURE=${SESSION_COOKIE_SECURE}
SECRET_KEY='${SECRET_KEY}'
ACCESS_LIST='/data/access_list.tsv'

# Tyk settings 
TYK_ENABLED=True
TYK_SERVER="${CANDIG_PUBLIC_URL}${CD_PUB_PORT}"
# write path in the "/path" form. Leave empty "" for empty path 
TYK_LISTEN_PATH="${TY_LISTEN_PATH}"