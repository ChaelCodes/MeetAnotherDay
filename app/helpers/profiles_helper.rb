# frozen_string_literal: true

# Helper methods for managing Profiles
module ProfilesHelper
  def profile_picture(email, size: 80)
    "https://gravatar.com/avatar/#{Digest::SHA2.hexdigest(email.downcase.strip)}" \
      "?s=#{size}&d=retro&r=pg"
  end
end
