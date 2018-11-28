# This is script is required to run in the current folder named ckan-deployment as it requires the relative paths to some files like the app.wsgi

# Install the required packages
sudo apt-get install apache2 libapache2-mod-wsgi

# Copy the existing CKAN development configuration file and name it production.ini
cp /etc/ckan/default/development.ini /etc/ckan/default/production.ini

# Copy the app.wsgi to the /etc/ckan/default/ directory
cp app.wsgi /etc/ckan/default/

# Copy the Apache configuration file to its working directory
sudo cp ckan_default.conf /etc/apache2/sites-available/ckan_default.conf

sudo service apache2 reload