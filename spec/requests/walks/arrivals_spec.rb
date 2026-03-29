# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Walks::Arrivals', type: :request do
  let(:user) { FactoryBot.create(:user) }

  describe 'GET /walks/:walk_id/arrivals' do
    subject(:show_arrivals) { get walk_arrivals_path(walk) }

    before { sign_in user }

    context '自分の歩行記録の場合' do
      let!(:walk) { FactoryBot.create(:walk, :with_arrivals, user:, clockwise: true) }

      it { is_expected.to eq(200) }

      it '到着履歴が表示される' do
        show_arrivals
        expect(response.body).to include('到着履歴')
      end
    end

    context '他のユーザーの歩行記録の場合' do
      let(:other_user) { FactoryBot.create(:user) }
      let!(:walk) { FactoryBot.create(:walk, :with_arrivals, user: other_user, clockwise: true) }

      it { is_expected.to eq(404) }
    end
  end

  describe 'GET /public/walks/:walk_id/arrivals' do
    subject(:get_walk_arrivals) { get public_walk_arrivals_path(walk) }

    context '公開状態の歩行記録の場合' do
      let!(:walk) { FactoryBot.create(:walk, :with_arrivals, user:, publish: true) }

      it { is_expected.to eq(200) }
    end

    context '非公開状態の歩行記録の場合' do
      let!(:walk) { FactoryBot.create(:walk, :with_arrivals, user:, publish: false) }

      it 'トップページにリダイレクトされる' do
        get_walk_arrivals
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(flash[:notice]).to eq('この到着記録は非公開です')
      end
    end
  end
end
