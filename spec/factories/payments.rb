FactoryBot.define do
  factory :payment do
    booking { nil }
    amount { "9.99" }
    status { "MyString" }
  end
end
