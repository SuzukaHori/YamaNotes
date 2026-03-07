# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tmp::Arrivals', type: :request do
  describe 'GET /users/:user_id/arrivals' do
    subject(:get_tmp_arrivals) { get user_arrivals_path(user) }

    let!(:user) { FactoryBot.create(:user) }
    let!(:walk) { FactoryBot.create(:walk, :with_arrivals, user:) }

    it '歩行記録の到着一覧にリダイレクトされる' do
      get_tmp_arrivals
      expect(response).to redirect_to(public_walk_arrivals_url(walk))
    end
  end
end
