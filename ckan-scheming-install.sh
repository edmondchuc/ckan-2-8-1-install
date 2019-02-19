#!/usr/bin/env bash

# ======================================
# CKAN Scheming Extension Install Script
# ======================================
#
# Author: Edmond Chuc
# Email: edmond.chuc@csiro.au
#
#
# Requirements
# ------------
#
# 	- Ubuntu 18.04
#	- CKAN 2.3 or later
#	- assumes the existing CKAN instance was installed in the same directories as the official CKAN documentation
#
# 
# What does this script give you?
# -------------------------------
#
# 	- a way to configure and share CKAN schemas using a JSON schema description
#
#
# ---------------------------------------------------------
# NOTE: run this script in the current directory like this: 
# . ./ckan-scheming-install.sh
# ---------------------------------------------------------




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
echo Welcome to the CKAN Scheming Extension Install Script
echo =====================================================
echo 
echo Author: Edmond Chuc
echo Email: edmond.chuc@csiro.au
echo 
printf '. ./ckan-scheming-install.sh <-- did you run this script like this? Enter [y/n] : '
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




# Install
# -------

# Activate the virtualenv for CKAN
. /usr/lib/ckan/default/bin/activate

cd /usr/lib/ckan/default/src

pip install -e "git+https://github.com/CSIRO-enviro-informatics/gsq-ckanext-scheming.git#egg=ckanext-scheming"

cd ./ckanext-scheming

pip install -r /usr/lib/ckan/default/src/ckanext-scheming/requirements.txt

cd ~

deactivate




sleep 0.5
echo .
sleep 0.5
echo .
echo Congratulations! You have finished installing CKAN Scheming extension
echo ---------------------------------------------------------------------
echo
echo To see the Scheming extension in action:
echo -e '\t'	- you will need to first edit your configuration file at /etc/ckan/default/development.ini
echo -e '\t\t'		- follow the instructions for configuring the extension at: https://github.com/ckan/ckanext-scheming#configuration
echo -e '\t'	- look into using the included example schema in the repository link above or create your own
echo
echo Note: Don\'t forget to activate your virtualenv when you start up CKAN.
