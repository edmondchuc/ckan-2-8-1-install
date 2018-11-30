#!/usr/bin/env bash

# This script copies the templates in the current directory to the required directories in CKAN.

printf 'Copying form-select.html ...'
sudo cp form-select.html /usr/lib/ckan/default/src/ckan/ckan/templates/macros/
echo Done

printf 'Copying select-link.html '
sudo cp select-link.html /usr/lib/ckan/default/src/ckanext-scheming/ckanext/scheming/templates/scheming/display_snippets/
echo Done
