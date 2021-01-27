# frozen_string_literal: true

require 'rails_helper'
require 'rake'

RSpec.describe 'permissions.rake' do
  let(:task_file) { 'tasks/permissions' }

  before do
    Rake.application.rake_require(task_file)
    Rake::Task.define_task(:environment)
  end

  let :run_task do
    Rake::Task[task_name].reenable
    Rake.application.invoke_task(task_name)
  end

  describe 'membership_permissions' do
    let(:user) { create(:user) }
    let_it_be(:board) { create(:board) }
    let_it_be(:creator_permission) { create(:permission, identifier: 'destroy_board') }
    let_it_be(:member_permission) { create(:permission, identifier: 'toggle_ready_status') }
    let_it_be(:other_permission) { create(:permission) }
    let_it_be(:task_name) { 'permissions:membership_permissions' }

    context 'for creator membership' do
      before { create(:membership, user: user, board: board, role: 'creator') }

      it 'connects to missing creator permissions' do
        run_task
        expect(user.permissions).to include(creator_permission, member_permission)
      end

      it 'does not connect to non creator_permissions' do
        run_task
        expect(user.permissions).not_to include(other_permission)
      end
    end

    context 'for member' do
      before { create(:membership, user: user, board: board, role: 'member') }

      it 'connects to missing member permissions' do
        run_task
        expect(user.permissions).to include(member_permission)
      end

      it 'does not connect to non member_permissions' do
        run_task
        expect(user.permissions).not_to include(other_permission, creator_permission)
      end
    end
  end
end
