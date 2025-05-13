# frozen_string_literal: true

# My app's customizations for the ActionMailer
class ApplicationMailer < ActionMailer::Base
  default from: "no-reply@meetanother.day"
  layout "mailer"
end
