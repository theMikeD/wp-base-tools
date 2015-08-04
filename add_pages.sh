# Inject required pages
wp post create --post_type=page --post_title="Blog" --post_status="publish"
wp post create --post_type=page --post_title="Home" --post_status="publish"
wp post create --post_type=page --post_title="Awards" --post_status="publish"
wp post create --post_type=page --post_title="Testimonials" --post_status="publish"
wp post create --post_type=page --post_title="Contact" --post_status="publish"
wp post create --post_type=page --post_title="About" --post_status="publish"
wp post create /Users/mike/git/Wordpress.tools/wp-base-tools/page-font-test.txt --post_type=page --post_title="Font Testing" --post_status="publish"

# Taxonomy archive pages
wp post create --post_type=page --post_title="Categories" --slug="category" --post_status="publish"
wp post create --post_type=page --post_title="Tags" --slug="tag" --post_status="publish"
wp post create --post_type=page --post_title="Venues" --post_status="publish" --post_name='wedding-venues'
wp post create --post_type=page --post_title="Vendors" --post_status="publish" --post_name='wedding-vendors'
wp post create --post_type=page --post_title="Photographers" --post_status="publish" --post_name='wedding-photographers'


# Activate desired plugins
wp plugin activate admin-post-navigation
wp plugin activate advanced-custom-fields-pro
wp plugin activate advanced-custom-field-repeater-collapser
wp plugin activate miked-debugging
wp plugin activate term-management-tools
wp plugin activate wp-find-shared-terms
wp plugin activate wp-sync-db


# Inject top-level vendor terms
wp term create vendortax 'Cakemaker'
wp term create vendortax 'Caterer'
wp term create vendortax 'Couture'
wp term create vendortax 'Florist'
wp term create vendortax 'Event Designer'
wp term create vendortax 'Hair Designer'
wp term create vendortax 'Makeup Artists'
wp term create vendortax 'Live Music'
wp term create vendortax 'DJs'
wp term create vendortax 'Event Planner'


wp term create category 'Portraits'
wp term create category 'Engagements'
wp term create category 'Studio News'


# set time zone
# rename uncategorized cat to Weddings
