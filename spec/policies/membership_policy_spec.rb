# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MembershipPolicy do
  let_it_be(:creator) { create(:user) }
  let_it_be(:not_member) { create(:user) }
  let_it_be(:board) { create(:board) }
  let_it_be(:creatorship) { create(:membership, user: creator, board: board) }
  let(:policy) { described_class.new(creatorship, membership: test_membership, user: test_user) }
  let(:test_user) { creator }
  let(:test_membership) { creatorship }

  describe '#ready_toggle?' do
    let_it_be(:toggle_permission) { create(:permission, identifier: 'toggle_ready_status') }
    subject { policy.apply(:ready_toggle?) }

    context 'with perrmission' do
      before do
        create(:permissions_user, permission: toggle_permission, user: test_user, board: board)
      end

      context 'as a member of board' do
        it { is_expected.to eq true }
      end
      context 'as not a member of board' do
        let(:test_user) { not_member }
        let(:test_membership) { nil }
        it { is_expected.to eq true }
      end
    end

    context 'without permission' do
      context 'as a member of board' do
        it { is_expected.to eq false }
      end
      context 'as not a member of board' do
        let(:test_user) { not_member }
        let(:test_membership) { nil }
        it { is_expected.to eq false }
      end
    end
  end

  describe '#destroy?' do
    let_it_be(:member) { create(:user) }
    let_it_be(:membership) { create(:membership, user: member, board: board) }
    let_it_be(:destroy_permission) { create(:permission, identifier: 'destroy_membership') }
    let(:policy) do
      described_class.new(membership_to_destroy, membership: test_membership, user: test_user)
    end
    let(:membership_to_destroy) { membership }
    subject { policy.apply(:destroy?) }

    context 'with permission' do
      before do
        create(:permissions_user, permission: destroy_permission, user: test_user, board: board)
      end

      context 'targets another membership' do
        it { is_expected.to eq true }
      end
      context 'targets self membership' do
        let(:membership_to_destroy) { creatorship }
        it { is_expected.to eq false }
      end
      context 'as not a member' do
        let(:test_user) { not_member }
        let(:test_membership) { nil }
        it { is_expected.to eq true }
      end
    end

    context 'without permission' do
      context 'as a member of board' do
        it { is_expected.to eq false }
      end
      context 'as not a member of board' do
        let(:test_membership) { nil }
        let(:test_user) { not_member }
        it { is_expected.to eq false }
      end
    end
  end
end
