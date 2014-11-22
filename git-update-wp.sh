# Requires:

# Get the current release WP version
wget --quiet --output-document ver http://api.wordpress.org/core/version-check/1.1/ 2>&1
WP_TAG=$(sed -n '3p' ver)
rm ver

START_DIR=`pwd`;
BASE_DIR="$START_DIR";
WEB_DIR="$BASE_DIR";
UPDATE_WORDPRESS="1";


if [ ! -e .gitignore ] ; then
	echo "You must be in the site root folder to update it. Exiting.";
	exit;
fi

if [ -e webroot ] ; then
	WEB_DIR="$BASE_DIR/webroot";
fi;


if [ $UPDATE_WORDPRESS -eq "1" ] ; then
	# make sure to checkout the current versions of genesis and wordpress
	echo "Updating to Wordpress to version  $WP_TAG"
	sleep 3
	cd "$WEB_DIR/wordpress"
	#git pull
	git checkout master
	git fetch
	git fetch --tags
	git checkout $WP_TAG
	cd $START_DIR
fi