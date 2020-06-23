#!/bin/bash

# This script checks the schemas within Postgres and modifies Keycloak's user_attribute
# table to utilize a VARCHAR value of indeterminate length rather than the base 255 characters.

# The main loop will continue until the schema is found, which should occur once the Keycloak
# container is fully operational.


while true
do
    EXISTS=`psql -X -A -U keycloak -c "SELECT EXISTS (
        SELECT FROM information_schema.tables
        WHERE table_name = 'user_attribute'
        );"`

    if [ $(echo "$EXISTS" | sed '2q;d') = "t" ]; then
        echo "Schema exists, altering user_attribute table"
        psql -X -A -U keycloak -c "
        ALTER TABLE user_attribute
        ALTER COLUMN value TYPE VARCHAR;
        "
        echo "Schema Updated"
        break
    fi
done

echo "Confirming schema update"
VERIFY=`psql -X -A -U keycloak -c "\d+ user_attribute" | grep -o "value|character varying|"`

if [ "$VERIFY" = "value|character varying|" ] ; then
    echo "Verified"
else
    echo not Found
fi

