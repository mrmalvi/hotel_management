FactoryBot.define do
  factory :booking do
    user { nil }
    room { nil }
    check_in { "2025-05-20 11:01:27" }
    check_out { "2025-05-20 11:01:27" }
    status { "MyString" }
    total_price { "9.99" }
  end
end
