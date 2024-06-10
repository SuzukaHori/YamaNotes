# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Station, type: :model do
  describe '#next' do
    context '内回りモードの場合' do
      it 'idが一つ後の駅が返る' do
        station = Station.find(1)
        expect(station.next(clockwise: true).id).to eq(2)
      end

      it 'idが最後の場合は、最初の駅が返る' do
        station = Station.find(Station.cache_count)
        expect(station.next(clockwise: true).id).to eq(1)
      end
    end

    context '外回りモードの場合' do
      it 'idが一つ前の駅が返る' do
        station = Station.find(2)
        expect(station.next(clockwise: false).id).to eq(1)
      end

      it 'idが最初の場合は、最後の駅が返る' do
        station = Station.find(1)
        expect(station.next(clockwise: false).id).to eq(Station.cache_count)
      end
    end
  end

  describe '#distance_to_next' do
    context '内回りモードの場合' do
      it '現在の駅のclockwise_distance_to_nextの値が返る' do
        station = Station.find(1)
        expect(station.distance_to_next(clockwise: true)).to eq(2.0)
      end
    end

    context '外回りモードの場合' do
      it '次の駅のclockwise_distance_to_nextの値が返る' do
        station = Station.find(1)
        expect(station.distance_to_next(clockwise: false)).to eq(1.0)
      end
    end
  end

  describe '.total_distance' do
    it 'すべての駅の合計を取得できること' do
      expect(Station.total_distance).to eq(37.8)
    end
  end

  describe '.cache_count' do
    it '駅数を取得できること' do
      expect(Station.cache_count).to eq(30)
    end
  end

  describe '.cache_all' do
    it 'すべての駅の配列を取得できること' do
      expect(Station.cache_all).to eq(Station.all)
    end
  end
end
