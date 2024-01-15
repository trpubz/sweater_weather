require "faker"

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { "test" }
    password_confirmation { "test" }
  end
end
