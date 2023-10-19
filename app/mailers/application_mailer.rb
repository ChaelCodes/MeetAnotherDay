# frozen_string_literal: true

# My app's customizations for the ActionMailer
class ApplicationMailer < ActionMailer::Base
  default from: "confbuddies@chael.codes"
  layout "mailer"
end
