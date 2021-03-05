# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::AddActionItemMutation, type: :request do
  describe '.resolve' do
    let_it_be(:user) { create(:user) }
    let_it_be(:board) { create(:board) }
    let(:create_permission) { create(:permission, identifier: 'create_action_items') }
    let(:request) { post '/graphql', params: { query: query(board_slug: board.slug) } }

    before { sign_in user }

    context 'with permission' do
      before do
        create(:board_permissions_user, permission: create_permission, user: user, board: board)
      end

      it 'creates an action item' do
        expect { request }.to change { ActionItem.count }.by(1)
      end

      it 'returns an action item' do
        request
        json = JSON.parse(response.body)
        data = json.dig('data', 'addActionItem', 'actionItem')

        expect(data).to include(
          'id' => be_present,
          'body' => 'Some text',
          'author' => { 'id' => user.id.to_s }
        )
      end
    end

    context 'without permission' do
      it 'does not create an action item' do
        expect { request }.to_not change { ActionItem.count }
      end
    end
  end

  def query(board_slug:)
    <<~GQL
      mutation {
        addActionItem(
          input: {
            attributes: {
              boardSlug: "#{board_slug}"
              body: "Some text"
            }
          }
        ) {
          actionItem {
            id
            body
            times_moved
            author {
              id
            }
          }
        }
      }
    GQL
  end
end
