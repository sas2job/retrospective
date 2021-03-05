# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ActionItemsController do
  let_it_be(:board) { create(:board) }
  let_it_be(:action_item) { create(:action_item, board: board) }
  let_it_be(:user) { create(:user) }
  let_it_be(:closed_action_item) do
    create(:action_item, status: 'closed', board: board, author: user)
  end

  before { bypass_rescue }

  describe 'GET #index' do
    subject(:response) { get :index }

    context 'when user is not logged in' do
      it { is_expected.to have_http_status(:redirect) }
    end
  end

  describe 'PUT #close' do
    subject(:response) { put :close, params: params }
    let_it_be(:params) { { id: action_item.id } }
    let(:close_permission) { create(:permission, identifier: 'close_action_items') }

    context 'when user is not logged in' do
      it { is_expected.to have_http_status(:redirect) }
    end

    context 'when user is logged_in' do
      before { login_as user }

      context 'without permission' do
        it 'raises error ActionPolicy::Unauthorized' do
          expect { subject }.to raise_error(ActionPolicy::Unauthorized)
        end
      end

      context 'with permission' do
        before do
          create(:board_permissions_user, permission: close_permission, user: user, board: board)
        end

        it { is_expected.to have_http_status(:redirect) }
      end
    end
  end

  describe 'PUT #complete' do
    subject(:response) { put :complete, params: params }
    let_it_be(:params) { { id: action_item.id } }
    let(:complete_permission) { create(:permission, identifier: 'complete_action_items') }

    context 'when user is not logged in' do
      it { is_expected.to have_http_status(:redirect) }
    end

    context 'when user is logged_in' do
      before { login_as user }

      context 'without permission' do
        it 'raises error ActionPolicy::Unauthorized' do
          expect { subject }.to raise_error(ActionPolicy::Unauthorized)
        end
      end

      context 'with permission' do
        before do
          create(:board_permissions_user, permission: complete_permission, user: user, board: board)
        end

        it { is_expected.to have_http_status(:redirect) }
      end
    end
  end

  describe 'PUT #reopen' do
    subject(:response) { put :reopen, params: params }
    let_it_be(:params) { { id: closed_action_item.id } }
    let(:reopen_permission) { create(:permission, identifier: 'reopen_action_items') }

    context 'when user is not logged in' do
      it { is_expected.to have_http_status(:redirect) }
    end

    context 'when user is logged_in' do
      before { login_as user }

      context 'without permission' do
        it 'raises error ActionPolicy::Unauthorized' do
          expect { subject }.to raise_error(ActionPolicy::Unauthorized)
        end
      end

      context 'with permission' do
        before do
          create(:board_permissions_user, permission: reopen_permission, user: user, board: board)
        end

        it { is_expected.to have_http_status(:redirect) }
      end
    end
  end
end
