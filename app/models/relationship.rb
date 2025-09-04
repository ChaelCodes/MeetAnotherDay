# frozen_string_literal: true

# PORO that represents the relationship between two profiles
# Uses both friendships
class Relationship
  include ActiveModel::Model

  attr_accessor :friendship, :other_friendship, :profile, :other_profile

  validates :friendship, :profile, :other_friendship, :other_profile, presence: true

  # Let's create a Relationship object that represents the relationship between two profiles
  # and tracks both friendships
  # profile - current profile, is used for authorization
  # other_profile - the other profile
  # friendship - the friendship between both profiles for the current profile
  # other_friendship - the other profile's friendship
  def initialize(friendship: nil, other_friendship: nil, profile: nil, other_profile: nil)
    super
    self.profile ||= initialize_profile(friendship:, other_friendship:)
    self.other_profile ||= initialize_other_profile(friendship:, other_friendship:)
    self.friendship ||= Friendship.find_or_initialize_by(buddy: self.profile, friend: self.other_profile)
    self.other_friendship ||= Friendship.find_or_initialize_by(buddy: self.other_profile, friend: self.profile)
    validate!
  end

  def initialize_profile(friendship:, other_friendship:)
    friendship&.buddy || other_friendship&.friend
  end

  def initialize_other_profile(friendship:, other_friendship:)
    friendship&.friend || other_friendship&.buddy
  end

  # Each friendship has 4 states
  # accepted, requested, blocked, nil
  # me x you
  def description
    return "#{other_profile.name} sent you a friend request." if request_received?
    return "You are friends with #{other_profile.name}." if friends?
    return "You have sent a friend request to #{other_profile.name}." if request_sent?
    return "You are friendly with #{other_profile.name}." if friendly?
    return "You have blocked #{other_profile.name}." if friendship.blocked?
    "You have no relationship."
  end

  # Profile is friendly, but other_profile is not
  def friendly?
    friendship.accepted?
  end

  def friends?
    friendship.accepted? && other_friendship.accepted?
  end

  # other_profile has sent a friend request to profile
  def request_received?
    friendship.requested? && friendship.persisted?
  end

  # profile has sent a friend request to other_profile
  def request_sent?
    other_friendship.requested? && other_friendship.persisted?
  end
end
