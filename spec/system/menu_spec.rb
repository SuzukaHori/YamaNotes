# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Menu', type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:walk) { user.walks.take }

  before do
    sign_in user
    start_walk
  end

  it 'メニューバーから到着ページにアクセスする' do
    visit walk_path(walk)
    click_on 'menu_button'
    click_on '到着一覧'
    expect(page).to have_title '到着一覧'
    click_on 'menu_button'
    click_on 'ダッシュボード'
    expect(page).to have_title 'ダッシュボード'
  end

  it 'ヘッダーのアイコンからヘルプにアクセスする' do
    visit walk_path(walk)
    click_on 'help_button'
    expect(page).to have_css 'h2', text: '使い方'
  end

  context 'ヘッダーのロゴをクリックする' do
    it 'ログイン済みの場合、トップページにアクセスする' do
      visit walk_path(walk)
      find('img[alt="YamaNotesのロゴ"]').click
      expect(page).to have_title 'ダッシュボード'
    end

    it '未ログインの場合、トップページにアクセスする' do
      sign_out(user)
      find('img[alt="YamaNotesのロゴ"]').click
      expect(page).to have_title 'トップページ'
    end
  end

  it 'フッターから利用規約にアクセスする' do
    visit root_path
    within 'footer' do
      click_on '利用規約'
    end
    expect(page).to have_title '利用規約'
  end

  it 'フッターからプライバシーポリシーにアクセスする' do
    visit root_path
    within 'footer' do
      click_on 'プライバシーポリシー'
    end
    expect(page).to have_title 'プライバシーポリシー'
  end
end
