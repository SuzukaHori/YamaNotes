require 'rails_helper'

RSpec.describe 'Menu', type: :system do
  before do
    user = FactoryBot.create(:user)
    sign_in user
    start_walk
  end

  it 'メニューバーから到着ページにアクセスする' do
    visit walk_path
    click_on 'menu_button'
    click_on '到着一覧'
    expect(page).to have_content('到着履歴')
    click_on 'menu_button'
    click_on 'ダッシュボード'
    expect(page).to have_content('現在の駅')
  end

  it 'ヘッダーのアイコンからヘルプページにアクセスする' do
    visit walk_path
    click_on 'help_button'
    expect(page).to have_css 'h2', text: '使い方'
  end

  it 'ヘッダーのロゴからトップページにアクセスする' do
    visit walk_path
    find('img[alt="YamaNotesのロゴ"]').click
    expect(page).to have_content('山手線一周に徒歩で挑戦する人のための記録アプリ')
  end

  it 'フッターから利用規約にアクセスする' do
    visit root_path
    within 'ul' do
      click_on '利用規約'
    end
    expect(page).to have_css 'h2', text: '利用規約'
  end

  it 'フッターからプライバシーポリシーにアクセスする' do
    visit root_path
    within 'ul' do
      click_on 'プライバシーポリシー'
    end
    expect(page).to have_css 'h2', text: 'プライバシーポリシー'
  end
end
