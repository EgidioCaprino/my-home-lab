#!/usr/bin/env bash

set -e

# psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
# 	CREATE USER nextcloud PASSWORD '$(cat /run/secrets/postgres_nextcloud_password)';
# 	CREATE DATABASE nextcloud;
# 	GRANT ALL PRIVILEGES ON DATABASE nextcloud TO nextcloud;
# EOSQL
