# frozen_string_literal: true

module WalkHelpers
  def create_arrivals(walk, number)
    number.times do
      if walk.arrivals.empty?
        FactoryBot.create(:arrival, walk:, station_id: 1)
      else
        next_station = walk.current_station.next(clockwise: walk.clockwise)
        FactoryBot.create(:arrival, walk:, station: next_station)
      end
    end
    walk.arrivals
  end

  def start_walk(clockwise: true)
    visit new_walk_path
    select '品川'
    click_on '進む'
    choose '内回り' unless clockwise
    click_on '進む'
    click_on 'はじめる'
    click_on '確認しました'
    expect(page).to have_content('歩行記録ノートを作成しました。')
  end
end
