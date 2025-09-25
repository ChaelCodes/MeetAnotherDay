# frozen_string_literal: true

# This Profile attends events and share information
# like bio, status, handle, twitch, YouTube, etc
# Becomes friends with other Profiles through Friendship
class Profile < ApplicationRecord
  include ::Handleable
  include PgSearch::Model

  pg_search_scope :generic_search,
                  against: %i[name handle],
                  using: { tsearch: {
                    any_word: true,
                    prefix: true
                  } }

  # Validations
  validates :user_id, uniqueness: true # rubocop:disable Rails/UniqueValidationWithoutIndex

  # Attributes
  enum :visibility, {
    myself: 0,
    friends: 1,
    # attendees: 2,
    authenticated: 3,
    everyone: 4
  }, prefix: :visible_to

  scope :with_authenticated, -> { where(visibility: %i[everyone authenticated]) }
  scope :nonblocked, ->(profile) { where.not(id: Friendship.blocks(profile).select(:buddy_id)) }
  scope :befriended, lambda { |profile|
    where(id: Friendship.friends_of(profile).select(:buddy_id))
      .where.not(visibility: :myself)
  }

  # Relationships
  belongs_to :user

  delegate :email, to: :user

  has_many :event_attendees, dependent: :destroy
  has_many :events, through: :event_attendees
  has_many :friendships, class_name: "Friendship", foreign_key: "buddy_id", dependent: :destroy, inverse_of: :buddy

  def to_s
    name
  end

  def attending?(event)
    event_attendees.where(event:).any?
  end

  def event_attendee(event)
    event_attendees.where(event:)
  end

  def friends_with?(profile)
    friendships.accepted.find_by(friend: profile)
  end

  # Friendship Requests for this Profile
  def friend_requests
    friendships.requested
  end

  def to_param
    handle
  end
end
