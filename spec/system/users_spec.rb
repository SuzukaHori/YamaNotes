# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :system do
  let(:user) { FactoryBot.create(:user) }

  before do
    OmniAuth.config.test_mode = true
    Rails.application.env_config['devise.mapping'] = Devise.mappings[:user]
    OmniAuth.config.mock_auth[:google_oauth2] = google_oauth2_mock
  end

  after do
    OmniAuth.config.test_mode = false
  end

  it 'ログインする' do
    visit root_path
    click_on 'Googleでログイン', match: :first
    expect(page).to have_content('Google アカウントでログインしました')
  end

  context 'ログイン済みの場合 / 歩行データが存在しない時' do
    it 'アラートが出ること / リダイレクトされること' do
      visit root_path
      sign_in user
      click_on 'Googleでログイン', match: :first
      expect(page).to have_title '一周の設定'
    end
  end

  context 'ログイン済みの場合 / 歩行データが存在する時' do
    let!(:walk) { FactoryBot.create(:walk, user: user) }
    let!(:arrival) { FactoryBot.create(:arrival, walk:, station_id: 1) }

    it 'アラートが出ること / リダイレクトされること' do
      visit root_path
      sign_in user
      click_on 'Googleでログイン', match: :first
      expect(page).to have_content('すでにログインしています。')
      expect(page).to have_title 'ダッシュボード'
    end
  end

  it 'ログアウトする' do
    sign_in user
    start_walk
    click_on 'menu_button'
    click_on 'ログアウト'
    expect(page).to have_content('ログアウトしました。')
  end

  it '退会する' do
    sign_in user
    visit new_walk_path
    click_on 'menu_button'
    expect do
      page.accept_confirm { click_on '退会する' }
      expect(page).to have_content('退会しました')
    end.to change(User, :count).by(-1)
  end

  private

  def google_oauth2_mock
    OmniAuth::AuthHash.new({ provider: 'google_oauth2', uid: 123_456 })
  end
end
