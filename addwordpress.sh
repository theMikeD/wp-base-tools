#!/usr/local/bin/bash
# Requires v4 of bash
# Creates a new git-ified WordPress install

# This script will install WordPress into a new folder called SITE, optionally installing:
# - the baseline plugins
# - genesis
# - my debugging plugin
# - my core plugin
# - my starter theme
# - some special stuff to help development

# Requires
# 	git
# 	wget
# 	dos2unix
#   wp-cli

# Helper vars
# http://stackoverflow.com/questions/2924697/how-does-one-output-bold-text-in-bash
BOLDON=`tput bold`;  #'\033[1m';
BOLDOFF=`tput sgr0`; #'\033[0m';
ECHO="echo -e"

# If you want to install genesis, you'll need to specify the location of the zip file
#  as downloaded from StudioPress. 
ADD_GENESIS=0;
GENESIS_TAG='v2.1.2';
GENESIS_LOCATION='/Volumes/Misc/Business Related Files/Web Development/Themes/Genesis 2.0/genesis.current.zip'
ACF5_LOCATION='/Volumes/Misc/Business Related Files/Web Development/Plugins/Advanced Custom Fields/v5/advanced-custom-fields-pro.zip'
GRAVITYFORMS_LOCATION='/Volumes/Misc/Business Related Files/Web Development/Plugins/Gravity Forms/gravityforms.current.zip'

ADD_CORE_THEME=0;
ADD_PLUGINS=0;
ADD_CORE_PLUGIN=0;
ADD_DEV_PLUGINS=0;
ADD_DB=0;
DB_NAME=0;
START_DIR=`pwd`;
BASE_DIR="$START_DIR/SITE";

# The location of the base tools, such as the wp-config and gitignore files.
# Pulls from the WPTOOLS env variable with a sane (for me) default
: ${WPTOOLS:=/Users/mike/git/Wordpress.tools/wp-base-tools}

# Get the version number for the current WordPress release
wget --quiet --output-document ver http://api.wordpress.org/core/version-check/1.1/
WP_TAG=$(sed -n '3p' ver)
rm ver

# This is the list of plugins to install when the -p option is used
plugins=( 
	"quick-featured-images" 
	"anything-order" 
	"bwp-minify" 
	"wp-security-audit-log" 
	"genesis-taxonomy-images" 
	"term-management-tools" 
	"admin-post-navigation" 
	"akismet" 
	"backwpup" 
	"kia-subtitle" 
	"simple-tags" 
	"wordpress-seo" 
	"wpmandrill" 
	"contact-form-7" 
	"genesis-simple-breadcrumbs" 
	"wp-optimize" 
	"remove-xmlrpc-pingback-ping" 
	"sucuri-scanner"
	"advanced-custom-field-repeater-collapser"
);

# This is the list of public plugins to install when the -d option is used
dev_plugins=( "wp-media-cleaner" "theme-check" "query-monitor" "underconstruction" "wordpress-importer" );

# This is the list of github items and plugins to be installed when the -d option is used
typeset -A github_plugins
github_plugins=( 
	[wp-find-shared-terms]="https://github.com/jjeaton/wp-find-shared-terms.git"
	[wp-sync-db]="https://github.com/wp-sync-db/wp-sync-db.git"
	[github-updater]="https://github.com/afragen/github-updater.git"
);

# for github_plugin_name in "${!github_plugins[@]}"; do
# 	$ECHO "$github_plugin_name --> ${github_plugins[$github_plugin_name]}";
# done


