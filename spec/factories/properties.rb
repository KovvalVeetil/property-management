FactoryBot.define do
  factory :property do
    title { "MyString" }
    description { "MyText" }
    price { "9.99" }
    location { "MyString" }
    user { nil }
  end
end
