require 'rails_helper'

RSpec.describe 'Memos', type: :system, js: true do
  before do
    user = FactoryBot.create(:user)
    sign_in user
  end

  context 'トップページでメモを操作する' do
    scenario 'メモを追加する' do
      start_walk
      click_on 'memo_modal_button'
      fill_in 'arrival_memo', with: 'もうすぐつきそう'
      click_on '保存'
      expect(page).to have_content('到着記録を更新しました')
      visit arrivals_path
      expect(page).to have_content('もうすぐつきそう')
    end

    scenario 'メモを編集する' do
      start_walk
      click_on 'memo_modal_button'
      fill_in 'arrival_memo', with: 'もうすぐつきそう'
      click_on '保存'
      click_on 'memo_modal_button'
      fill_in 'arrival_memo', with: 'まだまだつかない'
      click_on '保存'
      expect(page).to have_content('到着記録を更新しました')
      visit arrivals_path
      expect(page).to have_content('まだまだつかない')
      expect(page).to_not have_content('もうすぐつきそう')
    end
  end

  context '到着一覧ページで操作する' do
    scenario 'メモを追加する' do
      start_walk
      visit arrivals_path
      click_on '編集'
      fill_in 'メモ', with: 'もうすぐつきそう'
      click_on '保存'
      expect(page).to have_content('到着記録を更新しました')
    end

    scenario 'メモを編集する' do
      start_walk
      visit arrivals_path
      click_on '編集'
      fill_in 'メモ', with: 'もうすぐつきそう'
      click_on '保存'
      click_on '編集'
      fill_in 'メモ', with: 'まだまだつかない'
      click_on '保存'
      expect(page).to have_content('まだまだつかない')
      expect(page).to_not have_content('もうすぐつきそう')
    end
  end
end