while getopts "acdtpgw:x:" opt; do
	case $opt in
		a)	# Shortcut for -g -t -c -d -p
			ADD_GENESIS=1; # Flag to add genesis. Location must be set in $GENESIS_LOCATION
			ADD_CORE_THEME=1; # Flag to add genesis starter theme. This is specific to me
			ADD_CORE_PLUGIN=1; # Flag to install my core plugin
			ADD_DEV_PLUGINS=1; # Flag to install the dev plugins
			ADD_PLUGINS=1; # Flag to install the list of plugins from $plugins
			;;
		g)
			ADD_GENESIS=1; # Flag to add genesis. Location must be set in $GENESIS_LOCATION
			;;
		t)
			ADD_CORE_THEME=1; # Flag to add genesis starter theme. This is specific to me
			;;
		w)
			WP_TAG=$OPTARG; # To check out a different WP version, specificy the git tage here
			;;
		c)
			ADD_CORE_PLUGIN=1; # Flag to install my core plugin
			;;
		d)
			ADD_DEV_PLUGINS=1; # Flag to install the dev plugins
			;;
		p)
			ADD_PLUGINS=1; # Flag to install the list of plugins from $plugins
			;;
		x)
			ADD_DB=1;
			DB_NAME=$OPTARG; # To check out a different WP version, specificy the git tage here
			;;
		\?)
			$ECHO "Invalid option: $OPTARG" >&2
			exit 1;
			;;
		:)
			$ECHO "Option -$OPTARG requires an arguement" >&2
			exit 1;
			;;
	esac
done


$ECHO "\n\n${BOLDON}Creating new site with the following options${BOLDOFF}"
$ECHO "    Installing into $BASE_DIR";
$ECHO "    Wordpress v ${WP_TAG}";
if [ $ADD_DB -eq 1 ]; then
	$ECHO "    Creating a database named ${DB_NAME}"
fi
if [ $ADD_GENESIS -eq '1' ]; then
	$ECHO "    Genesis will be installed into themes/";
fi
if [ $ADD_CORE_PLUGIN -eq '1' ]; then
	$ECHO "    MikeD's core plugin (site-core-functionality) installed into mu-plugins/";
fi
if [ $ADD_DEV_PLUGINS -eq '1' ]; then
	$ECHO "    The following dev plugins installed into plugins/";
	for plugin in "${dev_plugins[@]}" ; do
		$ECHO "      $plugin";
	done
fi
if [ $ADD_PLUGINS -eq 1 ]; then
	$ECHO "    The following plugins installed into plugins/";
	for plugin in "${plugins[@]}" ; do
		$ECHO "      $plugin";
	done
fi
$ECHO "\n\n"
#sleep 3;

# src http://jetpackweb.com/blog/2009/07/20/bash-script-to-create-mysql-database-and-user/
if [ $ADD_DB -eq 1 ]; then
	$ECHO "\n\n${BOLDON}Make the DB ${BOLDOFF}";
	MYSQL=`which mysql`
	Q1="CREATE DATABASE IF NOT EXISTS ${DB_NAME};"
	Q2="USE ${DB_NAME}; GRANT ALL ON ${DB_NAME} TO 'bloguser'@'localhost' IDENTIFIED BY 'mdixie';"
	Q3="FLUSH PRIVILEGES;"
	SQL="${Q1}${Q2}${Q3}"
	$ECHO "\n\n${BOLDON}${SQL}"
	$MYSQL -uroot -pmdixie -e "$SQL"
	$ECHO "done.";
fi


$ECHO "\n\n${BOLDON}Make the install folder [$BASE_DIR] ${BOLDOFF}";
mkdir -p "$BASE_DIR"
cd "$BASE_DIR"
$ECHO "done.";


# Now in SITE/
$ECHO "\n\n${BOLDON}Initialize Git${BOLDOFF}";
git init > /dev/null
$ECHO "done.";


# Still in SITE/
$ECHO "\n\n${BOLDON}Copy and add the custom gitignore file${BOLDOFF}";
cp $WPTOOLS/gitignore .gitignore
git add .gitignore
git commit -m "Added the custom .gitignore" > /dev/null
$ECHO "done.";


# Still in SITE/
$ECHO "\n\n${BOLDON}Copy and add the readme file${BOLDOFF}";
cp $WPTOOLS/site_readme.md README.md
git add README.md
git commit -m "Added Readme.md" > /dev/null
$ECHO "done.";


# Still in SITE/
$ECHO "\n\n${BOLDON}Copy and add the WP update script${BOLDOFF}";
cp "$WPTOOLS/git-update-wp.sh" . || exit 1
git add git-update-wp.sh
git commit -m "Added WP update script" > /dev/null
$ECHO "done.";


