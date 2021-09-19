# frozen_string_literal: true

# methods to help with displaying friendship!
module FriendshipsHelper
  def friendship_button(profile, my_profile = current_user&.profile)
    return if my_profile.blank?
    friendship = my_profile.friendship_with(profile)
    case friendship&.status
    when nil
      request_friend(profile, my_profile)
    when "accepted"
      link_to "✨Friends✨", friendship_path(friendship)
    when "declined"
      "Request Declined"
    when "requested", "ignored"
      if my_profile.id == friendship.friend_id
        be_my_buddy_button(friendship)
      else
        "Request Sent"
      end
    end
  end

  def be_my_buddy_button(friendship)
    button_to "Be my buddy?", friendship_path(friendship, { status: :accepted }), method: :put, class: "btn btn-primary"
  end

  def decline_friendship_button(friendship)
    button_to "Ignore", friendship_path(friendship), method: :put, class: "btn btn-danger"
  end

  def request_friend(profile, my_profile)
    button_to "Request Friend",
              friendships_path(friendship: {
                                 friend_id: profile.id,
                                 buddy_id: my_profile.id
                               }),
              method: :post,
              class: "button is-primary"
  end
end
