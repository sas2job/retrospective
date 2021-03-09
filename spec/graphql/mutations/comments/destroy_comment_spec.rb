# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::DestroyCommentMutation, type: :request do
  describe '.resolve' do
    let(:user) { create(:user) }
    let(:comment) { create(:comment, author: user) }
    let_it_be(:destroy_permission) { create(:permission, identifier: 'destroy_comment') }
    let(:request) { post '/graphql', params: { query: query(id: comment.id) } }

    before do
      create(:comment_permissions_user, permission: destroy_permission,
                                        user: user, comment: comment)
    end
    before { sign_in user }

    it 'deletes a comment' do
      expect { request }.to change { Comment.count }.by(-1)
    end

    it 'returns a comment' do
      request

      json = JSON.parse(response.body)
      data = json.dig('data', 'destroyComment')

      expect(data).to include(
        'id' => comment.id
      )
    end
  end

  def query(id:)
    <<~GQL
      mutation {
        destroyComment(
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
