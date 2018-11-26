#!/usr/bin/env bash

# =======================================
# CKAN FileStore Extension Install Script
# =======================================
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
#
# 
# What does this script give you?
# -------------------------------
# 
#	- FileStore extension to a CKAN instance
#	- FileStore extension allows users to upload files in CKAN, example:
# 		- organisation logo image
#		- dataset files
#
#



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
echo Welcome to the CKAN 2.8.1 FileStore Extension Install Script
echo ============================================================
echo 
echo Author: Edmond Chuc
echo Email: edmond.chuc@csiro.au
echo 
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




# Setup file uploads
# ------------------

# Create the directory where CKAN will store uploaded files:
printf 'Creating the directory where CKAN will store uploaded files ...'
sudo mkdir -p /var/lib/ckan/default
echo Done

echo 
echo ATTENTION: Manual input required!
echo ---------------------------------
sleep 0.5
echo 
echo Please edit /etc/ckan/default/development.ini
echo 
echo 1. Add the following line to your CKAN configuration file, after the \'[app:main]\' line:
echo -e '\t'	ckan.storage_path = /var/lib/ckan/default

prompt_user_to_write_steps_down



printf 'Setting permissions for the new directory ...'
sudo chown -R $USER:$USER /var/lib/ckan/default
sudo chmod u+rwx /var/lib/ckan/default
echo Done

sudo nano /etc/ckan/default/development.ini


sleep 0.5
echo .
sleep 0.5
echo .
echo Congratulations! You have finished installing CKAN FileStore extension
echo ----------------------------------------------------------------------
echo
echo To see the FileStore extension in action:
echo -e '\t'	- start up the CKAN instance
echo -e '\t'	- creating a new organisation will now allow you to upload an image
echo -e '\t'	- adding a new dataset will now allow you to upload files as well as link URLs
echo
echo Note: Don\'t forget to activate your virtualenv when you start up CKAN.
