# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Walks::Arrivals', type: :request do
  let(:user) { FactoryBot.create(:user) }

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
