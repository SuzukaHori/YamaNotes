require 'rails_helper'

RSpec.describe 'Footer', type: :system do
  it 'フッターから利用規約にアクセスする' do
    visit root_path
    click_on '利用規約'
    expect(page).to have_css 'h2', text: '利用規約'
  end

  it 'フッターからプライバシーポリシーにアクセスする' do
    visit root_path
    click_on 'プライバシーポリシー'
    expect(page).to have_content('プライバシーポリシー')
  end
end
