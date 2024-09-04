FactoryBot.define do
  factory :user do
    # Add user attributes here
    email { 'john@example.com' }
    password { "password" }
    password_confirmation { 'password' }
    # Add any other attributes necessary
  end
end