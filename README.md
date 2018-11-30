# CKAN 2.8.1 Installation
This repository contains semi-automated bash scripts to install an instance of CKAN and some optional extensions.

## Installation
The only mandatory installation will be the `ckan-install.sh` for a minimal CKAN instance to be deployed.

## Optional extensions
- `ckan-filestore-install.sh`
	- allow file uploads 
- `ckan-dcat-install.sh`
	- allow for RDF-serialised metadata of the dataset in DCAT
- `ckan-scheming-install.sh`
	- allow for custom schema for the forms describing the dataset

## CKAN deployment
See the directory for more information.

## Quirks
- An organisation must be created with the development server before the production server can create organisations. An attempt to create an organisation on the production server will result in a server error on the last step of the creation process. Not sure why.


## Extensions of interest

### ckanext-validation
- https://github.com/frictionlessdata/ckanext-validation
