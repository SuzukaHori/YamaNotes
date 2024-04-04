require 'rails_helper'

RSpec.describe "Arrivals", type: :system, js: true do
  before do
    @user = FactoryBot.create(:user)
    sign_in @user
  end

  scenario '歩行開始時に到着記録が作られる' do
    visit new_walk_path
    select "大塚", from: 'station_id'
    choose '外回り'
    expect {
      click_on "はじめる"
      expect(page).to have_content('歩行記録の作成に成功しました')
    }.to change { Arrival.count }.by(1)
  end

  scenario '到着ボタンを押した時に到着記録が作られる' do
    start_walk
    expect(page).to have_content('到着')
    expect {
      click_on '到着'
    }.to change { Arrival.count }.by(1)
  end

  scenario '到着ページで到着した駅の情報が表示される' do
    start_walk
    click_on '到着'
    expect(page).to have_content('大崎駅に到着しました')
    expect(page).to have_content('歩いた駅は1駅（残り29駅）、 歩いた距離は約0.9kmです！')
    click_on '地図に戻る'
    click_on '到着'
    expect(page).to have_content('五反田駅に到着しました')
    expect(page).to have_content('歩いた駅は2駅（残り28駅）、 歩いた距離は約2.1kmです！')
  end

  scenario '到着時に現在の駅の情報が更新される' do
    start_walk
    expect(page).to have_content('現在の駅 ：品川駅')
    expect(page).to have_content('次の駅まで：2.0km')
    click_on '到着'
    click_on '地図に戻る'
    expect(page).to have_content('現在の駅 ：大崎駅')
    expect(page).to have_content('次の駅まで：0.9km')
  end

  def start_walk
    visit new_walk_path
    click_on "はじめる"
  end
end
