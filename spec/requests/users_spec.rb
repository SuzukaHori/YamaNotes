# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:user) { FactoryBot.create(:user) }

  before do
    sign_in user
  end

  describe 'DELETE /users/:id' do
    subject(:destroy_user) { delete user_path(user) }

    it 'ユーザーが削除される' do
      expect { destroy_user }.to change(User, :count).by(-1)
    end

    it 'ルートにリダイレクトされる' do
      destroy_user
      expect(response).to redirect_to(root_url)
      follow_redirect!
      expect(flash[:notice]).to eq('退会しました。')
    end
  end
end
