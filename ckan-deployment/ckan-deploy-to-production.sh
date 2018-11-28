# This is script is required to run in the current folder named ckan-deployment as it requires the relative paths to some files like the app.wsgi

# Install the required packages
sudo apt update
sudo apt ugprade -y
sudo apt install apache2 libapache2-mod-wsgi -y

# Copy the existing CKAN development configuration file and name it production.ini
cp /etc/ckan/default/development.ini /etc/ckan/default/production.ini

# Copy the app.wsgi to the /etc/ckan/default/ directory
cp app.wsgi /etc/ckan/default/

# Copy the Apache configuration file to its working directory
sudo cp ckan_default.conf /etc/apache2/sites-available/ckan_default.conf

# Enable the new CKAN site in Apache
sudo a2ensite ckan_default
sudo a2dissite 000-default
sudo service apache2 reload