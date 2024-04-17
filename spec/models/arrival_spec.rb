require 'rails_helper'

RSpec.describe Arrival, type: :model do
  before do
    @walk = FactoryBot.create(:walk)
    @arrival = @walk.arrivals.create!(station_id: 1, arrived_at: Time.current)
  end

  describe '近接する駅以外への到着を禁止する' do
    it '近接する駅に到着する' do
      expect { create_second_arrival }.to change { Arrival.count }.by(1)
    end

    it '近接しない駅には到着できない' do
      expect do
        @walk.arrivals.create!(station_id: 13, arrived_at: Time.current)
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe '#check_arrived_time' do
    it '到着時刻を更新できる' do
      expect(@arrival.update(arrived_at: @arrival.arrived_at - 60)).to be true
    end

    it '未来の時刻を到着時刻に設定できない' do
      arrival = create_second_arrival
      arrival.arrived_at += 60
      expect(arrival.valid?).to be false
    end

    it '一つ前の到着時刻より前の時刻を設定できない' do
      arrival = @walk.arrivals.create!(station_id: 2, arrived_at: @arrival.arrived_at)
      arrival.arrived_at = @arrival.arrived_at - 60
      expect(arrival.valid?).to be false
    end

    it '一つ後ろの到着時刻より後の時刻を設定できない' do
      arrival = create_second_arrival
      @arrival.arrived_at = arrival.arrived_at + 60
      expect(@arrival.valid?).to be false
    end
  end

  describe '#check_arrival_location' do
    it '最後の到着を削除できる' do
      arrival = create_second_arrival
      expect { arrival.destroy! }.to change { Arrival.count }.by(-1)
    end

    it '最後の到着以外を削除できない' do
      create_second_arrival
      expect { @arrival.destroy! }.to raise_error(ActiveRecord::RecordNotDestroyed)
    end
  end

  private

  def create_second_arrival
    @walk.arrivals.create!(station_id: 2, arrived_at: Time.current)
  end
end
