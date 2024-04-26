require 'rails_helper'

RSpec.describe 'Users/Arrivals', type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:walk_public) { FactoryBot.create(:walk, user:, publish: true) }
  let(:walk_private) { FactoryBot.create(:walk, user:, publish: false) }

  context '作成者本人がアクセスした時' do
    it '未公開状態の到着履歴にアクセスする' do
      sign_in user
      setting_and_visit_public_path(walk_public)
      expect(page).to have_content('編集')
    end

    it '公開用URLをコピーする' do
      sign_in user
      setting_and_visit_public_path(walk_public)
      url = find_field('公開用URL:').value
      expect(url).to include(public_arrivals_path(user))
      click_on 'copy_button'
      expect(page).to have_content('Copied')
    end
  end

  context '未ログインでアクセスした場合' do
    it '公開状態の到着履歴にアクセスする' do
      setting_and_visit_public_path(walk_public)
      expect(page).to_not have_content('編集')
      expect(page).to_not have_content('公開用URL:')
    end

    it '未公開状態の到着履歴にアクセスできない' do
      setting_and_visit_public_path(walk_private)
      expect(page).to have_content('この到着記録は非公開です')
    end
  end

  def setting_and_visit_public_path(walk)
    create_arrivals(walk, 10)
    visit public_arrivals_path(user)
  end
end
