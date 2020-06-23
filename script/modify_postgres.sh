#! /bin/bash

# Only need to run this script for a fresh Postgres deployment


echo "Modifying Postgres Container"
docker exec postgres_kc ./tmp/postgres_setup.sh
wait

echo "Confirming schema alterations"
VERIFY=`docker exec postgres_kc psql -X -A -U keycloak -c "\d+ user_attribute" | grep -o "value|character varying|"`

if [ "$VERIFY" = "value|character varying|" ] ; then
    echo "Verified"
    echo "Removing container side script"
    docker exec postgres_kc rm ./tmp/postgres_setup.sh
else
    echo "Error. Schema not changed. Rerun this script."
fi
