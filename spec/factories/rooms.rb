FactoryBot.define do
  factory :room do
    room_type { nil }
    room_number { "MyString" }
    floor { 1 }
    status { "MyString" }
  end
end
