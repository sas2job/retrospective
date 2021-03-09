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

  describe 'create_missing_permissions' do
    let(:user) { create(:user) }
    let_it_be(:board) { create(:board) }
    let_it_be(:other_permission) { create(:permission) }

    context 'for boards' do
      let_it_be(:task_name) { 'permissions:create_missing_for_boards' }

      context 'with creator membership' do
        let_it_be(:creator_permission) { create(:permission, identifier: 'destroy_board') }
        before { create(:membership, user: user, board: board, role: 'creator') }

        it 'connects to missing creator permissions' do
          run_task
          expect(user.board_permissions).to include(creator_permission)
        end

        it 'does not connect to non creator_permissions' do
          run_task
          expect(user.board_permissions).not_to include(other_permission)
        end
      end

      context 'with members' do
        let_it_be(:member_permission) { create(:permission, identifier: 'toggle_ready_status') }

        before { create(:membership, user: user, board: board, role: 'member') }

        it 'connects to missing member permissions' do
          run_task
          expect(user.board_permissions).to include(member_permission)
        end

        it 'does not connect to non member_permissions' do
          run_task
          expect(user.board_permissions).not_to include(other_permission)
        end
      end
    end

    context 'for cards' do
      let_it_be(:card_permission) { create(:permission, identifier: 'update_card') }
      let!(:card) { create(:card, author: user) }
      let_it_be(:task_name) { 'permissions:create_missing_for_cards' }

      it 'builds missing card permissions' do
        run_task
        expect(user.card_permissions).to include(card_permission)
      end

      it 'does not build non card permissions' do
        run_task
        expect(user.card_permissions).not_to include(other_permission)
      end
    end

    context 'for comments' do
      let_it_be(:comment_permission) { create(:permission, identifier: 'update_comment') }
      let!(:comment) { create(:comment, author: user) }
      let_it_be(:task_name) { 'permissions:create_missing_for_comments' }

      it 'builds missing comment permissions' do
        run_task
        expect(user.comment_permissions).to include(comment_permission)
      end

      it 'does not build non card permissions' do
        run_task
        expect(user.comment_permissions).not_to include(other_permission)
      end
    end
  end
end
