# frozen_string_literal: true

FactoryBot.define do
  factory :notification do
    # Creating this notification will also create a friendship which creates a notification
    # I've done some work to prevent this, but I suspect it's a concurrency issue
    # and we'll need an index.
    message { "You have a new Friend Request!" }
    notifiable factory: :friendship
    url { "http://www.example.com/friendships/#{notifiable.id}" }
    profile { notifiable.buddy }

    trait :report_abuse do
      message { "This event is being reported" }
      profile { nil }
    end
  end
end