# Still in SITE/
cd "$BASE_DIR";
$ECHO "\n\n${BOLDON}Copy but don't add wp-config-local.php file${BOLDOFF}";
cp "$WPTOOLS/wp-config-local.php" . || exit 1
$ECHO "done.";


# Still in SITE/
if [ $ADD_DB -eq 1 ]; then
	$ECHO "\n\n${BOLDON}Adding credentials to wp-config-local.php${BOLDOFF}";
	mv "wp-config-local.php" "wp-config-local.1.php"
 	sed "/dummy.blog/{
 		s/dummy.blog/$DB_NAME/
 		}" "wp-config-local.1.php" > "wp-config-local.2.php"
 	sed "/blogpassword/{
 		s/blogpassword/mdixie/
 		}" "wp-config-local.2.php" > "wp-config-local.php"
	rm "wp-config-local.1.php" "wp-config-local.2.php"
fi;


# Still in SITE
$ECHO "\n\n${BOLDON}Copy and add wp-config.php file and update the security salts${BOLDOFF}";
wget --quiet https://api.wordpress.org/secret-key/1.1/salt
dos2unix -q salt || exit 1
sed '/\/\/__SALTS__/{
	s/\/\/__SALTS__//
	r salt
	}' "$WPTOOLS/wp-config.php" > wp-config.php
rm salt
git add wp-config.php
git commit -m "Added core wp-config.php file (without credentials) with new security salts" > /dev/null
$ECHO "done.";


# Still in SITE
$ECHO "\n\n${BOLDON}Copy but don't add .htaccess file${BOLDOFF}";
cp "$WPTOOLS/htaccess" .htaccess
$ECHO "done.";


# Still in SITE
$ECHO "\n\n${BOLDON}Add WordPress $WP_TAG as a submodule of this install${BOLDOFF}";
git submodule add https://github.com/WordPress/WordPress.git wordpress > /dev/null
cd wordpress
git checkout $WP_TAG
cd ..
git commit -am "Added WordPress $WP_TAG as a submodule" > /dev/null
$ECHO "done.";


# Still in SITE
$ECHO "\n\n${BOLDON}WP is in its own folder, so copy modified index.php to SITE/${BOLDOFF}";
cp "$WPTOOLS/index.php" . || exit 1
git add . --all
git commit -m "Added updated index file" > /dev/null
$ECHO "done.";


# Still in SITE
$ECHO "\n\n${BOLDON}Copy wp-content out of the WordPress submodule and clean out stuff not needed${BOLDOFF}";
cp -R wordpress/wp-content . || exit 1
git add . --all
git commit -m "Added stock wp-content/ outside of the WP submodule" > /dev/null

rm wp-content/plugins/hello.php || exit 1
rm -rf wp-content/themes/twentyten || exit 1
rm -rf wp-content/themes/twentyeleven || exit 1
rm -rf wp-content/themes/twentytwelve || exit 1
rm -rf wp-content/themes/twentythirteen || exit 1
rm -rf wp-content/themes/twentyfourteen || exit 1
git add . --all
git commit -m "Cleaned out obsolete themes and plugins from wp-content/" > /dev/null
$ECHO "done.";


# Still in SITE
if [ $ADD_GENESIS -eq '1' ]; then
	$ECHO "\n\n${BOLDON}Add genesis in themes${BOLDOFF}";
	cd "$BASE_DIR/wp-content/themes" || exit 1
	unzip -q "$GENESIS_LOCATION" -d .
	git add genesis --all
	git commit -m "Added genesis $GENESIS_TAG " > /dev/null
	$ECHO "done.";


	if [ $ADD_CORE_THEME -eq '1' ]; then
		$ECHO "\n\n${BOLDON}Add the starter theme${BOLDOFF}";
		cd "$BASE_DIR/wp-content/themes" || exit 1
		git clone git@personal:themiked/genesis-starter-theme.git _TMP > /dev/null 2>&1
		mv _TMP/starter starter || exit 1
		rm -rf _TMP > /dev/null
		git add starter --all
		git commit -m "Added the starter theme" > /dev/null
		$ECHO "done.";
	fi
fi
cd "$BASE_DIR"



