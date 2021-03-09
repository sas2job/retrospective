# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::UpdateCommentMutation, type: :request do
  describe '.resolve' do
    let(:user) { create(:user) }
    let(:comment) { create(:comment, author: user) }
    let_it_be(:update_permission) { create(:permission, identifier: 'update_comment') }
    let(:request) { post '/graphql', params: { query: query(id: comment.id, content: 'Updated') } }

    before do
      create(:comment_permissions_user, permission: update_permission,
                                        user: user, comment: comment)
    end

    before { sign_in user }

    it 'updates a comment' do
      request

      expect(comment.reload).to have_attributes(
        'author_id' => user.id,
        'content' => 'Updated'
      )
    end

    it 'returns a comment' do
      request
      json = JSON.parse(response.body)
      data = json.dig('data', 'updateComment', 'comment')

      expect(data).to include(
        'id' => comment.id,
        'content' => 'Updated',
        'author' => { 'id' => user.id.to_s }
      )
    end
  end

  def query(id:, content:)
    <<~GQL
      mutation {
        updateComment(
          input: {
            id: #{id}
            attributes: {
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
        }
      }
    GQL
  end
end
