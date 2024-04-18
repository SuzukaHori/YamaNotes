require 'rails_helper'

RSpec.describe 'Menu', type: :system do
  before do
    @user = FactoryBot.create(:user)
    sign_in @user
    start_walk
  end

  scenario 'メニューバーから到着ページにアクセスする' do
    visit walk_path
    click_on 'menu_button'
    click_on '到着一覧'
    expect(page).to have_content('到着履歴')
    click_on 'menu_button'
    click_on 'ダッシュボード'
    expect(page).to have_content('現在の駅')
  end
end
