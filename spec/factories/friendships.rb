# frozen_string_literal: true

FactoryBot.define do
  factory :friendship do
    buddy factory: :profile
    friend factory: :profile
    status { :requested }
  end
end
