# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Boards::Cards::Comments::Create do
  subject { described_class.new(user).call(comment_params) }
  let_it_be(:user) { create(:user) }
  let_it_be(:card) { create(:card) }
  let_it_be(:permission) { create(:permission, identifier: 'update_comment') }
  let(:comment_params) { attributes_for(:comment).merge(author: user, card: card) }

  it 'creates a comment' do
    expect { subject }.to change { card.comments.count }.by(1)
  end

  it 'adds permission to user' do
    expect { subject }.to change(user.comment_permissions, :count).by(1)
  end

  it 'returns a comment' do
    expect(subject.value!).to eq Comment.find_by(author: user)
  end
end
