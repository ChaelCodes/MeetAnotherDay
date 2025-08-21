# frozen_string_literal: true

# Helper methods for managing Profiles
module ProfilesHelper
  UNAUTHORIZED_PROFILE_MESSAGES = {
    everyone: "",
    authenticated: "You must be logged in, and your email confirmed to view this profile.",
    friends: "You must be friends to view this profile.",
    myself: "This profile is not visible to others at this time."
  }.freeze

  def profile_picture(email, size: 80)
    "https://gravatar.com/avatar/#{Digest::SHA2.hexdigest(email.downcase.strip)}" \
      "?s=#{size}&d=retro&r=pg"
  end

  def unauthorized_message(profile, blocked: false)
    return UNAUTHORIZED_PROFILE_MESSAGES[:myself] if blocked
    UNAUTHORIZED_PROFILE_MESSAGES.with_indifferent_access[profile.visibility]
  end
end
