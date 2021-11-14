# frozen_string_literal: true

FactoryBot.define do
  factory :notification do
    message { "You have a new Friend Request!" }
    association :notifiable, factory: :friendship
    association :notified, factory: :profile
    association :notifier, factory: :profile

    trait :report_abuse do
      message { "This event is being reported" }
      notified { nil }
    end
  end
end
