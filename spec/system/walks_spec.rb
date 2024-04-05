require 'rails_helper'

RSpec.describe 'Walks', type: :system do
  before do
    @user = FactoryBot.create(:user)
    sign_in @user
  end

  scenario '歩行開始時に歩行記録が作られる' do
    visit new_walk_path
    select '大塚', from: 'station_id'
    choose '外回り'
    expect do
      click_on 'はじめる'
      expect(page).to have_content('歩行記録の作成に成功しました')
    end.to change { Walk.count }.by(1)
  end

  scenario '歩行開始時に歩行の情報が表示される' do
    visit new_walk_path
    click_on 'はじめる'
    expect(page).to have_content('出発から：0時間0分')
    expect(page).to have_content('歩いた駅：0駅（残り30駅）')
    expect(page).to have_content('歩いた距離：約0km（残り34.5km）')
  end
end
