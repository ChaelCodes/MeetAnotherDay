# frozen_string_literal: true

# Allows the object to be called by a handle in the URL
# Modifications to the controller are also necessary.
module Handleable
  extend ActiveSupport::Concern

  URL_POSSIBLE_REGEX = /\A[A-z0-9\-]+\z/

  included do
    validates :handle, presence: true,
                       format: { with: URL_POSSIBLE_REGEX },
                       uniqueness: { case_sensitive: false }
  end
end
