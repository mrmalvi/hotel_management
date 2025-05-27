require 'pagy/extras/bootstrap'
require 'pagy/extras/array'
require 'pagy/extras/i18n'
require 'pagy/extras/overflow'

# Pagy initializer file (6.0.4)
# Customize as you see fit.
# https://ddnexus.github.io/pagy/docs/how-to#customize-the-instance

# Pagy DEFAULT Variables
# See https://ddnexus.github.io/pagy/docs/api/pagy#variables
# All the Pagy::DEFAULT are set for all the Pagy instances but can be overridden per instance by just passing them to Pagy.new|Pagy::Countless.new|Pagy::Calendar.new

# Instance variables
# See https://ddnexus.github.io/pagy/docs/api/pagy#instance-variables
Pagy::DEFAULT[:items] = 10                                 # items per page
Pagy::DEFAULT[:size]  = 4                                 # nav bar links size
# Pagy::DEFAULT[:page_param] = :page                       # parameter name
# Pagy::DEFAULT[:params]     = {}                          # parameters to add
# Pagy::DEFAULT[:fragment]   = '#fragment'                 # url fragment to add
# Pagy::DEFAULT[:link_extra] = 'data-remote="true"'        # extra attributes to add to the links
# Pagy::DEFAULT[:i18n_key]   = 'pagy.item_name'            # i18n key for the item name
# Pagy::DEFAULT[:cycle]      = true                        # request cache enabled
# Pagy::DEFAULT[:request_path] = '/'                       # request path

# Extras
# See https://ddnexus.github.io/pagy/categories/extra

# Bootstrap: Nav helper and templates for Bootstrap pagination
# See https://ddnexus.github.io/pagy/docs/extras/bootstrap
# require 'pagy/extras/bootstrap'

# Overflow: Allow for easy handling of overflowing pages
# See https://ddnexus.github.io/pagy/docs/extras/overflow
# require 'pagy/extras/overflow'
# Pagy::DEFAULT[:overflow] = :empty_page    # default  (other options: :last_page and :exception)
