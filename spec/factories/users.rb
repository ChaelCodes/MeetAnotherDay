# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    bio { "Hello. I am dev. Friends please? Ty." }
    sequence(:email) { |i| "buddy#{i}@example.com" }
    name { "Chael" }
    password { "P@55w0rd" }
    confirmed_at { 1.day.ago }

    trait :unconfirmed do
      confirmed_at { 1.day.ago }
    end

    trait :admin do
      admin { true }
    end
  end
end
