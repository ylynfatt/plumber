#!/bin/bash

# Plumber
# =======
#
# A collection of bash scripts using [Drush](http://drupal.org/project/drush) to help manage a Drupal Multi-Site setup.
#

function get_sites() {
  find . -maxdepth 1 -type d -print | grep -v '/all$' | grep -v '/default$' | grep -v '\.$'
}

# Turn caching on or off for all sites and set the cache lifetime
function caching() {
	sites=get_sites

 	for site in $sites
 	do
		echo ----------
		echo $site
		cd $site
		drush variable-set --always-set cache $1
		drush variable-set --always-set cache_lifetime $2
		drush variable-set --always-set preprocess_css $1
		drush variable-set --always-set preprocess_js $1
		cd ../
	done
}

# Put all sites in maintenance mode
function maintenance() {
	sites=get_sites

	for site in $sites
	do
		echo ----------
		echo $site
		cd $site
		drush variable-set --always-set site_offline $1
		cd ../
	done
}

# For each site update Drupal core and any modules that need updating
function updatedb() {
	sites=get_sites

	for site in $sites
	do
		echo ---------
		echo $site
		cd $site
		drush -y updatedb

		echo Site: $site has been udpated, look above for any errors that may have occurred
		cd ../
	done
}

# Set the default theme for all Drupal sites
function default_theme() {
	sites=get_sites

	for site in $sites
	do
  	echo $site
  	cd $site
  	drush vset --always-set theme_default $1
  	cd ../
	done
}

$1 $2 $3
