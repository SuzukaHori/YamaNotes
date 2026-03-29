# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'HighVoltage::Pages', type: :request do
  describe 'GET /' do
    it '未ログインでもトップページが表示される' do
      get root_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('トップページ')
    end
  end

  describe 'GET /pages/terms' do
    it '未ログインでも利用規約ページが表示される' do
      get page_path('terms')

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('利用規約')
    end
  end

  describe 'GET /pages/privacy' do
    it '未ログインでもプライバシーポリシーページが表示される' do
      get page_path('privacy')

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('プライバシーポリシー')
    end
  end
end
