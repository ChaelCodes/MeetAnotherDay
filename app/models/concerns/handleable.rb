# frozen_string_literal: true

# Allows the object to be called by a handle in the URL
# Modifications to the controller are also necessary.
module Handleable
  extend ActiveSupport::Concern

  URL_POSSIBLE_REGEX = /\A[A-Za-z0-9\-_]+\z/

  included do
    validates :handle, presence: true,
                       format: { with: URL_POSSIBLE_REGEX },
                       uniqueness: { case_sensitive: false }
  end

  class_methods do
    # Find with handle - case insensitive search
    def find_with_handle(handle)
      find_by("UPPER(handle) = ?", handle.upcase)
    end
  end
end
