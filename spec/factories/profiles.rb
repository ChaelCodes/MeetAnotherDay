# frozen_string_literal: true

FactoryBot.define do
  factory :profile do
    user
    name { "Chael" }
    sequence(:handle) { |n| "ChaelCodes#{n}" }
    bio { "I definitely have a bio, that I am prepared to share." }
    visibility { "authenticated" }
  end
end
