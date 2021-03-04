# frozen_string_literal: true

class ActionItemPolicy < ApplicationPolicy
  authorize :board, allow_nil: true

  def create?
    user.allowed?('create_action_items', board)
  end

  def update?
    user.allowed?('update_action_items', current_board)
  end

  def destroy?
    user.allowed?('destroy_action_items', current_board)
  end

  def move?
    user.allowed?('move_action_items', current_board) && record.pending?
  end

  def close?
    user.allowed?('close_action_items', current_board) && record.may_close?
  end

  def complete?
    user.allowed?('complete_action_items', current_board) && record.may_complete?
  end

  def reopen?
    user.allowed?('reopen_action_items', current_board) && record.may_reopen?
  end

  def current_board
    board || record.board
  end
end
