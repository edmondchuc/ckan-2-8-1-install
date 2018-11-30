#!/usr/bin/env bash

# ========================
# CKAN Installation Script
# ========================
#
# Author: Edmond Chuc
# Email: edmond.chuc@csiro.au
#
#
# Requirements
# ------------
#
# 	- Ubuntu 18.04
#
# 
# CKAN Dependencies
# -----------------
# 
# CKAN version: 2.8.1 (Comprehensive Knowledge Archive Network)
# Python version: Python2.7 programming language
# PostgreSQL version: 9.3 or newer (database system)
# libpq: The C programmer's interface to PostgreSQL
# pip: A tool for installing and managing Python packages
# virtualenv: The virtual Python environment builder
# Git: A distributed version control system
# Apache Solr: A search platform
# Jetty: An HTTP server (used for Solr)
# OpenJDK: The Java Development Kit (used by Jetty)
# Redis: An in-memory data structure store
# 
#
# What does this script give you?
# -------------------------------
# 
#	- a bare-bones CKAN instance
#	- a set-up of a PostgreSQL datastore for the CKAN instance
# 	- a set-up of Apache Solr for searching the CKAN instance
# 	- creation of a sysadmin user account called 'admin'
# 
#
# ---------------------------------------------------------
# NOTE: run this script in the current directory like this: 
# . ./ckan-install.sh
# ---------------------------------------------------------
#
#



echo .
sleep 0.5
echo .
sleep 0.5
echo .
sleep 0.5
echo Welcome to the CKAN 2.8.1 Install Script
echo ========================================
echo 
echo Author: Edmond Chuc
echo Email: edmond.chuc@csiro.au
echo 
printf '. ./ckan-install.sh <-- did you run this script like this? Enter [y/n] : '
read -r userinput

if [ "$userinput" == "y" ]; then
	echo Starting installation...
else
	# Kill the current process:
	echo Stopping script.
	kill -INT $BASHPID
fi




# Install CKAN and the required packages into a Python virtual environment
# ------------------------------------------------------------------------
#
# Reference: https://docs.ckan.org/en/latest/maintaining/installing/install-from-source.html

# Add the univer repository to download:
sudo add-apt-repository universe

# Get updates and upgrades:
sudo apt update
sudo apt upgrade -y

# Set the machine's timezone:
sudo timedatectl set-timezone Australia/Brisbane

# Install the required packages:
sudo apt install python-dev postgresql libpq-dev python-pip virtualenv git solr-jetty openjdk-8-jdk redis-server -y

# Make some symlinks:
mkdir -p ~/ckan/lib
sudo ln -s ~/ckan/lib /usr/lib/ckan
mkdir -p ~/ckan/etc
sudo ln -s ~/ckan/etc /etc/ckan

# Create a Python virtual environment (virtualenv) to install CKAN into, and activate it:
sudo mkdir -p /usr/lib/ckan/default
sudo chown `whoami` /usr/lib/ckan/default
virtualenv --python=/usr/bin/python2.7 --no-site-packages /usr/lib/ckan/default
. /usr/lib/ckan/default/bin/activate

# Install the recommended setuptools version:
pip install setuptools==36.1

# To install the latest stable release of CKAN (CKAN 2.8.1), run:
pip install -e 'git+https://github.com/ckan/ckan.git@ckan-2.8.1#egg=ckan'

# Install the Python modules that CKAN requires into your virtualenv:
pip install -r /usr/lib/ckan/default/src/ckan/requirements.txt

# Deactivate and reactivate your virtualenv to ensure you're not using the system-wide packages:
deactivate
. /usr/lib/ckan/default/bin/activate




# Setup a PostgreSQL database
# ---------------------------

# Check that PostgreSQL was installed correctly by listing the existing databases:
sudo -u postgres psql -l

# Create a PostgreSQL user
echo 
echo Creating PostgreSQL user 'ckan_default'
echo You are now setting the password for PostgreSQL user 'ckan_default'
echo 
sudo -u postgres createuser -S -D -R -P ckan_default

# Create a new database owned by the new PostgreSQL user
sudo -u postgres createdb -O ckan_default ckan_default -E utf-8




