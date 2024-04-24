require 'rails_helper'

RSpec.describe 'Arrivals', type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:walk) { user.create_walk }

  before do
    sign_in user
  end

  context '外回りモードの場合' do
    it '歩行を開始する' do
      expect do
        start_walk
      end.to change { Arrival.count }.by(1)
    end

    it '到着を記録する' do
      start_walk
      expect do
        click_on '到着'
        expect(page).to have_content('大崎駅に到着しました')
        expect(page).to have_content('歩いた駅は1駅（残り29駅）、歩いた距離は約2.0kmです')
      end.to change { Arrival.count }.by(1)
    end

    it '到着時刻を正常な値に編集する' do
      start_walk
      visit arrivals_path
      click_on '編集'
      select '00', from: 'arrival_arrived_at_4i'
      select '00', from: 'arrival_arrived_at_5i'
      click_on '保存'
      expect(page).to have_content('到着記録を更新しました')
    end

    it '不正な到着時刻に編集する' do
      start_walk
      visit arrivals_path
      click_on '編集'
      time = Time.current + 60
      select format('%02d', time.hour), from: 'arrival_arrived_at_4i'
      select format('%02d', time.min), from: 'arrival_arrived_at_5i'
      click_on '保存'
      expect(page).to have_content('到着時刻に未来の時刻は設定できません')
    end

    it '到着記録を削除する' do
      create_arrivals(walk, 2)
      visit arrivals_path
      expect(page).to have_content('大崎駅')
      page.accept_confirm do
        click_on '到着を削除'
      end
      expect(page).to_not have_content('大崎駅')
    end
  end

  context '内回りモードの場合' do
    it '歩行を開始する' do
      expect do
        start_counter_clockwise_walk
      end.to change { Arrival.count }.by(1)
    end

    it '到着を記録する' do
      start_counter_clockwise_walk
      expect do
        click_on '到着'
        expect(page).to have_content('高輪ゲートウェイ駅に到着しました')
        expect(page).to have_content('歩いた駅は1駅（残り29駅）、歩いた距離は約2.0kmです')
      end.to change { Arrival.count }.by(1)
    end

    it '到着時刻を正常な値に編集する' do
      start_counter_clockwise_walk
      visit arrivals_path
      click_on '編集'
      select '00', from: 'arrival_arrived_at_4i'
      select '00', from: 'arrival_arrived_at_5i'
      click_on '保存'
      expect(page).to have_content('到着記録を更新しました')
    end

    it '不正な到着時刻に編集する' do
      start_counter_clockwise_walk
      visit arrivals_path
      click_on '編集'
      time = Time.current + 60
      select format('%02d', time.hour), from: 'arrival_arrived_at_4i'
      select format('%02d', time.min), from: 'arrival_arrived_at_5i'
      click_on '保存'
      expect(page).to have_content('到着時刻に未来の時刻は設定できません')
    end

    it '到着記録を削除する' do
      start_counter_clockwise_walk
      create_arrivals(user.walk, 2)
      visit arrivals_path
      expect(page).to have_content('田町駅')
      page.accept_confirm do
        click_on '到着を削除'
      end
      expect(page).to_not have_content('田町駅')
    end
  end

  it 'すべての駅に到着する' do
    create_arrivals(walk, 30)
    visit walk_path
    click_on '到着'
    expect(page).to have_content('あなたは、山手線の30駅全てを歩ききりました')
  end
end
