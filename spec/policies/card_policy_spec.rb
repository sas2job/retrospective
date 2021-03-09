# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CardPolicy do
  let_it_be(:user) { create(:user) }
  let_it_be(:board) { create(:board) }
  let_it_be(:card) { create(:card, board: board) }
  let(:policy) { described_class.new(card, user: user) }

  describe '#destroy?' do
    subject { policy.apply(:destroy?) }

    context 'with permission' do
      context 'as a creator of board' do
        let(:test_permission) { create(:permission, identifier: 'destroy_any_card') }
        before do
          create(:board_permissions_user, board: board,
                                          user: user,
                                          permission: test_permission)
        end

        it { is_expected.to eq true }
      end

      context 'as an author of card' do
        let(:test_permission) { create(:permission, identifier: 'destroy_card') }
        before do
          create(:card_permissions_user, card: card,
                                         user: user,
                                         permission: test_permission)
        end

        it { is_expected.to eq true }
      end
    end

    context 'without permission' do
      it { is_expected.to eq false }
    end
  end

  describe '#update?' do
    subject { policy.apply(:update?) }

    context 'with permission' do
      let_it_be(:update_card_permission) { create(:permission, identifier: 'update_card') }
      before do
        create(:card_permissions_user, card: card,
                                       user: user,
                                       permission: update_card_permission)
      end

      it { is_expected.to eq true }
    end

    context 'without permission' do
      it { is_expected.to eq false }
    end
  end

  describe '#like?' do
    subject { policy.apply(:like?) }

    context 'with permission' do
      let_it_be(:like_card_permission) { create(:permission, identifier: 'like_card') }

      context 'as an author of card' do
        let(:card_with_author) { create(:card, author: user) }
        let(:policy) { described_class.new(card_with_author, user: user) }
        before do
          create(:card_permissions_user, card: card_with_author,
                                         user: user,
                                         permission: like_card_permission)
        end
        it { is_expected.to eq false }
      end

      context 'not author of card' do
        before do
          create(:card_permissions_user, card: card,
                                         user: user,
                                         permission: like_card_permission)
        end

        it { is_expected.to eq true }
      end
    end

    context 'without permission' do
      it { is_expected.to eq false }
    end
  end
end
