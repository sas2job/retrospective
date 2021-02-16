# frozen_string_literal: true

class CardPolicy < ApplicationPolicy
  def create?
    user.allowed?('create_cards', record.board)
  end

  def update?
    user.allowed?('update_card', record)
  end

  def destroy?
    user.allowed?('destroy_card', record) || user.allowed?('destroy_cards', record.board)
  end

  def like?
    return false if user.allowed?('update_card', record)

    true
  end
end
