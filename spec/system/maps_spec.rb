require 'rails_helper'

RSpec.describe 'Maps', type: :system do
  before do
    @user = FactoryBot.create(:user)
    sign_in @user
    visit new_walk_path
    click_on 'はじめる'
  end

  scenario 'initialized map is displayed when start walking' do
    expect(page).to have_css '#map'
    expect(page).to have_css 'path[stroke="green"]'
    expect(page).to_not have_css 'path[stroke="red"]'
    expect(page.all('.leaflet-marker-icon').count).to eq Station.count
  end

  scenario 'red line is drawn when arrived' do
    expect(page).to_not have_css 'path[stroke="red"]'
    click_on '到着'
    click_on '地図に戻る'
    expect(page).to have_css 'path[stroke="red"]'
  end

  scenario 'station pop-up is updated when arrived' do
    expect(page).to have_css '.leaflet-popup-content', text: '品川駅'
    expect(page).to_not have_css '.leaflet-popup-content', text: '大崎駅'
    click_on '到着'
    click_on '地図に戻る'
    expect(page).to have_css '.leaflet-popup-content', text: '大崎駅'
    expect(page).to_not have_css '.leaflet-popup-content', text: '品川駅'
  end
end
