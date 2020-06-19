#!/bin/bash

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

