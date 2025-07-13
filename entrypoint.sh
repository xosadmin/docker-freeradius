#!/bin/bash

if [[ -z "$MYSQL_SERVER" ]] || [[ -z "$MYSQL_PORT" ]] || [[ -z "$MYSQL_USER" ]] || [[ -z "$MYSQL_PASSWORD" ]] || [[ -z "$MYSQL_DBNAME" ]]; then
    echo "Error: Insufficient MySQL connection information." >&2
    exit 1
fi

dialect="mysql"

echo "Start initialize Freeradius..."

if [[ ! -f "/etc/freeradius/3.0/init.lock" ]]; then
    cd /etc/freeradius/3.0 || { echo "Failed to cd /etc/freeradius/3.0"; exit 1; }

    if [[ -z "$DO_NOT_IMPORT_DB" ]]; then
        echo "Importing default DB structure..."
        if ! mysql -h"$MYSQL_SERVER" -P"$MYSQL_PORT" -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DBNAME" < mods-config/sql/main/mysql/schema.sql; then
            echo "Failed to import DB structure, perhaps database connection information issue. Exiting..." >&2
            exit 1
        fi
    fi

    echo "Updating freeradius..."

    sed -Ei 's/#[\t ]*sql$/sql/g' sites-enabled/default

sed -i '/^[[:space:]]*#\?[[:space:]]*password = "radpass"/r /dev/stdin' mods-enabled/sql <<EOF 
        server = "$MYSQL_SERVER"
        port = $MYSQL_PORT
        login = "$MYSQL_USER"
        password = "$MYSQL_PASSWORD"
EOF

    sed -Ei -e "s/dialect = \"sqlite\"/dialect = \"mysql\"/" \
        -e "s/driver = \"rlm_sql_[^\"]*\"/driver = \"rlm_sql_${dialect}\"/" \
        -e "s/radius_db = \"radius\"/radius_db = \"$MYSQL_DBNAME\"/g" \
        -e 's/^[[:space:]]*#[[:space:]]*read_clients = yes/        read_clients = yes/' \
        -e 's/^[[:space:]]*#[[:space:]]*client_table = "nas"/        client_table = "nas"/' mods-enabled/sql

cat>>clients.conf<<EOF

client defaultNAS {
    ipaddr = 0.0.0.0
    secret = $SECRET
}
EOF

    touch /etc/freeradius/3.0/init.lock
else
    echo "Already init. Skipping..."
fi

echo "Init complete. Starting freeradius..."
freeradius -f
