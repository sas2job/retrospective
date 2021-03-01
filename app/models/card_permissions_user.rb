# frozen_string_literal: true

class CardPermissionsUser < ApplicationRecord
  belongs_to :user
  belongs_to :permission
  belongs_to :card

  validates_uniqueness_of :permission_id, scope: %i[user_id card_id]
end
