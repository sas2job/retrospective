# frozen_string_literal: true

class PermissionsUser < ApplicationRecord
  belongs_to :user
  belongs_to :permission
  belongs_to :board
  belongs_to :card, optional: true

  validates_uniqueness_of :permission_id, scope: %i[user_id board_id card_id]
end
