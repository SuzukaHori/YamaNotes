require 'rails_helper'

RSpec.describe 'Memos', type: :system, js: true do
  before do
    user = FactoryBot.create(:user)
    sign_in user
    start_walk
  end

  context 'トップページでメモを操作する場合' do
    it 'メモを追加する' do
      visit walk_path
      click_on 'memo_modal_button'
      add_memo
      expect(page).to have_content('到着記録を更新しました')
      visit arrivals_path
      expect(page).to have_content('新しいメモ')
    end
  end

  context '到着一覧ページで操作する場合' do
    it 'メモを追加する' do
      visit arrivals_path
      click_on '編集'
      add_memo
      expect(page).to have_content('到着記録を更新しました')
    end

    it 'メモを編集できる' do
      visit walk_path
      click_on 'memo_modal_button'
      add_memo
      visit arrivals_path
      click_on '編集'
      fill_in 'arrival_memo', with: '編集済みのメモ'
      click_on '保存'
      expect(page).to have_content('編集済みのメモ')
      expect(page).to_not have_content('新しいメモ')
    end
  end

  private

  def add_memo
    fill_in 'arrival_memo', with: '新しいメモ'
    click_on '保存'
  end
end