# Still in SITE
if [ $ADD_PLUGINS -eq 1 ]; then
	$ECHO "\n\n${BOLDON}Installing Plugins:${BOLDOFF}";

	cd "$BASE_DIR/wp-content/plugins" || exit 1
	$ECHO "    ACF5 Pro (local source)";
	#$ECHO "$ACF5_LOCATION";
	unzip -q "$ACF5_LOCATION" -d . || exit 1
	git add advanced-custom-fields-pro --all
	git commit -m "Added ACF5 Pro" > /dev/null

	$ECHO "    Gravity Forms  (local source)";
	#$ECHO "$GRAVITYFORMS_LOCATION";
	unzip -q "$GRAVITYFORMS_LOCATION" -d . || exit 1
	git add gravityforms --all
	git commit -m "Added Gravity Forms" > /dev/null


	cd "$BASE_DIR/wp-content/plugins" || exit 1
	for plugin in "${plugins[@]}" ; do
		zip=${plugin}.zip;
		$ECHO "    $plugin";
		wget --quiet http://downloads.wordpress.org/plugin/${plugin}.zip;
		unzip -q $zip || exit 1
		rm $zip || exit 1
		git add $plugin --all > /dev/null
		git ci -m "Added plugin $plugin" > /dev/null
	done


	$ECHO "done.";
fi
cd "$BASE_DIR"


# Still in SITE
if [ $ADD_CORE_PLUGIN -eq '1' ]; then
	$ECHO "\n\n${BOLDON}Installing Core Functionality plugin${BOLDOFF}";
	cd "$BASE_DIR" || exit 1
	mkdir -p wp-content/mu-plugins || exit 1
	cd wp-content/mu-plugins || exit 1
	git clone git@personal:themiked/plugin-site-core-functionality.git _TMP > /dev/null  2>&1
	mv _TMP/site-core-functionality . || exit 1
	rm -rf _TMP > /dev/null
	mv site-core-functionality/site-core-functionality-loader.php.muonly site-core-functionality-loader.php || exit 1
	git add site-core-functionality* --all
	git ci -m "Added site-core-functionality in mu-plugin/" > /dev/null
	$ECHO "done.";
fi
cd "$BASE_DIR"


# Still in SITE
if [ $ADD_DEV_PLUGINS -eq '1' ]; then
	cd "$BASE_DIR/wp-content/plugins" || exit 1
	$ECHO "\n\n${BOLDON}Installing Public Dev Plugins:${BOLDOFF}";
	for plugin in "${dev_plugins[@]}" ; do
		zip=${plugin}.zip;
		$ECHO "    $plugin";
		wget --quiet http://downloads.wordpress.org/plugin/${plugin}.zip;
		unzip -q $zip || exit 1
		rm $zip || exit 1
		git add $plugin --all > /dev/null
		git ci -m "Added dev plugin $plugin" > /dev/null
	done


	cd "$BASE_DIR/wp-content/plugins" || exit 1
	$ECHO "\n\n${BOLDON}Installing Github Dev Plugins:${BOLDOFF}";
	for plugin in "${!github_plugins[@]}" ; do
		$ECHO "    $plugin";
		git clone ${github_plugins[$plugin]} > /dev/null 2>&1
		rm -rf $plugin/.git > /dev/null
		rm -rf $plugin/.editor* > /dev/null
		git add $plugin --all
		git commit -m "Added the github plugin $plugin" > /dev/null
	done
	cd "$BASE_DIR"
	$ECHO "done.";



	$ECHO "\n\n${BOLDON}Installing my debugging plugin${BOLDOFF}";
	cd "$BASE_DIR/wp-content/plugins" || exit 1
	git clone git@personal:themiked/plugin-debugging.git _TMP > /dev/null 2>&1
	mv _TMP/miked-debugging . || exit 1
	rm -rf _TMP > /dev/null
	git add miked-debugging --all
	git commit -m "Added the debugging plugin" > /dev/null
	cd "$BASE_DIR"
	$ECHO "done.";


fi


$ECHO "\n\n${BOLDON}Site setup complete${BOLDOFF}\n";
$ECHO "${BOLDON}Don't forget to create the DB and update wp-config-local.php${BOLDOFF}";
exit;

