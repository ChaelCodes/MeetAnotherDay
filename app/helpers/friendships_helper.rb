# frozen_string_literal: true

# methods to help with displaying friendship!
module FriendshipsHelper
  def friendship_button(profile)
    return unless current_user.profile&.id
    button_to "Request Friend",
              friendships_path(friendship: {
                                 friend_id: profile.id,
                                 buddy_id: current_user.profile.id
                               }),
              method: :post,
              class: "button is-primary"
  end
end
