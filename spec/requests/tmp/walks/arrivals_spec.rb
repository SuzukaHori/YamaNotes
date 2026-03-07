# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tmp::Walks::Arrivals', type: :request do
  describe 'GET /walks/:walk_id/arrivals' do
    subject(:get_tmp_walk_arrivals) { get walk_arrivals_path(walk) }

    context '公開されている歩行記録の場合' do
      let!(:walk) { FactoryBot.create(:walk, publish: true) }

      it '公開用の到着一覧にリダイレクトされる' do
        get_tmp_walk_arrivals
        expect(response).to redirect_to(public_walk_arrivals_url(walk))
      end
    end

    context '非公開の歩行記録の場合' do
      let!(:walk) { FactoryBot.create(:walk, publish: false) }

      it '404が返る' do
        get_tmp_walk_arrivals
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
