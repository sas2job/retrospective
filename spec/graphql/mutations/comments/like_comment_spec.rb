# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::LikeCommentMutation, type: :request do
  describe '.resolve' do
    let(:author) { create(:user) }
    let(:card) { create(:card, author: author) }
    let!(:comment) { create(:comment, author: author, card: card) }
    let(:non_author) { create(:user) }
    let(:request) { post '/graphql', params: { query: query(id: comment.id) } }

    context 'when logged as not comment author' do
      before { sign_in non_author }
      it 'updates a comment' do
        expect { request.to change { comment.likes }.by(1) }
      end

      it 'returns a comment' do
        request

        json = JSON.parse(response.body)
        data = json.dig('data', 'likeComment', 'comment')

        expect(data).to include(
          'id' => comment.id,
          'content' => comment.content,
          'author' => { 'id' => author.id.to_s },
          'likes' => comment.likes + 1
        )
      end
    end

    context 'when logged as author' do
      before { sign_in author }

      it 'doesn\'t update a comment' do
        expect { request }.not_to change { comment.likes }
      end
    end
  end

  def query(id:)
    <<~GQL
      mutation {
        likeComment(
          input: {
            id: #{id}
          }
        ) {
          comment {
            id
            content
            author {
              id
            }
            likes
          }
        }
      }
    GQL
  end
end
