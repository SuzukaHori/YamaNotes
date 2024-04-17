require 'rails_helper'

RSpec.describe 'Arrivals', type: :system, js: true do
  before do
    @user = FactoryBot.create(:user)
    sign_in @user
  end

  scenario '歩行開始時に到着記録が作られる' do
    visit new_walk_path
    select '大塚', from: 'station_id'
    choose '外回り'
    expect do
      click_on 'はじめる'
      expect(page).to have_content('歩行記録の作成に成功しました')
    end.to change { Arrival.count }.by(1)
  end

  scenario '到着ボタンを押した時に到着記録が作られる' do
    start_walk
    expect(page).to have_content('到着')
    expect do
      click_on '到着'
      expect(page).to have_content('大崎駅に到着しました')
    end.to change { Arrival.count }.by(1)
  end

  scenario '到着ページで到着した駅の情報が表示される' do
    start_walk
    click_on '到着'
    expect(page).to have_content('大崎駅に到着しました')
    expect(page).to have_content('歩いた駅は1駅（残り29駅）、 歩いた距離は約2.0kmです！')
    click_on '地図に戻る'
    click_on '到着'
    expect(page).to have_content('五反田駅に到着しました')
    expect(page).to have_content('歩いた駅は2駅（残り28駅）、 歩いた距離は約2.9kmです！')
  end

  scenario '到着時に現在の駅の情報が更新される' do
    start_walk
    expect(page).to have_content('現在の駅 ：品川駅')
    expect(page).to have_content('2.0km')
    click_on '到着'
    click_on '地図に戻る'
    expect(page).to have_content('現在の駅 ：大崎駅')
    expect(page).to have_content('0.9km')
  end

  scenario '内回りモードで正しい駅に到着できる' do
    visit new_walk_path
    choose '内回り'
    select '原宿'
    click_on 'はじめる'
    expect(page).to have_content('現在の駅 ：原宿駅')
    click_on '到着'
    expect(page).to have_content('渋谷駅に到着しました')
    click_on '地図に戻る'
    expect(page).to have_content('現在の駅 ：渋谷駅')
  end

  scenario '到着時刻を編集する' do
    start_walk
    expect(page).to have_content('現在の駅 ：品川駅')
    visit arrivals_path
    click_on '編集'
    select '00', from: 'arrival_arrived_at_4i'
    select '00', from: 'arrival_arrived_at_5i'
    click_on '保存'
    expect(page).to have_content('到着記録を更新しました')
  end

  scenario '不正な到着時刻に編集する' do
    start_walk
    visit arrivals_path
    click_on '編集'
    time = Time.current + 60
    select format("%02d",time.hour), from: 'arrival_arrived_at_4i'
    select format("%02d",time.min), from: 'arrival_arrived_at_5i'
    click_on '保存'
    expect(page).to have_content('到着時刻に未来の時刻は設定できません')
  end

  scenario '到着記録を削除する' do
    start_walk
    click_on '到着'
    click_on '地図に戻る'
    expect(page).to have_content('現在の駅 ：大崎駅')
    visit arrivals_path
    expect(page).to have_content('大崎駅')
    page.accept_confirm do
      click_on '到着を削除'
    end
    expect(page).to_not have_content('大崎駅')
  end

  def start_walk
    visit new_walk_path
    click_on 'はじめる'
  end
end
