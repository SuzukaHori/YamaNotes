require 'rails_helper'

RSpec.shared_examples 'Arrivals_examples' do |clockwise|
  let(:user) { FactoryBot.create(:user) }
  let(:walk) { user.create_walk(clockwise:) }

  before do
    sign_in user
  end

  it '歩行を開始する' do
    expect do
      start_walk(clockwise:)
    end.to change { Arrival.count }.by(1)
  end

  it '到着を記録する' do
    start_walk(clockwise:)
    expect do
      click_on '到着'
      expect(page).to have_content('大崎駅に到着しました')
      expect(page).to have_content('歩いた駅は1駅（残り29駅')
      expect(page).to have_content('歩いた距離は約2.0kmです')
    end.to change { Arrival.count }.by(1)
  end

  it '到着時にツイートする' do
    create_arrivals(walk, 2)
    visit arrival_path(walk.arrivals.order(:created_at).last)
    click_on 'post_button'
    switch_to_window(windows.last)
    url = URI.decode_www_form_component(current_url)
    expect(url).to have_content '駅に到着しました'
    expect(url).to have_content '&hashtags=山手線を徒歩で一周'
  end

  it '到着時刻を正常な値に編集する' do
    start_walk(clockwise:)
    visit arrivals_path
    click_on '編集'
    select '00', from: 'arrival_arrived_at_4i'
    select '00', from: 'arrival_arrived_at_5i'
    click_on '保存'
    expect(page).to have_content('到着記録を更新しました')
  end

  it '不正な到着時刻に編集する' do
    start_walk(clockwise:)
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
    last_station_name = walk.arrivals.order(:created_at).last.station.name
    expect(page).to have_content(last_station_name)
    page.accept_confirm do
      click_on '到着を削除'
    end
    expect(page).to_not have_content(last_station_name)
  end

  it 'すべての駅に到着する' do
    create_arrivals(walk, 30)
    visit walk_path
    click_on '到着'
    expect(page).to have_content('あなたは、山手線の30駅全てを歩ききりました')
  end

  it '一周終了時にツイートする' do
    create_arrivals(walk, 31)
    visit arrival_path(walk.arrivals.order(:created_at).last)
    click_on 'post_button'
    switch_to_window(windows.last)
    url = URI.decode_www_form_component(current_url)
    expect(url).to have_content '山手線30駅全てを歩ききりました'
    expect(url).to have_content '&hashtags=山手線を徒歩で一周'
  end
end

RSpec.describe 'Arrivals', type: :system do
  context '外回りモードの場合' do
    include_examples 'Arrivals_examples', clockwise: true
  end

  context '内回りモードの場合' do
    include_examples 'Arrivals_examples', clockwise: false
  end
end
