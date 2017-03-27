<?php
/**
 * The base configurations of the WordPress.
 *
 * This file has the following configurations: MySQL settings, Table Prefix,
 * Secret Keys, WordPress Language, and ABSPATH. You can find more information
 * by visiting {@link http://codex.wordpress.org/Editing_wp-config.php Editing
 * wp-config.php} Codex page. You can get the MySQL settings from your web host.
 *
 * This file is used by the wp-config.php creation script during the
 * installation. You don't have to use the web site, you can just copy this file
 * to "wp-config.php" and fill in the values.
 *
 * @package WordPress
 */


$cnmd_http = ($_SERVER['HTTPS']) ? 'https://': 'http://';
$cnmd_server_name = rtrim($_SERVER['HTTP_HOST'],"/");
$cnmd_document_root = rtrim(dirname(__FILE__),"/");


// The wordpress install is in its own folder, so we force that setting here
define('WP_SITEURL', $cnmd_http . $cnmd_server_name . '/wordpress');
//define('WP_SITEURL', $cnmd_http .rtrim($_SERVER['SERVER_NAME'],"/") . '/wordpress');
define('WP_HOME',    $cnmd_http . $cnmd_server_name);
//define('WP_HOME',    $cnmd_http . $_SERVER['HTTP_HOST']);


// The wordpress wp-content folder is outside of the git WordPress submodule so
//     tell WP where it is. These may have to be set manually in some cases
define('WP_CONTENT_URL', $cnmd_http . $cnmd_server_name . '/wp-content');
//define('WP_CONTENT_URL', $cnmd_http . rtrim($_SERVER['SERVER_NAME'],"/") . '/wp-content');

define('WP_CONTENT_DIR', $cnmd_document_root . '/wp-content');
//define('WP_CONTENT_DIR', rtrim($_SERVER['DOCUMENT_ROOT'],"/") . '/wp-content');


// Four stages
// local = local development on my workstation
// staging = site is on my staging server
// live = site is live and under my ongoing maintenance
// released = site is live and I play no role in maintenance. In this case, the logic 
//  block below is removed and everything reverts back to a single file, and all traces
//  of git are purged leaving a normal site. This is all done manually btw.

if ( file_exists( dirname( __FILE__ ) . '/wp-config-local.php' ) ) {
  	define( 'CNMD_DEV_STATUS', 'local' );
  	include( dirname( __FILE__ ) . '/wp-config-local.php' );
	
	// I don't need cron running, so turn it off
	define( 'DISABLE_WP_CRON', true );

	// Enable all debugging
  	define('WP_DEBUG', false);

} else if ( file_exists( dirname( __FILE__ ) . '/wp-config-staging.php' ) ) {
  	define( 'CNMD_DEV_STATUS', 'staging' );
	include( dirname( __FILE__ ) . '/wp-config-staging.php' );

	// Disable all core updates, as they are handled on local machine and done via git
 	define( 'WP_AUTO_UPDATE_CORE', false );
	define( 'DISALLOW_FILE_MODS', true );
	define( 'AUTOMATIC_UPDATER_DISABLED', true );

	// I Handle cron via system cron, so disable wp_cron
	define( 'DISABLE_WP_CRON', true );

} else if ( file_exists( dirname( __FILE__ ) . '/wp-config-live.php' ) ) {
  	define( 'CNMD_DEV_STATUS', 'live' );
  	include( dirname( __FILE__ ) . '/wp-config-live.php' );

	//Disable all core updates, as they are handled on local machine and done via git
 	define( 'WP_AUTO_UPDATE_CORE', false );
	define( 'DISALLOW_FILE_MODS', true );
	define( 'AUTOMATIC_UPDATER_DISABLED', true );

	// Disable all debugging
  	define('WP_DEBUG', false);
}


// NOTE: If upgrading from an old installation and DB_CHARSET and DB_COLLATE do not exist 
//  in the wp-config.php file, DO NOT ADD THEM. Read more here
//  https://codex.wordpress.org/Editing_wp-config.php#Database_character_set
// Database Charset to use in creating database tables.
define('DB_CHARSET', 'utf8');

// The Database Collate type. Don't change this if in doubt.
define('DB_COLLATE', '');

/**
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
// NOTE: This is a placeholder replaced with new salts via the site creation script
//  It will throw an error if not done correctly. This is by design.
//__SALTS__

/**
 * WordPress Localized Language, defaults to English.
 *
 * Change this to localize WordPress. A corresponding MO file for the chosen
 * language must be installed to wp-content/languages. For example, install
 * de_DE.mo to wp-content/languages and set WPLANG to 'de_DE' to enable German
 * language support.
 */
define('WPLANG', '');

/* That's all, stop editing! Happy blogging. */

/** Absolute path to the WordPress directory. */
if ( !defined('ABSPATH') )
	define('ABSPATH', dirname(__FILE__) . '/');

/** Sets up WordPress vars and included files. */
require_once(ABSPATH . 'wp-settings.php');