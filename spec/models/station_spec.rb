require 'rails_helper'

RSpec.describe Station, type: :model do
  describe '#next' do
    context '内回りモードの場合' do
      it 'idが一つ後ろの駅が返る' do
        station = Station.find(1)
        expect(station.next(clockwise: true).id).to eq(2)
      end

      it 'idが最後の場合は1の駅が返る' do
        station = Station.find(Station.count)
        expect(station.next(clockwise: true).id).to eq(1)
      end
    end

    context '外回りモードの場合' do
      it 'idが一つ前の駅が返る' do
        station = Station.find(2)
        expect(station.next(clockwise: false).id).to eq(1)
      end

      it 'idが最初の場合は30の駅が返る' do
        station = Station.find(1)
        expect(station.next(clockwise: false).id).to eq(Station.count)
      end
    end
  end

  describe '.total_distance' do
    it 'すべての駅の合計を取得できること' do
      expect(Station.total_distance).to eq(34.5)
    end
  end
end
