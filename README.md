# Git-ified Development WordPress Installer
This is a system to create a git-ified WordPress installation. The end result is that the entire WordPress installation is in git, with the following notes: 
	- WordPress itself is a submodule (see Note (2));
	- the WordPress database credentials;
	- anything in the root folder that is not related to this install;
	- anything in wp-content that is not 
		- themes/ 
		- plugins/ 
		- me-plugins/

## Diagram of resulting install
    SITE
     ├── .git
     │   └── ...
     ├── .gitignore
     ├── README.md
     ├── git-update-wp.sh (1)
     ├── index.php
     ├── wordpress (2)
     │   ├── wp-admin
     │   │   └── ...
     │   ├── wp-content (3)
     │   │   └── ...
     │   └── wp-includes
     │       └── ...
     ├── wp-config-local.php (4)
     ├── wp-config.php (5)
     └── wp-content (6)
         ├── index.php
         ├── mu-plugins (7)
         │   ├── miked-site-core-functionality
         │   └── miked-site-core-functionality-loader.php
         ├── plugins (8)
         │   └── ...
         └── themes (9)
             ├── genesis
             ├── index.php
             ├── starter
             └── twentyfourteen
             

(1) This us a helper to update the WordPress submodule. View the source to see what it does, it's pretty straightforward.

(2) WordPress is a submodule. This means that only a reference to WordPress is in the site git repo, not the WP code itself. By using a submodule, you can test with basically any version of WordPress by simply checking out the appropriate version using git tags. Defaults to what is current. The source for it is the official release, git-ified for just this purpose, found [here](https://github.com/WordPress/WordPress)

(3) wp-content/ is moved out from under wordpress/ because a) Wordpress itself is a module that we want to treat as read-only and b) we want to keep the plugins and themes in our repo.

(4) This file contains the DB creds, prefix and other site-specific settings. Excluded from the repo.

(5) The general config file is included in the repo, and loads wp-config-*.php as appropriate.  This allows easy migration between development, staging and live without having to manage DB creds. View the contents of this file for more info on how it works.

(6) This is the wp-content/ that is actually used by the installation, and is referenced from wp-config.php

(7) mu-plugins/ is not created by default, so I add it and then optionally put my core functionality plugin in there.

(8) various plugins are optionally installed. The list of which ones is defined in addwpinstall.sh

(9) optionally install genesis and my starter theme, and delete everything but twentyfourteen/ of the default themes.


---
sources:

[1](http://blog.g-design.net/post/60019471157/managing-and-deploying-wordpress-with-git)

[2](http://markjaquith.wordpress.com/2011/06/24/wordpress-local-dev-tips/)

[3](http://stevegrunwell.com/blog/keeping-wordpress-under-version-control-with-git/)

[4](http://roybarber.com/version-controlling-wordpress/)