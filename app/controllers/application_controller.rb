# frozen_string_literal: true

# this is the base controller for my application, all controllers
# inherit from here
class ApplicationController < ActionController::Base
  # Is the user required to be logged in before the
  # controller's endpoints can be accessed?
  def self.require_authentication?
    true
  end
  before_action :authenticate_user! if require_authentication?
end
