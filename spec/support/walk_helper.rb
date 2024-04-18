module WalkHelpers
  def create_arrivals(number)
    number.times do
      next_station = @walk.current_station.next(clockwise: @walk.clockwise)
      @walk.arrivals.create!(station: next_station, arrived_at: Time.current)
    end
  end

  def start_walk
    visit new_walk_path
    click_on 'はじめる'
  end
end
