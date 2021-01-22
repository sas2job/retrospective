# frozen_string_literal: true

class MembershipPolicy < ApplicationPolicy
  authorize :membership, allow_nil: true

  def ready_toggle?
    user.allowed?('toggle_ready_status', record.board_id)
  end

  def destroy?
    return false if record.user_id == user.id

    user.allowed?('destroy_membership', record.board_id)
  end
end
