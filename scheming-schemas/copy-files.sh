#!/usr/bin/env bash

sudo printf 'Copying ckan_dataset.json ... '
sudo cp ckan_dataset.json /usr/lib/ckan/default/src/ckanext-scheming/ckanext/scheming/
echo Done

sudo printf 'Copying presets.json ... '
sudo cp presets.json /usr/lib/ckan/default/src/ckanext-scheming/ckanext/scheming/
echo Done
