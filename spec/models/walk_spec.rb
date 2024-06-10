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

  describe '#arrivals_of_departure' do
    it '到着記録がない場合はnilが返ること' do
      walk = FactoryBot.create(:walk)
      expect(walk.arrival_of_departure).to eq(nil)
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
      expect(walk.arrival_of_goal).to eq(nil)
    end

    it '到着記録がある場合は最後の記録が返ること' do
      create_arrivals(walk, Station.cache_count + 1)
      expect(walk.arrival_of_goal).to eq(walk.arrivals.last)
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
