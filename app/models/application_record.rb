# frozen_string_literal: true

# This one is the base class for all models which
# are backed by a database table
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
