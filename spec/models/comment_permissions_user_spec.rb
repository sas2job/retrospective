# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommentPermissionsUser, type: :model do
  let_it_be(:comment_permissions_user) { create(:comment_permissions_user) }
  let_it_be(:user) { build_stubbed(:user) }
  let_it_be(:comment) { build_stubbed(:comment) }
  let_it_be(:permission) { build_stubbed(:permission) }

  context 'associations' do
    it 'belongs to user' do
      expect(comment_permissions_user).to respond_to(:user)
    end

    it 'belongs to permission' do
      expect(comment_permissions_user).to respond_to(:permission)
    end

    it 'belongs to comment' do
      expect(comment_permissions_user).to respond_to(:comment)
    end
  end

  context 'validations' do
    before do
      create(:comment_permissions_user, permission: permission, user: user, comment: comment)
    end

    let(:with_uniq_comment) do
      build_stubbed(:comment_permissions_user, user: user, permission: permission)
    end
    let(:with_uniq_user) do
      create(:comment_permissions_user, permission: permission, comment: comment)
    end
    let(:with_uniq_permission) do
      build_stubbed(:comment_permissions_user, user: user, comment: comment)
    end
    let(:not_uniq_permissions_user) do
      build_stubbed(:comment_permissions_user, user: user,
                                               comment: comment,
                                               permission: permission)
    end

    it 'is valid when card is uniq' do
      expect(with_uniq_comment).to be_valid
    end

    it 'is valid when user is uniq' do
      expect(with_uniq_user).to be_valid
    end

    it 'is valid when permission is uniq' do
      expect(with_uniq_permission).to be_valid
    end

    it 'is not valid when neither of user card or permission is uniq' do
      expect(not_uniq_permissions_user).to be_invalid
    end
  end
end
