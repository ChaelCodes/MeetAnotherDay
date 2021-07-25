# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: "confbuddies@chael.codes"
  layout "mailer"
end
