#!/usr/bin/env bash

# ==================================
# CKAN DCAT Extension Install Script
# ==================================
#
# Author: Edmond Chuc
# Email: edmond.chuc@csiro.au
#
#
# Requirements
# ------------
#
# 	- Ubuntu 18.04
#	- CKAN 2.8.1
#	- assumes the existing CKAN instance was installed in the same directories as the official CKAN documentation
#
# 
# What does this script give you?
# -------------------------------
#
#	- expose the catalogue's datasets in different RDF serialisations of the DCAT vocabulary
# 	- https://github.com/ckan/ckanext-dcat
#
#
#
# ---------------------------------------------------------
# NOTE: run this script in the current directory like this: 
# . ./ckan-dcat-install.sh
# ---------------------------------------------------------
# --------------------------------------------------------------------------------------
# NOTE: this installation does not install the ckanext-harvest extension (RDF harvester)
#		- See ckanext-harvest at https://github.com/ckan/ckanext-harvest#installation
# --------------------------------------------------------------------------------------




prompt_user_to_write_steps_down () {
	ready="n"
	while [ "$ready" != "y" ]
	do
		printf 'Have you written down the steps? Are you ready to start editing the file? Enter [y/n] : '
		read -r ready
	done
}




echo .
sleep 0.5
echo .
sleep 0.5
echo .
sleep 0.5
echo Welcome to the CKAN DCAT Install Script
echo =======================================
echo 
echo Author: Edmond Chuc
echo Email: edmond.chuc@csiro.au
echo 
printf '. ./ckan-dcat-install.sh <-- did you run this script like this? Enter [y/n] : '
read -r userinput

if [ "$userinput" == "y" ]; then
	echo 
else
	# Kill the current process:
	echo Stopping script.
	kill -INT $BASHPID
fi

sleep 0.5
printf 'Did you stop the CKAN instance? Enter [y/n] : '
read -r userinput

if [ "$userinput" == "y" ]; then
	echo Starting installation ...
	sleep 0.5
else
	# Kill the current process:
	echo Please stop the CKAN instance and then run this script again
	kill -INT $BASHPID
fi




# Installation
# ------------

# Activate the virtualenv for CKAN
. /usr/lib/ckan/default/bin/activate

# Get the extension source files
pip install -e git+https://github.com/CSIRO-enviro-informatics/ckanext-dcat-rev.git#egg=ckanext-dcat

# Install the requirements
pip install -r /usr/lib/ckan/default/src/ckanext-dcat/requirements.txt

# Enable the required plugins in the CKAN configuration file
echo 
echo ATTENTION: Manual input required!
echo ---------------------------------
sleep 0.5
echo 
echo Please edit /etc/ckan/default/development.ini
echo 
echo 1. Append the required plugins to the ckan.plugins variable:
echo -e '\t' dcat dcat_json_interface structured_data

prompt_user_to_write_steps_down

sudo nano /etc/ckan/default/development.ini

deactivate

sleep 0.5
echo .
sleep 0.5
echo .
echo Congratulations! You have finished installing CKAN DCAT extension
echo -----------------------------------------------------------------
echo
echo To see the DCAT extension in action:
echo -e '\t'	- start up the CKAN instance
echo -e '\t'	- open an existing dataset, or create one if none exist
echo -e '\t'	- append a valid RDF extension \(like .ttl or .rdf\) to view the dataset metadata in DCAT
echo -e '\t'	- See https://github.com/ckan/ckanext-dcat for more information
echo
echo Note: Don\'t forget to activate your virtualenv when you start up CKAN.
