# frozen_string_literal: true

FactoryBot.define do
  factory :profile do
    user
    name { "Chael" }
    handle { "ChaelCodes" }
    bio { "I definitely have a bio, that I am prepared to share." }
  end
end
