require 'rails_helper'

RSpec.describe Walk, type: :model do
  describe '現在の駅を取得する' do
    context '外回りモードの時' do
      before do
        @walk = FactoryBot.create(:walk)
        @arrival = @walk.arrivals.create!(station_id: 1, arrived_at: Time.current)
      end

      it '出発時に現在の駅を取得する' do
        expect(@walk.current_station.name).to eq '品川'
      end

      it '複数の駅に到着後、現在の駅を取得する' do
        create_arrivals(29)
        expect(@walk.current_station.name).to eq '高輪ゲートウェイ'
      end
    end

    context '内回りモードの時' do
      before do
        @walk = FactoryBot.create(:walk, clockwise: false)
        @arrival = @walk.arrivals.create!(station_id: 1, arrived_at: Time.current)
      end

      it '出発時に現在の駅を取得する' do
        expect(@walk.current_station.name).to eq '品川'
      end

      it '複数の駅に到着後、現在の駅を取得する' do
        create_arrivals(29)
        expect(@walk.current_station.name).to eq '大崎'
      end
    end
  end

  describe '到着駅一覧を取得する' do
    context '外回りモードの時' do
      before do
        @walk = FactoryBot.create(:walk)
        @arrival = @walk.arrivals.create!(station_id: 1, arrived_at: Time.current)
      end

      it '出発直後に到着駅一覧を取得する' do
        expect(@walk.arrived_stations.map(&:id)).to eq([1])
      end

      it '複数の駅に到着後、到着駅一覧を取得する' do
        create_arrivals(29)
        expect(@walk.arrived_stations.length).to eq(30)
      end
    end

    context '内回りモードの時' do
      before do
        @walk = FactoryBot.create(:walk, clockwise: false)
        @arrival = @walk.arrivals.create!(station_id: 1, arrived_at: Time.current)
      end

      it '出発直後に到着駅一覧を取得する' do
        expect(@walk.arrived_stations.map(&:id)).to eq([1])
      end

      it '複数の駅に到着後、到着駅一覧を取得する' do
        create_arrivals(29)
        expect(@walk.arrived_stations.length).to eq(30)
      end
    end
  end
end
