#!/usr/bin/env bash

# This script copies the templates in the current directory to the required directories in CKAN.

printf 'Copying form-select ...'
sudo cp form-select.html /usr/lib/ckan/default/src/ckanext-scheming/ckanext/scheming/templates/scheming/form_snippets/
echo Done

printf 'Please manually copy the content in select-link.html to /usr/lib/ckan/default/src/ckan/ckan/templates/macros/'
read
