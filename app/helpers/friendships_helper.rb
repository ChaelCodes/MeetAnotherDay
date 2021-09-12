# frozen_string_literal: true

# methods to help with displaying friendship!
module FriendshipsHelper
  # Shows a button that displays the most likely friendship option
  def friendship_button(profile, my_profile = current_user&.profile)
    return if my_profile.blank?
    friendship = my_profile.friendship_with(profile)
    return request_friend(profile, my_profile) unless friendship
    return view_friendship(friendship) if friendship.accepted?
    return be_my_buddy_button(friendship) if friendship.requested?
    return "Request Declined" if friendship.blocked?
  end

  def be_my_buddy_button(friendship)
    return nil unless friendship.requested? && policy(friendship).accept?
    button_to "Be my buddy?", friendship_path(friendship, {
                                                friendship: {
                                                  status: :accepted
                                                }
                                              }), method: :put,
                                                  class: "button is-primary"
  end

  def block_button(friendship)
    return nil unless policy(friendship).block?
    button_to "Block", friendship_path(friendship, { friendship: { status: :blocked } }),
              method: :put, class: "button is-danger",
              data: {
                confirm: "This action is irreversible. The user will not be able to friend you again."
              }
  end

  # This displays a button to destroy the friendship
  def destroy_friendship_button(friendship)
    return nil unless policy(friendship).destroy?
    text = friendship.accepted? ? "Unfriend" : "Ignore"
    button_to text, friendship_path(friendship),
              class: "button is-danger",
              method: :delete,
              data: {
                confirm: "You will need to request friendship again if you change your mind."
              }
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

  def view_friendship(friendship)
    link_to "✨Friends✨", friendship_path(friendship)
  end
end
