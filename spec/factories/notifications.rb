# frozen_string_literal: true

FactoryBot.define do
  factory :notification do
    message { "You have a new Friend Request!" }
    notifiable factory: :friendship
    profile

    trait :report_abuse do
      message { "This event is being reported" }
      profile { nil }
    end
  end
end
