# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    sequence(:nickname) { |n| "user_nick#{n}" }
    password { 'password' }
    password_confirmation { 'password' }
    first_name { 'Name' }
    last_name { 'Surname' }
    provider { Faker::App.name.downcase }
    uid { Faker::Number.number }
  end
end
