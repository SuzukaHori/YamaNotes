require 'rails_helper'

RSpec.describe 'Users', type: :system do
  before do
    OmniAuth.config.test_mode = true
    Rails.application.env_config['devise.mapping'] = Devise.mappings[:user]
    Rails.application.env_config['omniauth.auth'] = google_oauth2_mock
  end

  scenario 'user signs in' do
    visit root_path
    click_on 'Googleでログイン'
    expect(page).to have_content('Successfully authenticated from Google account.')
  end

  scenario 'user signs out' do
    user = FactoryBot.create(:user)
    sign_in user
    visit root_path
    click_on 'ログアウト'
    expect(page).to have_content('Signed out successfully.')
  end

  after do
    OmniAuth.config.test_mode = false
  end

  private

  def google_oauth2_mock
    OmniAuth::AuthHash.new({ provider: 'google_oauth2', uid: 123_456 })
  end
end
