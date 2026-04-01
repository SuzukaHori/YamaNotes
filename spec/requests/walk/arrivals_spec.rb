# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Walk::Arrivals', type: :request do
  describe 'GET /walks/:walk_id/arrivals' do
    subject(:get_walk_arrivals) { get walk_arrivals_path(walk) }

    context '自分の歩行記録の場合' do
      let!(:login_user) { FactoryBot.create(:user) }
      let!(:walk) { FactoryBot.create(:walk, :with_arrivals, user: login_user) }

      before { sign_in login_user }

      it '200が返ること' do
        get_walk_arrivals
        expect(response).to have_http_status(:ok)
      end
    end

    context '他のユーザーの歩行記録の場合' do
      let!(:login_user) { FactoryBot.create(:user) }
      let!(:walk) { FactoryBot.create(:walk, :with_arrivals) }

      before { sign_in login_user }

      it '公開ページにリダイレクトされること' do
        get_walk_arrivals
        expect(response).to redirect_to(public_walk_arrivals_url(walk))
      end
    end

    context 'ログインしていない場合' do
      let!(:walk) { FactoryBot.create(:walk, :with_arrivals) }

      it '公開ページにリダイレクトされること' do
        get_walk_arrivals
        expect(response).to redirect_to(public_walk_arrivals_url(walk))
      end
    end

    context '存在しない歩行記録の場合' do
      let!(:walk) { FactoryBot.build_stubbed(:walk, id: 0) }

      it '404が返ること' do
        get_walk_arrivals
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
