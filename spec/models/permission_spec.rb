# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Permission, type: :model do
  let_it_be(:permission) { create(:permission) }

  context 'validations' do
    it 'is valid with valid attributes' do
      expect(permission).to be_valid
    end

    it 'is not valid without description' do
      expect(build_stubbed(:permission, description: nil)).to_not be_valid
    end

    it 'is not valid without identifier' do
      expect(build_stubbed(:permission, identifier: nil)).to_not be_valid
    end

    it 'is not valid without uniq identifier' do
      create(:permission, identifier: 'some_identifier')

      expect(build_stubbed(:permission, identifier: 'some_identifier')).to be_invalid
    end
  end

  context 'associations' do
    it 'has_many_board_users' do
      expect(permission).to respond_to(:board_users)
    end

    it 'has_many_card_users' do
      expect(permission).to respond_to(:card_users)
    end

    it 'has_many_comment_users' do
      expect(permission).to respond_to(:comment_users)
    end

    it 'has_many_board_permissions_users' do
      expect(permission).to respond_to(:board_permissions_users)
    end

    it 'has_many_card_permissions_users' do
      expect(permission).to respond_to(:card_permissions_users)
    end

    it 'has_many_comment_permissions_users' do
      expect(permission).to respond_to(:comment_permissions_users)
    end
  end

  context '.creator_permissions' do
    let_it_be(:creator_permission) { create(:permission, identifier: 'update_board') }

    it 'returns permissions with creator identifiers' do
      expect(Permission.creator_permissions).to include(creator_permission)
    end

    it 'excludes permissions without creator identifiers' do
      expect(Permission.creator_permissions).not_to include(permission)
    end
  end

  context '.member_permissions' do
    let_it_be(:member_permission) { create(:permission, identifier: 'create_cards') }

    it 'returns permissions with member identifiers' do
      expect(Permission.member_permissions).to include(member_permission)
    end

    it 'excludes permissions without member identifiers' do
      expect(Permission.member_permissions).not_to include(permission)
    end
  end

  context '.card_permissions' do
    let_it_be(:card_permission) { create(:permission, identifier: 'update_card') }

    it 'returns permissions with card identifiers' do
      expect(Permission.card_permissions).to include(card_permission)
    end

    it 'excludes permissions without card identifiers' do
      expect(Permission.card_permissions).not_to include(permission)
    end
  end
end
