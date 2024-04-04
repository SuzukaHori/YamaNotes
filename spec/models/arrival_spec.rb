require 'rails_helper'

RSpec.describe Arrival, type: :model do
  before do
    @walk = FactoryBot.create(:walk)
    @arrival = @walk.arrivals.create!(station_id: 1, arrived_at: nil)
  end

  describe '到着済みかどうか判定する' do
    it '到着済みならtrueが返る' do
      @arrival.update!(arrived_at: Time.current)
      expect(@arrival.arrived?).to be_truthy
    end
    it '未到着ならfalseが返る' do
      expect(@arrival.arrived?).to be_falsey
    end
  end

  describe '近接する駅以外への到着を禁止する' do
    it '近接する駅に到着する' do
      expect {
        @walk.arrivals.create!(station_id: 2, arrived_at: Time.current)
      }.to change { Arrival.count }.by(1)
    end

    it '近接しない駅には到着できない' do
      # TODO：バリデーションの追加
      # expect {
      #   @walk.reload.arrivals.create!(station_id: 13, arrived_at: Time.current)
      # }.to change { Arrival.count }.by(1)
    end

    it '一周終了時に最初の駅の到着時刻を更新する' do
      (2..30).each do |n|
        @walk.arrivals.create!(station_id: n, arrived_at: Time.current)
      end
      @arrival.update!(station_id: 1, arrived_at: Time.current)
    end
  end
end
