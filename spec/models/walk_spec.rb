require 'rails_helper'

RSpec.describe Walk, type: :model do
  before do
    @walk = FactoryBot.create(:walk)
    @arrival = @walk.arrivals.create!(station_id: 1, arrived_at: nil)
  end

  describe '現在の駅を取得する' do
    it '到着済みの駅がない時、出発駅が現在の駅になる' do
      expect(@walk.current_station.name).to eq "品川"
    end

    it '複数の駅に到着済みの時、直近で到着した駅が現在の駅になる' do
      create_arrivals(29)
      expect(@walk.current_station.name).to eq '高輪ゲートウェイ'
    end
  end

  describe '到着駅を取得する' do
    it '到着済みの駅がない時、空の配列が返る' do
      expect(@walk.arrived_stations).to eq([])
    end

    it '複数の駅に到着済みの時、駅の配列が返る' do
      create_arrivals(29)
      expect(@walk.arrived_stations.length).to eq(29)
    end
  end

  describe '合計歩行距離を計算する' do
    it 'すべての駅の合計距離が返る' do
      create_arrivals(30)
      expect(@walk.total_distance_walked).to eq(Station.total_distance)
    end
  end

  describe '通過した駅のidを取得する' do
    it '到着済みの駅がない場合、最初の駅のidのみ配列に入れる' do
      expect(@walk.through_station_ids).to eq([1])
    end

    it '到着済みの駅がある場合、通過したすべての駅を配列に入れる' do
      create_arrivals(30)
      expect(@walk.through_station_ids).to eq((1..30).to_a << 1)
    end
  end

  def create_arrivals(number)
    (1..number).each do |n|
      if n == 30
        @arrival.update!(arrived_at: Time.current)
      else
        @walk.arrivals.create!(station_id: n + 1, arrived_at: Time.current)
      end
    end
  end
end
