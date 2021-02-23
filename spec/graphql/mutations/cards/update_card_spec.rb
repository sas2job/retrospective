# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::UpdateCardMutation, type: :request do
  describe '.resolve' do
    let(:author) { create(:user) }
    let(:card) { create(:card, author: author) }
    let(:request) { post '/graphql', params: { query: query(id: card.id, body: 'New body') } }
    let_it_be(:update_permission) { create(:permission, identifier: 'update_card') }

    before do
      create(:card_permissions_user, permission: update_permission, user: author, card: card)
    end
    before { sign_in author }

    it 'updates a card' do
      request

      expect(card.reload).to have_attributes(
        'author_id' => author.id,
        'body' => 'New body'
      )
    end

    it 'returns a card' do
      request

      json = JSON.parse(response.body)
      data = json.dig('data', 'updateCard', 'card')

      expect(data).to include(
        'id' => card.id,
        'body' => 'New body',
        'author' => { 'id' => author.id.to_s }
      )
    end
  end

  def query(id:, body:)
    <<~GQL
      mutation {
        updateCard(
          input: {
            id: #{id}
            attributes: {
              body: "#{body}"
            }
          }
        ) {
          card {
            id
            body
            author {
              id
            }
          }
        }
      }
    GQL
  end
end
