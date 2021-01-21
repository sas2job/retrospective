# frozen_string_literal: true

class MembershipPolicy
  include ActionPolicy::Policy::Core
  include ActionPolicy::Policy::Authorization
  include ActionPolicy::Policy::Reasons

  authorize :membership, allow_nil: true
  authorize :user

  def ready_toggle?
    user.allowed?('toggle_ready_status', record.board.id)
  end

  def destroy?
    user.allowed?('destroy_membership', record.board.id) && non_self_membership?
  end

  def non_self_membership?
    record.user != user
  end
end
