# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Reports', type: :system do
  let(:walk) { FactoryBot.create(:walk) }

  it '到着レポートページにアクセスする' do
    create_arrivals(walk, 1)
    visit arrival_report_path(walk.arrivals.last)
    expect(page).to have_title '品川駅に到着'
    expect(page).to have_selector('img[alt="品川駅のイラスト"]')
  end

  it 'ゴール時にレポートページにアクセスする' do
    create_arrivals(walk, 31)
    visit arrival_report_path(walk.arrivals.last)
    expect(page).to have_title '品川駅にゴール'
    expect(page).to have_content '表彰状'
  end
end
