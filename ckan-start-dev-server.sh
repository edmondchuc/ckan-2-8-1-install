#!/usr/bin/env bash

# Activate CKAN virtualenv in case it wasn't already activated
. /usr/lib/ckan/default/bin/activate

# Start the dev. server
paster serve /etc/ckan/default/development.ini
