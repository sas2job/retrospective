# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::LikeCardMutation, type: :request do
  describe '.resolve' do
    let(:author) { create(:user) }
    let(:card) { create(:card, author: author) }
    let(:non_author) { create(:user) }
    let(:request) { post '/graphql', params: { query: query(id: card.id) } }

    let_it_be(:like_permission) { create(:permission, identifier: 'like_card') }

    before do
      create(:card_permissions_user, permission: like_permission, user: author, card: card)
      create(:card_permissions_user, permission: like_permission, user: non_author, card: card)
    end

    context 'when logged as not card author' do
      before { sign_in non_author }

      it 'updates a card' do
        expect { request.to change { Card.likes }.by(1) }
      end

      it 'returns a card' do
        request

        json = JSON.parse(response.body)
        data = json.dig('data', 'likeCard', 'card')

        expect(data).to include(
          'id' => card.id,
          'body' => card.body,
          'author' => { 'id' => author.id.to_s },
          'likes' => card.likes + 1
        )
      end
    end
    context 'when logged as author' do
      before { sign_in author }

      it 'doesn\'t update a card' do
        expect { request.to not_change { Card.likes } }
      end
    end
  end

  def query(id:)
    <<~GQL
      mutation {
        likeCard(
          input: {
            id: #{id}
          }
        ) {
          card {
            id
            body
            likes
            author {
              id
            }
          }
        }
      }
    GQL
  end
end
