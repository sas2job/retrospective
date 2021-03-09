# frozen_string_literal: true

FactoryBot.define do
  factory :comment_permissions_user do
    user
    permission
    comment
  end
end
