FactoryBot.define do
  factory :user do
    # Add user attributes here
    email { "test@example.com" }
    password { "password" }
    # Add any other attributes necessary
  end
end