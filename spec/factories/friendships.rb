# frozen_string_literal: true

FactoryBot.define do
  factory :friendship do
    buddy { create :profile }
    friend { create :profile }
    status { :requested }
  end
end
