# frozen_string_literal: true

class CommentPolicy < ApplicationPolicy
  def update?
    user.allowed?('update_comment', record)
  end

  def destroy?
    user.allowed?('destroy_comment', record)
  end

  def like?
    check?(:user_not_author?)
  end

  def user_not_author?
    !record.author?(user)
  end
end
