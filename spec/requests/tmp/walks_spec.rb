# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tmp::Walks', type: :request do
  describe 'GET /walk' do
    subject(:get_tmp_walk) { get '/walk' }

    let!(:user) { FactoryBot.create(:user) }
    let!(:walk) { FactoryBot.create(:walk, :with_arrivals, user:) }

    before { sign_in user }

    it '現在の歩行記録にリダイレクトされる' do
      get_tmp_walk
      expect(response).to redirect_to(walk_path(walk))
    end
  end
end