# Create a CKAN config file
# -------------------------

# Create a directory to contain the site’s config files:
sudo mkdir -p /etc/ckan/default
sudo chown -R `whoami` /etc/ckan/
sudo chown -R `whoami` ~/ckan/etc

# Create the CKAN config file:
paster make-config ckan /etc/ckan/default/development.ini


echo 
echo ATTENTION: Manual input required!
echo ---------------------------------
sleep 0.5
echo 
echo Please edit /etc/ckan/default/development.ini
echo 
echo 1. On the line containing: sqlalchemy.url = postgresql://ckan_default:pass@localhost/ckan_default
echo -e '\t' 	- replace \'pass\' with the password that you created earlier for the PostgreSQL user ckan_default
sleep 0.5
echo 2. On the line containing: ckan.site_id = default
echo -e '\t'	- ensure the line is set as 'ckan.site_id = default'
sleep 0.5
echo 3. On the line containing: ckan.site_url = 
echo -e '\t'	- set it to the site url. While in development mode, set it to \'ckan.site_url = http://127.0.0.1:5000\'
echo -e '\t'	- NOTE: do not add a trailing slash
sleep 0.5
echo 4. On the line containing 'solr_url'
echo -e '\t'	- uncomment it by removing the \'#\'
echo WARNING: Please write down the steps above before this script continues.
sleep 0.5

prompt_user_to_write_steps_down () {
	ready="n"
	while [ "$ready" != "y" ]
	do
		printf 'Have you written down the steps? Are you ready to start editing the file? Enter [y/n] : '
		read -r ready
	done
}

prompt_user_to_write_steps_down
sudo nano /etc/ckan/default/development.ini




# Setup Solr
# ----------

# Create a symlink for Jetty9 to Solr
sudo ln -s /etc/solr/solr-jetty.xml /var/lib/jetty9/webapps/solr.xml

echo 
echo ATTENTION: Manual input required!
echo ---------------------------------
sleep 0.5
echo 
echo Please edit /etc/jetty9/start.ini
echo 
echo 1. Please edit the jetty.port value to:
echo -e "\t" 	jetty.port=8983
echo WARNING: Please write down the steps above before this script continues.
sleep 0.5

prompt_user_to_write_steps_down

# Change the port of jetty to 8983
sudo nano /etc/jetty9/start.ini

echo 
echo ATTENTION: Manual input required!
echo ---------------------------------
sleep 0.5
echo 
echo Please edit /etc/default/jetty9
echo 
echo 1. Set NO_START=0
sleep 0.5
echo 2. Set JETTY_HOST=127.0.0.1
sleep 0.5
echo 3. Set JETTY_PORT=8983
sleep 0.5

prompt_user_to_write_steps_down

sudo nano /etc/default/jetty9

