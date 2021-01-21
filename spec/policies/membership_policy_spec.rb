# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MembershipPolicy do
  let_it_be(:creator) { create(:user) }
  let_it_be(:user) { create(:user) }
  let_it_be(:board) { create(:board) }
  let_it_be(:creatorship) { create(:membership, user: creator, board: board) }
  let_it_be(:membership) { create(:membership, user: user, board: board) }
  let(:policy) { described_class.new(creatorship, membership: test_membership, user: creator) }

  describe '#ready_toggle?' do
    let_it_be(:toggle_permission) { create(:permission, identifier: 'toggle_ready_status') }
    subject { policy.apply(:ready_toggle?) }

    context 'when user has permission' do
      before do
        create(:permissions_user, permission: toggle_permission, user: creator, board: board)
      end

      context 'and is a member of board' do
        let(:test_membership) { creatorship }
        it { is_expected.to eq true }
      end
      context 'and is not a member' do
        let(:test_membership) { nil }
        it { is_expected.to eq true }
      end
    end

    context 'when user does not have permission' do
      context 'and is a member of board' do
        let(:test_membership) { creatorship }
        it { is_expected.to eq false }
      end
      context 'and is not a member of board' do
        let(:test_membership) { nil }
        it { is_expected.to eq false }
      end
    end
  end

  describe '#destroy?' do
    let_it_be(:destroy_permission) { create(:permission, identifier: 'destroy_membership') }
    let(:policy) do
      described_class.new(membership_to_destroy, membership: test_membership, user: creator)
    end
    let(:membership_to_destroy) { nil }
    subject { policy.apply(:destroy?) }

    context 'when user has permission' do
      let(:test_membership) { creatorship }
      before do
        create(:permissions_user, permission: destroy_permission, user: creator, board: board)
      end

      context 'and target another membership' do
        let(:membership_to_destroy) { membership }
        it { is_expected.to eq true }
      end
      context 'and target self membership' do
        let(:membership_to_destroy) { creatorship }
        it { is_expected.to eq false }
      end
      context 'but is not a member' do
        let(:membership_to_destroy) { membership }
        let(:test_membership) { nil }
        it { is_expected.to eq true }
      end
    end

    context 'when member does not have permission' do
      let(:membership_to_destroy) { membership }

      context 'and is a member of board' do
        let(:test_membership) { creatorship }
        it { is_expected.to eq false }
      end
      context 'and is not a member of board' do
        let(:test_membership) { nil }
        it { is_expected.to eq false }
      end
    end
  end

  describe '#non_self_membership?' do
    subject do
      described_class.new(current_membership, membership: creatorship, user: creator)
                     .non_self_membership?
    end

    context 'user is not current membership owner' do
      let(:current_membership) { membership }
      it { is_expected.to be true }
    end
    context 'user is current membership owner' do
      let(:current_membership) { creatorship }
      it { is_expected.to be false }
    end
  end
end
