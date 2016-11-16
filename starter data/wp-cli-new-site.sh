# activate the starter theme
wp theme activate starter

# activate required plugins
wp plugin activate genesis-404-page
wp plugin activate genesis-taxonomy-images
wp plugin activate cnmd-debugging
wp plugin activate admin-post-navigation
wp plugin activate advanced-custom-fields-pro
wp plugin activate busted
wp plugin activate duplicate-menu
wp plugin activate gravityforms
wp plugin activate wp-sync-db
wp plugin activate page-template-dashboard

# delete the default posts pages and comments
wp post delete 1
wp post delete 2
wp comment delete 1

# inject the font testing page
wp post create --post_type=page --post_status=publish --post_title="Font Testing" ~/git/Wordpress.tools/wp-base-tools/starter\ data/page-font-test.txt

# create the info page and subpages
wp post create --post_type=page --post_status=publish --post_title="Info"
wp post meta update 6 _wp_page_template page-subpage_index.php
wp post create --post_type=page --post_status=publish --post_parent=6 --post_title="About Us"
wp post create --post_type=page --post_status=publish --post_parent=6 --post_title="Awards"
wp post meta update 8 _wp_page_template archive.php
wp post create --post_type=page --post_status=publish --post_parent=6 --post_title="Press"
wp post meta update 9 _wp_page_template archive.php
wp post create --post_type=page --post_status=publish --post_parent=6 --post_title="Testimonials"
wp post meta update 10 _wp_page_template archive.php
wp post create --post_type=page --post_status=publish --post_parent=6 --post_title="Albums"
wp post create --post_type=page --post_status=publish --post_parent=6 --post_title="Pricing"

# set up the home page
wp post create --post_type=page --post_status=publish --post_title="Home"
wp post meta update 13 _wp_page_template page-flex.php

# set up the archive pages
wp post create --post_type=page --post_status=publish --post_title="Categories" --post_name="category"
wp post meta update 14 _wp_page_template archive.php
wp post create --post_type=page --post_status=publish --post_title="Tags" --post_name="tag"
wp post meta update 15 _wp_page_template archive.php
wp post create --post_type=page --post_status=publish --post_title="Types" --post_name="wedding-types"
wp post meta update 16 _wp_page_template archive.php
wp post create --post_type=page --post_status=publish --post_title="Venues" --post_name="wedding-venues"
wp post meta update 17 _wp_page_template archive.php
wp post create --post_type=page --post_status=publish --post_title="Clients" --post_name="my-awesome-clients"
wp post meta update 18 _wp_page_template archive.php
wp post create --post_type=page --post_status=publish --post_title="Settings"  --post_name="wedding-settings"
wp post meta update 18 _wp_page_template archive.php
wp post create --post_type=page --post_status=publish --post_title="Vendors" --post_name="wedding-vendors"
wp post meta update 19 _wp_page_template archive.php

# set up the remaining pages
wp post create --post_type=page --post_status=publish --post_title="Contact" 
wp post create --post_type=page --post_status=publish --post_title="Blog"

# set up the category terms
wp term update category 1 --name="Weddings" --slug="best-weddings"
wp term create category "Engagements" --slug="best-engagements"
wp term create category "Studio News" --slug="studio-news"
wp term create category "Portraits" --slug="best-portraits"

# inject the top level vendor terms 
wp term create vendortax --slug=cakemakers-and-bakers "Cakemakers and Bakers"
wp term create vendortax --slug=caterers "Caterers"
wp term create vendortax --slug=couture "Couture"
wp term create vendortax --slug=florists "Florists"
wp term create vendortax --slug=planners-and-event-designers "Planners and Event Designers"
wp term create vendortax --slug=hair-and-makeup-artists "Hair and Makeup Artists"
wp term create vendortax --slug=musicians-and-djs "Musicians and DJs"

# set the wp settings
wp option update page_on_front 13
wp option update page_for_posts 22
wp option update timezone_string "America/Toronto"
wp option update rss_use_excerpt 1
wp option update permalink_structure "/%category%/%postname%/"
wp option update cnmd_debug_show_template_info_src 1
