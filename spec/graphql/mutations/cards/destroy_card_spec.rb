# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::DestroyCardMutation, type: :request do
  describe '#resolve' do
    let!(:author) { create(:user) }
    let!(:creator) { create(:user) }
    let!(:board) { create(:board) }
    let!(:card) { create(:card, author: author, board: board) }

    let_it_be(:destroy_any_card) { create(:permission, identifier: 'destroy_any_card') }
    let_it_be(:destroy_card) { create(:permission, identifier: 'destroy_card') }

    before do
      create(:board_permissions_user, permission: destroy_any_card, user: creator, board: board)
      create(:card_permissions_user, permission: destroy_card, user: author, card: card)
    end

    let(:request) { post '/graphql', params: { query: query(id: card.id) } }

    context 'when author of the card' do
      before { sign_in author }

      it 'removes card' do
        expect { request }.to change { Card.count }.by(-1)
      end

      it 'returns a card' do
        request

        json = JSON.parse(response.body)
        data = json.dig('data', 'destroyCard')

        expect(data).to include('id' => card.id)
      end
    end

    context 'when creator of the board' do
      before { sign_in creator }

      it 'removes card' do
        expect { request }.to change { Card.count }.by(-1)
      end

      it 'returns a card' do
        request

        json = JSON.parse(response.body)
        data = json.dig('data', 'destroyCard')

        expect(data).to include('id' => card.id)
      end
    end
  end

  def query(id:)
    <<~GQL
      mutation {
        destroyCard(
          input: {
            id: #{id}
          }
        ) {
          id
        }
      }
    GQL
  end
end
