# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Walk, type: :model do
  let!(:walk) { FactoryBot.create(:walk) }

  describe '#current_station' do
    it '現在の駅を取得できること' do
      create_arrivals(walk, Station.cache_count)
      expect(walk.current_station.name).to eq '高輪ゲートウェイ'
    end
  end

  describe '#arrived_stations' do
    it '到着駅一覧を取得できること' do
      create_arrivals(walk, Station.cache_count)
      expect(walk.arrived_stations.length).to eq(Station.cache_count)
    end
  end

  describe '#arrived_distance' do
    context '外回りモードの時' do
      let!(:walk) { FactoryBot.create(:walk, clockwise: true) }

      it '歩行済みの距離が取得できること' do
        create_arrivals(walk, 3)
        expect(walk.arrived_distance).to eq(2.9)
      end

      it '歩行終了時に合計距離と同じになること' do
        create_arrivals(walk, 31)
        expect(walk.arrived_distance).to eq(37.8)
      end
    end

    context '内回りモードの時' do
      let!(:walk) { FactoryBot.create(:walk, clockwise: false) }

      it '歩行済みの距離が取得できること' do
        create_arrivals(walk, 3)
        expect(walk.arrived_distance).to eq(2.7)
      end

      it '歩行終了時に合計距離と同じになること' do
        create_arrivals(walk, 31)
        expect(walk.arrived_distance).to eq(37.8)
      end
    end
  end

  describe '#arrivals_of_departure' do
    it '到着記録がない場合はnilが返ること' do
      walk = FactoryBot.create(:walk)
      expect(walk.arrival_of_departure).to be_nil
    end

    it '到着記録がある場合は最初の記録が返ること' do
      walk = FactoryBot.create(:walk)
      create_arrivals(walk, Station.cache_count)
      expect(walk.arrival_of_departure).to eq(walk.arrivals.first)
    end
  end

  describe '#arrival_of_goal' do
    it '一周終了していない場合はnilが返ること' do
      create_arrivals(walk, Station.cache_count)
      expect(walk.arrival_of_goal).to be_nil
    end

    it '到着記録がある場合は最後の記録が返ること' do
      create_arrivals(walk, Station.cache_count + 1)
      expect(walk.arrival_of_goal).to eq(walk.arrivals.last)
    end
  end

  describe '#number_of_walked' do
    it '歩行済みの駅数が返ること' do
      create_arrivals(walk, 5)
      expect(walk.number_of_walked).to eq(4)
    end
  end

  describe '#finished?' do
    it '一周終了していない場合はfalseになる' do
      create_arrivals(walk, Station.cache_count)
      expect(walk).not_to be_finished
    end

    it '一周終了時にはtrueになる' do
      create_arrivals(walk, Station.cache_count + 1)
      expect(walk).to be_finished
    end
  end
end
