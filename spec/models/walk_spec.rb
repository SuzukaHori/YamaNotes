require 'rails_helper'

RSpec.describe Walk, type: :model do
  before do
    @walk = FactoryBot.create(:walk)
    @arrival = @walk.arrivals.create!(station_id: 1, arrived_at: Time.current)
  end

  describe '現在の駅を取得する' do
    it '到着済みの駅がない時、出発駅が現在の駅になる' do
      expect(@walk.current_station.name).to eq '品川'
    end

    it '複数の駅に到着済みの時、直近で到着した駅が現在の駅になる' do
      create_arrivals(29)
      expect(@walk.current_station.name).to eq '高輪ゲートウェイ'
    end
  end

  describe '到着駅を取得する' do
    it 'スタート時には出発駅のみの配列が返る' do
      expect(@walk.arrived_stations.map(&:id)).to eq([1])
    end

    it '複数の駅に到着済みの時、駅の配列が返る' do
      create_arrivals(29)
      expect(@walk.arrived_stations.length).to eq(30)
    end
  end

  def create_arrivals(number)
    (1..number).each do |n|
      if n == 30
        @walk.arrivals.create!(station_id: 1, arrived_at: Time.current)
      else
        @walk.arrivals.create!(station_id: n + 1, arrived_at: Time.current)
      end
    end
  end
end
