# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::DestroyActionItemMutation, type: :request do
  describe '#resolve' do
    let!(:board) { create(:board) }
    let!(:action_item) { create(:action_item, board: board) }
    let(:user) { create(:user) }
    let(:destroy_permission) { create(:permission, identifier: 'destroy_action_items') }
    let(:request) { post '/graphql', params: { query: query(id: action_item.id) } }

    before { sign_in user }

    context 'with permission' do
      before do
        create(:board_permissions_user, permission: destroy_permission, user: user, board: board)
      end

      it 'removes action item' do
        expect { request }.to change { ActionItem.count }.by(-1)
      end

      it 'returns a action item' do
        request

        json = JSON.parse(response.body)
        data = json.dig('data', 'destroyActionItem')

        expect(data).to include(
          'id' => action_item.id
        )
      end
    end

    context 'without permission' do
      it 'does not destroy an action item' do
        expect { request }.to_not change { ActionItem.count }
      end
    end
  end

  def query(id:)
    <<~GQL
      mutation {
        destroyActionItem(
          input: {
            id: #{id}
          }
        ) {
          id
          errors {
            fullMessages
          }
        }
      }
    GQL
  end
end
