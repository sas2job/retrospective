# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Boards::Cards::BuildPermissions do
  subject(:build_permissions) do
    described_class.new(card, user).call(identifiers_scope: identifiers_scope)
  end

  let(:user) { create(:user) }
  let(:card) { create(:card) }
  let!(:permission) { create(:permission, identifier: 'update_card') }

  context 'with valid identifiers scope' do
    let(:identifiers_scope) { 'card' }

    it { is_expected.to be_success }

    it 'builds permission to card' do
      build_permissions
      expect(card.card_permissions_users.first.permission).to eq(permission)
    end

    it 'builds permission to user' do
      build_permissions
      expect(card.card_permissions_users.first.user).to eq(user)
    end
  end

  context 'with invalid identifiers scope' do
    let(:identifiers_scope) { 'invalid' }

    it { is_expected.to be_failure }

    it 'does not build permissions_users' do
      build_permissions
      expect(card.card_permissions_users).to be_empty
    end
  end
end
