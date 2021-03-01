# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Card, type: :model do
  let_it_be(:author) { create(:user) }
  let_it_be(:not_an_author) { build_stubbed(:user) }
  let_it_be(:board) { create(:board) }
  let_it_be(:card) { build_stubbed(:card, board: board, author: author) }

  context 'validations' do
    it 'is valid with valid attributes' do
      expect(card).to be_valid
    end

    it 'is not valid without a body' do
      expect(build_stubbed(:card, body: nil)).to_not be_valid
    end

    it 'is not valid without a kind' do
      expect(build_stubbed(:card, kind: nil)).to_not be_valid
    end
  end

  context 'associations' do
    it 'belongs to author' do
      expect(card).to respond_to(:author)
    end

    it 'belongs to board' do
      expect(card).to respond_to(:board)
    end

    it 'has many card_permissions_users' do
      expect(card).to respond_to(:card_permissions_users)
    end
  end

  describe '#author?' do
    subject { card.author?(test_user) }

    context 'when user is the card author' do
      let(:test_user) { author }
      it { is_expected.to eq true }
    end

    context 'when user is not the card author' do
      let(:test_user) { not_an_author }
      it { is_expected.to eq false }
    end
  end
end
