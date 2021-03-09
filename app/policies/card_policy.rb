# frozen_string_literal: true

class CardPolicy < ApplicationPolicy
  def update?
    user.allowed?('update_card', record)
  end

  def destroy?
    user.allowed?('destroy_card', record) || user.allowed?('destroy_any_card', record.board)
  end

  def like?
    record.author_id == user.id ? false : user.allowed?('like_card', record)
  end
end
