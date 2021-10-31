# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    bio { "Hello. I am dev. Friends please? Ty." }
    sequence(:email) { |i| "buddy#{i}@example.com" }
    name { "Chael" }
    password { "P@55w0rd" }
    confirmed_at { 1.day.ago }

    trait :unconfirmed_with_trial do
      confirmed_at { nil }
    end

    trait :unconfirmed do
      confirmed_at { nil }
      after(:create) do |user|
        # Overwrite confirmation_sent_at
        user.update(confirmation_sent_at: 4.days.ago)
      end
    end

    trait :overdue_unconfirmed do
      confirmed_at { nil }
      after(:create) do |user|
        # Overwrite confirmation_sent_at
        user.update(confirmation_sent_at: 4.days.ago)
      end
    end

    trait :admin do
      admin { true }
    end
  end
end
