# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Boards::Cards::Create do
  subject { described_class.new(user).call(card_params) }
  let_it_be(:user) { create(:user) }
  let_it_be(:board) { create(:board) }
  let_it_be(:permission) { create(:permission, identifier: 'update_card') }
  let(:card_params) { attributes_for(:card).merge(board: board, author: user) }

  it 'creates a card' do
    expect { subject }.to change { board.cards.count }.by(1)
  end

  it 'adds permission to user' do
    expect { subject }.to change(user.card_permissions, :count).by(1)
  end

  it 'returns a card' do
    expect(subject.value!).to eq Card.find_by(author: user)
  end
end
