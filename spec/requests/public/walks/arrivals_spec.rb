# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Public::Walks::Arrivals', type: :request do
  describe 'GET /public/walks/:walk_id/arrivals' do
    subject(:get_public_walk_arrivals) { get public_walk_arrivals_path(walk) }

    context '公開されている歩行記録の場合' do
      let!(:walk) { FactoryBot.create(:walk, publish: true) }

      it '200が返る' do
        get_public_walk_arrivals
        expect(response).to have_http_status(:ok)
      end
    end

    context '非公開の歩行記録の場合' do
      let!(:walk) { FactoryBot.create(:walk, publish: false) }

      it 'rootにリダイレクトされる' do
        get_public_walk_arrivals
        expect(response).to redirect_to(root_path)
      end
    end

    context '存在しない歩行記録の場合' do
      let(:walk) { instance_double('Walk', to_param: '0') }

      it '404が返る' do
        get_public_walk_arrivals
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
