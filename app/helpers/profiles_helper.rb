# frozen_string_literal: true

# Helper methods for managing Profiles
module ProfilesHelper
  def profile_picture(email)
    "https://gravatar.com/avatar/#{Digest::SHA2.hexdigest(email.downcase.strip)}" \
      "?s=80&d=retro&r=pg"
  end
end
