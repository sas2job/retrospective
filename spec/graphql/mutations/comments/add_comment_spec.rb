# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::AddCommentMutation, type: :request do
  describe '.resolve' do
    let_it_be(:user) { create(:user) }
    let_it_be(:board) { create(:board) }
    let_it_be(:card) { create(:card, author: user, board: board) }
    let_it_be(:create_comments_permission) { create(:permission, identifier: 'create_comments') }

    let(:request) do
      post '/graphql', params: { query: query(card_id: card.id,
                                              content: 'Updated') }
    end

    before do
      create(:board_permissions_user, permission: create_comments_permission,
                                      user: user, board: board)
    end

    before { sign_in user }

    it 'adds a comment' do
      expect { request }.to change { Comment.count }.by 1
    end

    it 'returns a comment' do
      request

      json = JSON.parse(response.body)
      data = json.dig('data', 'addComment', 'comment')

      expect(data).to include(
        'id' => be_present,
        'content' => 'Updated',
        'author' => { 'id' => user.id.to_s }
      )
    end
  end

  def query(card_id:, content:)
    <<~GQL
      mutation {
        addComment(
          input: {
            attributes: {
              cardId: "#{card_id}"
              content: "#{content}"
            }
          }
        ) {
          comment {
            id
            content
            author {
              id
            }
          }
          errors
          {
            fullMessages
          }
        }
      }
    GQL
  end
end
