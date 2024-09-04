FactoryBot.define do
  factory :booking do
    property { nil }
    user { nil }
    start_date { "2024-09-04" }
    end_date { "2024-09-04" }
    status { "MyString" }
  end
end
