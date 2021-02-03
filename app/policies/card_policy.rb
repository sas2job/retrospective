# frozen_string_literal: true

class CardPolicy < ApplicationPolicy
  def create?
    user.allowed?('create_cards', record.board_id)
  end

  def update?
    user.allowed?('update_card', record.board_id, card_id: record.id)
  end

  def destroy?
    user.allowed?('destroy_card', record.board_id, card_id: record.id) ||
      user.allowed?('destroy_cards', record.board_id)
  end

  def like?
    return false if user.allowed?('update_card', card_id: record.id)

    true
  end
end
