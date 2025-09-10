# frozen_string_literal: true

# methods to help with displaying friendship!
module FriendshipsHelper
  # Accept a Friendship Request
  def accept_friendship_button(friendship, current_profile)
    return nil unless friendship&.requested? && friendship.persisted?
    return nil unless friendship&.buddy == current_profile
    button_to "Accept friend request", friendship_path(friendship, {
                                                         friendship: {
                                                           status: :accepted
                                                         }
                                                       }), form_class: "card-footer-item p-0 control",
                                                           method: :put,
                                                           class: "button is-success is-fullwidth is-radiusless"
  end

  def befriend_button(friendship, current_profile)
    return nil if friendship.persisted?
    return nil unless friendship.buddy == current_profile
    button_to "Befriend",
              friendships_path(friendship: {
                                 friend_id: friendship.friend_id,
                                 buddy_id: friendship.buddy_id,
                                 status: :accepted
                               }), form_class: "card-footer-item p-0 control",
                                   method: :post,
                                   class: "button is-success is-fullwidth is-radiusless"
  end

  # Block a Friendship - Create if no Friendship exists, Update if it does
  def block_button(friendship, current_profile)
    return nil if friendship.blocked?
    return nil unless friendship.buddy == current_profile
    button_to "Block", friendship,
              params: { friendship: {
                status: :blocked,
                buddy_id: friendship.buddy_id,
                friend_id: friendship.friend_id
              } },
              form_class: "card-footer-item p-0 control",
              class: "button is-danger is-outlined is-fullwidth is-radiusless"
  end

  # Cancel a friend request
  def cancel_friendship_button(relationship)
    return unless relationship.request_sent?
    button_to "Cancel friend request",
              friendship_path(relationship.other_friendship),
              form_class: "card-footer-item p-0 control",
              class: "button is-warning is-outlined is-fullwidth is-radiusless",
              method: :delete
  end

  # This displays a button to destroy the friendship
  def destroy_friendship_button(relationship)
    friendship = relationship.friendship
    return unless friendship.persisted?
    return if relationship.request_sent?
    button_names = { "accepted" => "Unfriend", "blocked" => "Unblock", "requested" => "Ignore" }
    button_to button_names[friendship.status],
              friendship_path(friendship),
              form_class: "card-footer-item p-0 control",
              class: "button is-warning is-outlined is-fullwidth is-radiusless",
              method: :delete
  end

  # Request the Friendship of another user
  def request_friend_button(relationship)
    return if relationship.other_friendship.persisted?
    return unless relationship.friendship.accepted?

    button_to "Request Friend",
              friendships_path(friendship: {
                                 friend_id: relationship.profile.id,
                                 buddy_id: relationship.other_profile.id,
                                 status: "requested"
                               }), method: :post,
                                   form_class: "card-footer-item p-0 control",
                                   class: "button is-primary is-fullwidth is-radiusless"
  end

  def view_friendship(friendship)
    link_to "View", friendship, class: "button is-info"
  end

  def relationship_buttons(relationship)
    return nil unless relationship
    safe_join([
      befriend_button(relationship.friendship, relationship.profile),
      accept_friendship_button(relationship.friendship, relationship.profile),
      request_friend_button(relationship),
      cancel_friendship_button(relationship),
      destroy_friendship_button(relationship),
      block_button(relationship.friendship, relationship.profile)
    ].compact)
  end
end
