module WalkHelpers
  def create_arrivals(walk, number)
    number.times do
      next_station = walk.current_station.next(clockwise: walk.clockwise)
      FactoryBot.create(:arrival, walk:, station: next_station)
    end
  end

  def start_walk
    visit new_walk_path
    click_on 'はじめる'
  end
end
