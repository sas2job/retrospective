# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::ToggleReadyStatusMutation, type: :request do
  describe '.resolve' do
    let_it_be(:author) { create(:user) }
    let_it_be(:board) { create(:board) }
    let_it_be(:creatorship) do
      create(:membership, board: board, user: author, role: 'creator')
    end
    let_it_be(:permission) { create(:permission, identifier: 'toggle_ready_status') }
    let(:request) { post '/graphql', params: { query: query(id: creatorship.id) } }

    before { sign_in author }

    context 'with permission' do
      before do
        create(:board_permissions_user, permission: permission, board: board, user: author)
      end

      it 'toggles membership status' do
        request

        expect(creatorship.reload).to have_attributes(
          'ready' => true
        )
      end

      it 'returns a membership' do
        request

        json = JSON.parse(response.body)
        data = json.dig('data', 'toggleReadyStatus', 'membership')

        expect(data).to include(
          'id' => creatorship.id,
          'ready' => true,
          'user' => { 'id' => creatorship.user_id.to_s },
          'board' => { 'id' => creatorship.board_id.to_s }
        )
      end
    end

    context 'without permission' do
      it 'does not toggle status' do
        request

        expect(creatorship.reload).to have_attributes('ready' => false)
      end

      it 'returns unauthorized error' do
        request
        json = JSON.parse(response.body)
        message = json['errors'].first['message']

        expect(message).to eq('You are not authorized to perform this action')
      end
    end
  end

  def query(id:)
    <<~GQL
      mutation {
        toggleReadyStatus(
          input: {
            id: #{id}
          }
        ) {
          membership {
            id
            ready
            user {
              id
            }
            board {
              id
            }
          }
        }
      }
    GQL
  end
end
