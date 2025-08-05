# frozen_string_literal: true

# Optionally override some pagy default with your own in the pagy initializer
Pagy::DEFAULT[:limit] = 10 # items per page
Pagy::DEFAULT[:size]  = 5 # nav bar links
# Better user experience handled automatically
require 'pagy/extras/overflow'
Pagy::DEFAULT[:overflow] = :last_page
require 'pagy/extras/bulma'
require 'pagy/extras/limit'
# This extra must come last or it does not nest all params inside page properly
require 'pagy/extras/jsonapi'
