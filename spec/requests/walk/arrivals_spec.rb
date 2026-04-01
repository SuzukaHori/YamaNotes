# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Walk::Arrivals', type: :request do
  describe 'GET /walks/:walk_id/arrivals' do
    subject(:get_walk_arrivals) { get walk_arrivals_path(walk) }

    context 'ログインしている場合' do
      let!(:login_user) { FactoryBot.create(:user) }

      before { sign_in login_user }

      context '自分の歩行記録の場合' do
        let!(:walk) { FactoryBot.create(:walk, :with_arrivals, user: login_user) }

        it '200が返ること' do
          get_walk_arrivals
          expect(response).to have_http_status(:ok)
        end
      end

      context '他のユーザーの歩行記録の場合' do
        let!(:walk) { FactoryBot.create(:walk, :with_arrivals) }

        it '404が返ること' do
          get_walk_arrivals
          expect(response).to have_http_status(:not_found)
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

    context 'ログインしていない場合' do
      let!(:walk) { FactoryBot.create(:walk, :with_arrivals) }

      it 'ログインページにリダイレクトされること' do
        get_walk_arrivals
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('ログインもしくはアカウント登録してください。')
      end
    end
  end
end
