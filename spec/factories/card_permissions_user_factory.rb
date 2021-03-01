# frozen_string_literal: true

FactoryBot.define do
  factory :card_permissions_user do
    user
    permission
    card
  end
end
