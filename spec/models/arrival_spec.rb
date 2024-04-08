require 'rails_helper'

RSpec.describe Arrival, type: :model do
  before do
    @walk = FactoryBot.create(:walk)
    @arrival = @walk.arrivals.create!(station_id: 1, arrived_at: Time.current)
  end

  describe '近接する駅以外への到着を禁止する' do
    it '近接する駅に到着する' do
      expect do
        @walk.arrivals.create!(station_id: 2, arrived_at: Time.current)
      end.to change { Arrival.count }.by(1)
    end

    it '近接しない駅には到着できない' do
      expect do
        @walk.arrivals.create!(station_id: 13, arrived_at: Time.current)
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
