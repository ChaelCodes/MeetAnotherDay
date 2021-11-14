FactoryBot.define do
  factory :notification do
    message { "MyString" }
    notifiable { nil }
    notified { nil }
    notifier { nil }
  end
end
