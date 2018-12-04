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
# 	- a custom Qld Gov theme for CKAN
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
echo Welcome to the CKAN Qld Gov Theme Extension Install Script
echo ==========================================================
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




# Install
# -------

# Activate the virtualenv for CKAN
. /usr/lib/ckan/default/bin/activate

pip install -e "git+https://github.com/edmondchuc/ckanext-qld_gov_theme.git#egg=ckanext-qld_gov_theme"

pip install -r /usr/lib/ckan/default/src/ckanext-qld-gov-theme/requirements.txt




sleep 0.5
echo .
sleep 0.5
echo .
echo Congratulations! You have finished installing CKAN Qld Gov Theme Extension
echo --------------------------------------------------------------------------
echo
echo Done
