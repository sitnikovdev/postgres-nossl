#!/bin/bash

# exit as soon as any of these commands fail, this prevents starting a database without certificates
set -e

# Make sure there is a PGDATA variable available
if [ -z "$PGDATA" ]; then
  echo "Missing PGDATA variable"
  exit 1
fi

# Set up needed variables
POSTGRES_CONF_FILE="$PGDATA/postgresql.conf"

# unset PGHOST to force psql to use Unix socket path
# this is specific to Railway and allows
# us to use PGHOST after the init
unset PGHOST

## unset PGPORT also specific to Railway
## since postgres checks for validity of
## the value in PGPORT we unset it in case
## it ends up being empty
unset PGPORT

# Call the entrypoint script with the
# appropriate PGHOST & PGPORT and redirect
# the output to stdout if LOG_TO_STDOUT is true
if [[ "$LOG_TO_STDOUT" == "true" ]]; then
    /usr/local/bin/docker-entrypoint.sh "$@" 2>&1
else
    /usr/local/bin/docker-entrypoint.sh "$@"
fi
