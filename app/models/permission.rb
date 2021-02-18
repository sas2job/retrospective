# frozen_string_literal: true

class Permission < ApplicationRecord
  CREATOR_IDENTIFIERS = %w[view_private_board edit_board update_board get_suggestions
                           destroy_board continue_board create_cards invite_members
                           toggle_ready_status destroy_membership destroy_any_card
                           like_card].freeze
  MEMBER_IDENTIFIERS = %w[view_private_board create_cards toggle_ready_status like_card].freeze
  AUTHOR_IDENTIFIERS = %w[update_card destroy_card].freeze

  has_many :board_permissions_users, dependent: :destroy
  has_many :board_users, through: :board_permissions_users, source: :user
  has_many :card_permissions_users, dependent: :destroy
  has_many :card_users, through: :card_permissions_users, source: :user

  validates_presence_of :description, :identifier
  validates_uniqueness_of :identifier

  scope :creator_permissions, -> { where(identifier: CREATOR_IDENTIFIERS) }
  scope :member_permissions, -> { where(identifier: MEMBER_IDENTIFIERS) }
  scope :author_permissions, -> { where(identifier: AUTHOR_IDENTIFIERS) }
end
