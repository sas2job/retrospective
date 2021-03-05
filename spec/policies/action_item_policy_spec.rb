# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ActionItemPolicy do
  let_it_be(:user) { build_stubbed(:user) }
  let_it_be(:board) { build_stubbed(:board) }
  let_it_be(:action_item) { build_stubbed(:action_item, board: board) }
  let_it_be(:closed_action_item) { build_stubbed(:action_item, board: board, status: 'closed') }
  let(:policy) { described_class.new(action_item, user: user, board: board) }

  describe '#create?' do
    subject { policy.apply(:create?) }

    context 'with permission' do
      let_it_be(:create_permission) { create(:permission, identifier: 'create_action_items') }
      before do
        create(:board_permissions_user, permission: create_permission, user: user, board: board)
      end

      it { is_expected.to eq true }
    end

    context 'without permission' do
      it { is_expected.to eq false }
    end
  end

  describe '#update?' do
    subject { policy.apply(:update?) }

    context 'with permission' do
      let_it_be(:update_permission) { create(:permission, identifier: 'update_action_items') }
      before do
        create(:board_permissions_user, permission: update_permission, user: user, board: board)
      end

      it { is_expected.to eq true }
    end

    context 'without permission' do
      it { is_expected.to eq false }
    end
  end

  describe '#destroy?' do
    subject { policy.apply(:destroy?) }

    context 'with permission' do
      let_it_be(:destroy_permission) { create(:permission, identifier: 'destroy_action_items') }
      before do
        create(:board_permissions_user, permission: destroy_permission, user: user, board: board)
      end

      it { is_expected.to eq true }
    end

    context 'without permission' do
      it { is_expected.to eq false }
    end
  end

  describe '#move?' do
    subject { policy.apply(:move?) }

    context 'with permission' do
      let_it_be(:move_permission) { create(:permission, identifier: 'move_action_items') }
      before do
        create(:board_permissions_user, permission: move_permission, user: user, board: board)
      end

      it 'if aasm state may transition to pending?' do
        allow(action_item).to receive(:pending?).and_return(true)

        is_expected.to eq true
        expect(action_item).to have_received(:pending?)
      end

      it 'if aasm state may not transition to pending?' do
        allow(action_item).to receive(:pending?).and_return(false)

        is_expected.to eq false
        expect(action_item).to have_received(:pending?)
      end
    end

    context 'without permission' do
      it { is_expected.to eq false }
    end
  end

  describe '#close?' do
    subject { policy.apply(:close?) }

    context 'with permission' do
      let_it_be(:close_permission) { create(:permission, identifier: 'close_action_items') }
      before do
        create(:board_permissions_user, permission: close_permission, user: user, board: board)
      end

      it 'if aasm state may transition to closed' do
        allow(action_item).to receive(:may_close?).and_return(true)

        is_expected.to eq true
        expect(action_item).to have_received(:may_close?)
      end

      it 'if aasm state may not transition to closed?' do
        allow(action_item).to receive(:may_close?).and_return(false)

        is_expected.to eq false
        expect(action_item).to have_received(:may_close?)
      end
    end

    context 'without permission' do
      it { is_expected.to eq false }
    end
  end

  describe '#complete?' do
    let(:action_item) { build_stubbed(:action_item, board: board, status: 'pending') }
    subject { policy.apply(:complete?) }

    context 'with permission' do
      let_it_be(:complete_permission) { create(:permission, identifier: 'complete_action_items') }
      before do
        create(:board_permissions_user, permission: complete_permission, user: user, board: board)
      end

      it 'if aasm state may transition to completed' do
        allow(action_item).to receive(:may_complete?).and_return(true)

        is_expected.to eq true
        expect(action_item).to have_received(:may_complete?)
      end

      it 'if aasm state may not transition to completed' do
        allow(action_item).to receive(:may_complete?).and_return(false)

        is_expected.to eq false
        expect(action_item).to have_received(:may_complete?)
      end
    end

    context 'without permission' do
      it { is_expected.to eq false }
    end
  end

  describe '#reopen?' do
    let(:action_item) { build_stubbed(:action_item, board: board, status: 'closed') }
    subject { policy.apply(:reopen?) }

    context 'with permission' do
      let_it_be(:reopen_permission) { create(:permission, identifier: 'reopen_action_items') }
      before do
        create(:board_permissions_user, permission: reopen_permission, user: user, board: board)
      end

      it 'if aasm state may transition to pending' do
        allow(action_item).to receive(:may_reopen?).and_return(true)

        is_expected.to eq true
        expect(action_item).to have_received(:may_reopen?)
      end

      it 'if aasm state may not transition to completed' do
        allow(action_item).to receive(:may_reopen?).and_return(false)

        is_expected.to eq false
        expect(action_item).to have_received(:may_reopen?)
      end
    end

    context 'without permission' do
      it { is_expected.to eq false }
    end
  end

  describe '#current_board' do
    subject { policy.apply(:current_board) }

    context 'a board from context is provided' do
      it { is_expected.to eq board }
    end

    context 'a board from context is not provided' do
      let(:other_board) { create(:board) }
      let(:action_item) { create(:action_item, board: other_board) }
      let(:policy) { described_class.new(action_item, user: user, board: nil) }

      it { is_expected.to eq other_board }
    end
  end
end