# Test Solr is running by using a regex string test
restart_jetty9_and_curl_test_solr_service () {
	echo Restarting jetty9 service...
	sudo service jetty9 restart

	echo Running a curl command to see if Solr is running...
	sleep 2
	result=$(curl http://localhost:8983/solr/)

	if [[ "$result" =~ "<h1>Welcome to Solr!</h1>" ]]; then
		echo Success, Solr is running!
		sleep 0.5
		echo Continuing...
	else
		echo Stopping script.
		kill -INT $BASHID
	fi
}

restart_jetty9_and_curl_test_solr_service

# Replacing the default schema.xml file with a symlink to the CKAN schema file included in the sources
echo Creating a symlink: ln -s /usr/lib/ckan/default/src/ckan/ckan/config/solr/schema.xml /etc/solr/conf/schema.xml
sudo mv /etc/solr/conf/schema.xml /etc/solr/conf/schema.xml.bak
sudo ln -s /usr/lib/ckan/default/src/ckan/ckan/config/solr/schema.xml /etc/solr/conf/schema.xml
restart_jetty9_and_curl_test_solr_service



# Link to 'who.ini'
# -----------------

# (the Repoze.who configuration file) needs to be accessible in the same directory as your CKAN config file, so create a symlink to it:
ln -s /usr/lib/ckan/default/src/ckan/who.ini /etc/ckan/default/who.ini



# Create database tables
# ----------------------

echo Initialising database for CKAN...
cd /usr/lib/ckan/default/src/ckan
paster db init -c /etc/ckan/default/development.ini

cd ~


# Set up the DataStore
# --------------------
#
# Reference: https://docs.ckan.org/en/latest/maintaining/datastore.html

echo 
echo ATTENTION: Manual input required!
echo ---------------------------------
sleep 0.5
echo 
echo Please edit /etc/ckan/default/development.ini
echo 
echo 1. Add the \'datastore\' plugin to the ckan.plugins variable
echo -e '\t'	Example: ckan.plugins = example_plugin01 example_plugin02 datastore
sleep 0.5

prompt_user_to_write_steps_down

sudo nano /etc/ckan/default/development.ini

sudo -u postgres psql -l

# Create a database_user called datastore_default. This user will be given read-only access to your DataStore database:
echo Creating a PostgreSQL user \(role\) called datastore_default
sudo -u postgres createuser -S -D -R -P -l datastore_default

# Create the database (owned by ckan_default), which we’ll call datastore_default:
echo Creating a new database called datastore_default in PostgreSQL
sudo -u postgres createdb -O ckan_default datastore_default -E utf-8

echo 
echo ATTENTION: Manual input required!
echo ---------------------------------
sleep 0.5
echo 
echo Please edit /etc/ckan/default/development.ini
echo 
echo 1. Uncomment ckan.datastore.write_url
echo -e '\t'	Replace pass with the password you created for ckan_default database user
sleep 0.5
echo 2. Uncomment ckan.datastore.read_url
echo -e '\t' 	Replace pass with the password you created for datastore_default database user
sleep 0.5

prompt_user_to_write_steps_down
sudo nano /etc/ckan/default/development.ini

# Once the DataStore database and the users are created, the permissions on the DataStore and CKAN database have to be set. 
# CKAN provides a paster command to help you correctly set these permissions.
paster --plugin=ckan datastore set-permissions -c /etc/ckan/default/development.ini | sudo -u postgres psql --set ON_ERROR_STOP=1

echo .
sleep 0.5
echo .
sleep 0.5
echo Finished!
sleep 1

echo The DataStore is now set-up. 
sleep 0.5




# Creating a sysadmin user
# ------------------------
#
# Reference: https://docs.ckan.org/en/latest/maintaining/getting-started.html#create-admin-user

echo 
echo We will now create a sysadmin user for the CKAN instance
sleep 0.5
echo Creating new sysadmin user named:
sleep 0.5
echo -e '\t'	admin
cd /usr/lib/ckan/default/src/ckan
paster sysadmin add admin email=admin@localhost name=admin -c /etc/ckan/default/development.ini

cd ~




# Completion
# ----------

echo
echo Congratulations! You have reached the end of the core CKAN installation.
echo ------------------------------------------------------------------------
echo
sleep 0.5

echo 1. Use the Paste development server to serve CKAN from the command-line:
echo -e '\t'	paster serve /etc/ckan/default/development.ini
echo -e '\t'	Go to http://127.0.0.1:5000 to view
sleep 0.5

echo 2. To test the DataStore plugin:
echo -e '\t'	curl -X GET "http://127.0.0.1:5000/api/3/action/datastore_search?resource_id=_table_metadata"
echo -e '\t' 	You should see a JSON response if it was succcessfully installed
sleep 0.5

echo 3. You now have a sysadmin account named \'admin\'
echo -e '\t'	- this account is used to create organisations within CKAN and other administrative tasks
echo -e '\t'	- To see a list of commands for sysadmins, type:
echo -e '\t\t'		- cd /usr/lib/ckan/default/src/ckan
echo -e '\t\t'		- paster sysadmin --help
echo -e '\t'	- See https://docs.ckan.org/en/latest/sysadmin-guide.html for more information
sleep 0.5

echo 4. Edit the /etc/ckan/default/development.ini configuration file to make changes such as the site\'s title name
echo
sleep 0.5
