require 'rails_helper'

RSpec.describe 'Users', type: :system do
  let(:user) { FactoryBot.create(:user) }

  before do
    OmniAuth.config.test_mode = true
    Rails.application.env_config['devise.mapping'] = Devise.mappings[:user]
    OmniAuth.config.mock_auth[:google_oauth2] = google_oauth2_mock
  end

  it 'ログインする' do
    visit root_path
    click_on 'Googleでログイン', match: :first
    expect(page).to have_content('Google アカウントによる認証に成功しました。')
  end

  it 'ログアウトする' do
    sign_in user
    start_walk
    click_on 'menu_button'
    click_on 'ログアウト'
    expect(page).to have_content('ログアウトしました。')
  end

  after do
    OmniAuth.config.test_mode = false
  end

  private

  def google_oauth2_mock
    OmniAuth::AuthHash.new({ provider: 'google_oauth2', uid: 123_456 })
  end
end
