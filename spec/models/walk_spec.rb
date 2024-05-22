# frozen_string_literal: true

require 'rails_helper'

shared_context 'clockwise' do
  let!(:walk) { FactoryBot.create(:walk) }
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
      it '現在の駅を取得できること' do
        create_arrivals(walk, 29)
        expect(walk.current_station.name).to eq '高輪ゲートウェイ'
      end
    end

    context '内回りモードの場合' do
      include_context 'counter_clockwise'
      it '現在の駅を取得できること' do
        create_arrivals(walk_counter_clockwise, 29)
        expect(walk_counter_clockwise.current_station.name).to eq '大崎'
      end
    end
  end

  describe '#arrived_stations' do
    include_context 'clockwise'
    it '到着駅一覧を取得できること' do
      create_arrivals(walk, 29)
      expect(walk.arrived_stations.length).to eq(30)
    end
  end

  describe '#arrivals_of_departure' do
    it '到着記録がない場合はnilが返ること' do
      walk = FactoryBot.create(:walk)
      expect(walk.arrival_of_departure).to eq(nil)
    end

    it '到着記録がある場合は最初の記録が返ること' do
      walk = FactoryBot.create(:walk)
      create_arrivals(walk, 20)
      expect(walk.arrival_of_departure).to eq(walk.arrivals.first)
    end
  end

  describe '#arrival_of_goal' do
    include_context 'clockwise'
    it '一周終了していない場合はnilが返ること' do
      create_arrivals(walk, 29)
      expect(walk.arrival_of_goal).to eq(nil)
    end

    it '到着記録がある場合は最後の記録が返ること' do
      create_arrivals(walk, 30)
      expect(walk.arrival_of_goal).to eq(walk.arrivals.last)
    end
  end

  describe '#finished?' do
    include_context 'clockwise'
    it '一周終了していない場合はfalseになる' do
      create_arrivals(walk, 29)
      expect(walk.finished?).to be_falsey
    end

    it '一周終了時にはtrueになる' do
      create_arrivals(walk, 30)
      expect(walk.finished?).to be_truthy
    end
  end
end
