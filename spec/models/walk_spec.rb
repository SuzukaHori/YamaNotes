require 'rails_helper'

shared_context 'clockwise' do
  let(:walk) { FactoryBot.create(:walk) }
  let!(:arrival) { FactoryBot.create(:arrival, walk:, station_id: 1) }
end

shared_context 'counter_clockwise' do
  let(:walk_counter_clockwise) { FactoryBot.create(:walk, clockwise: false) }
  let!(:arrival) { FactoryBot.create(:arrival, walk: walk_counter_clockwise, station_id: 1) }
end

RSpec.describe Walk, type: :model do
  describe '#current_station' do
    context '外回りモードの場合' do
      include_context 'clockwise'
      it '出発時に現在の駅を取得できること' do
        expect(walk.current_station.name).to eq '品川'
      end

      it '複数の駅に到着後、現在の駅を取得できること' do
        create_arrivals(walk, 29)
        expect(walk.current_station.name).to eq '高輪ゲートウェイ'
      end
    end

    context '内回りモードの場合' do
      include_context 'counter_clockwise'
      it '出発時に現在の駅を取得する' do
        expect(walk_counter_clockwise.current_station.name).to eq '品川'
      end

      it '複数の駅に到着後、現在の駅を取得する' do
        create_arrivals(walk_counter_clockwise, 29)
        expect(walk_counter_clockwise.current_station.name).to eq '大崎'
      end
    end
  end

  describe '#arrived_stations' do
    context '外回りモードの場合' do
      include_context 'clockwise'
      it '出発直後に到着駅一覧を取得できること' do
        expect(walk.arrived_stations.map(&:id)).to eq([1])
      end

      it '複数の駅に到着後、到着駅一覧を取得できること' do
        create_arrivals(walk, 29)
        expect(walk.arrived_stations.length).to eq(30)
      end
    end

    context '内回りモードの場合' do
      include_context 'counter_clockwise'
      it '出発直後に到着駅一覧を取得できること' do
        expect(walk_counter_clockwise.arrived_stations.map(&:id)).to eq([1])
      end

      it '複数の駅に到着後、到着駅一覧を取得できること' do
        create_arrivals(walk_counter_clockwise, 29)
        expect(walk_counter_clockwise.arrived_stations.length).to eq(30)
      end
    end
  end
end
