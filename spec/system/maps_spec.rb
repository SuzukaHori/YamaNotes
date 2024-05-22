# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Maps', type: :system do
  before do
    user = FactoryBot.create(:user)
    sign_in user
    start_walk
  end

  it '地図が表示される' do
    expect(page).to have_css '#map'
    expect(page).to have_css 'path[stroke="green"]'
    expect(page.all('.leaflet-marker-icon').count).to eq Station.count
  end

  it '到着時に赤い線が引かれる' do
    expect(page).to_not have_css 'path[stroke="red"]'
    click_on '到着'
    click_on '地図に戻る'
    expect(page).to have_css 'path[stroke="red"]'
  end

  it '到着時に駅のポップアップが更新される' do
    expect(page).to have_css '.leaflet-popup-content', text: '品川駅'
    expect(page).to_not have_css '.leaflet-popup-content', text: '大崎駅'
    click_on '到着'
    click_on '地図に戻る'
    expect(page).to have_css '.leaflet-popup-content', text: '大崎駅'
    expect(page).to_not have_css '.leaflet-popup-content', text: '品川駅'
  end
end
