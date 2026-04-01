# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Walks', type: :request do
  let(:user) { FactoryBot.create(:user) }

  before do
    sign_in user
  end

  describe 'POST /walks' do
    subject(:create_walk) { post walks_path, params: walk_params }

    let(:walk_params) do
      {
        walk: { clockwise: true },
        arrival: { station_id: 1 }
      }
    end

    it '歩行記録が作成される' do
      expect { create_walk }.to change(Walk, :count).by(1)
      expect(response).to redirect_to walk_path(Walk.last)
      follow_redirect!
      expect(flash[:notice]).to eq('歩行記録ノートを作成しました。')
    end

    context '既に歩行記録が存在する場合' do
      let!(:existing_walk) { FactoryBot.create(:walk, :with_arrivals, user:, clockwise: true) }

      it '既存の歩行記録ページにリダイレクトされる' do
        create_walk
        expect(response).to redirect_to walk_path(existing_walk)
        expect(flash[:alert]).to eq('ユーザ一人につき、実施中の歩行記録は一つしか作成できません')
      end
    end
  end

  describe 'GET /walks/:id' do
    subject(:show_walk) { get walk_path(walk) }

    let!(:walk) { FactoryBot.create(:walk, :with_arrivals, user:, clockwise: true) }

    it { is_expected.to eq(200) }

    it '歩行の情報が表示される' do
      show_walk
      expect(response.body).to include("0駅(残り#{Station.cache_count}駅)")
      expect(response.body).to include("約0km(残り約#{Station.total_distance}km)")
    end
  end

  describe 'PATCH /walks/:id' do
    let!(:walk) { FactoryBot.create(:walk, :with_arrivals, user:, clockwise: true) }

    context '公開にする場合' do
      subject(:publish_walk) { patch walk_path(walk), params: { walk: { publish: true } } }

      it '到着履歴を公開できる' do
        publish_walk
        expect(response).to redirect_to arrivals_path
        follow_redirect!
        expect(flash[:notice]).to eq('到着履歴を公開しました。URLで到着履歴を共有しましょう。')
      end
    end

    context '非公開にする場合' do
      subject(:unpublish_walk) { patch walk_path(walk), params: { walk: { publish: false } } }

      it '到着履歴を非公開にできる' do
        unpublish_walk
        expect(response).to redirect_to arrivals_path
        follow_redirect!
        expect(flash[:notice]).to eq('到着履歴を非公開にしました。')
      end
    end
  end
end
