# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StationHelper, type: :helper do
  describe '#station_image_path' do
    context '駅の専用のイラストが存在する場合' do
      it '駅専用のイラストのパスが返る' do
        station = Station.find_by(name: '渋谷')
        path = station_image_path(station:)
        expect(path).to eq("arrivals/#{station.id}_shibuya.png")
      end
    end

    context '駅専用のイラストが存在しない場合' do
      it 'デフォルトの画像のパスが返る' do
        station = Station.find_by(name: '田町')
        path = station_image_path(station:)
        expect(path).to eq('arrivals/default.png')
      end
    end
  end
end
