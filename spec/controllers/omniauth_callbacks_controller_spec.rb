# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples :omniauth_callback do |provider|
  let!(:auth_hash) { build(:"#{provider}_auth_hash") }

  before do
    OmniAuth.config.test_mode = true

    request.env['devise.mapping'] = Devise.mappings[:user]
    request.env['omniauth.auth'] = auth_hash
    session['user_return_to'] = '/wherever' # sign_in_and_redirect @user

    allow_any_instance_of(AvatarUploader).to receive(:download!) # remote_avatar_url
  end

  context 'when provider sent invalid oauth data for user authentication' do
    it 'redirects to root path' do
      auth_hash.info.email = nil

      expect { get provider }.to_not change { User.count }
      expect(response).to redirect_to new_user_session_path
    end
  end

  context 'when provider sent valid oauth data' do
    context 'when user is not in the database' do
      it 'creates new user and redirects' do
        expect { get provider }.to change { User.count }.by(1)
        expect(response).to redirect_to('/wherever')
      end
    end

    context 'when user is in the database' do
      it 'logs in existing user and redirects' do
        create(:user, provider: auth_hash.provider, uid: auth_hash.uid)

        expect { get provider }.to_not change { User.count }
        expect(response).to redirect_to('/wherever')
      end
    end
  end
end

RSpec.describe Users::OmniauthCallbacksController do
  describe '/alfred' do
    it_behaves_like :omniauth_callback, :alfred
  end

  describe '/google' do
    it_behaves_like :omniauth_callback, :google
  end

  describe '/facebook' do
    it_behaves_like :omniauth_callback, :facebook
  end
end
