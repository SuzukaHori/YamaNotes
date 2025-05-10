# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ArrivalsHelper, type: :helper do
  let(:user) { FactoryBot.create(:user) }
  let(:walk) { user.walks.create(clockwise: true) }

  describe '#remaining_distance' do
    context '1駅のみに到着した時' do
      it '全部の距離 - 1駅の距離が表示されること' do
        create_arrivals(walk, 2)
        remaining_distance = Station.total_distance - walk.arrived_stations.first.distance_to_next(clockwise: true)
        expect(helper.remaining_distance(arrived_distance: walk.arrived_distance)).to eq(remaining_distance)
      end
    end

    context '残り1駅の場合' do
      it '残り1駅の距離が表示されること' do
        create_arrivals(walk, 30)
        remaining_distance = walk.current_station.clockwise_distance_to_next
        expect(helper.remaining_distance(arrived_distance: walk.arrived_distance)).to eq(remaining_distance)
      end
    end

    context 'ゴール後の場合' do
      it '0が表示されること' do
        create_arrivals(walk, 31)
        expect(helper.remaining_distance(arrived_distance: walk.arrived_distance)).to eq(0)
      end
    end
  end

  it '#number_of_remaining' do
    create_arrivals(walk, 3)
    expect(helper.number_of_remaining(number_of_walked: walk.number_of_walked)).to eq(Station.cache_count - 2)
  end

  it '#deletable?' do
    allow(helper).to receive(:current_user).and_return(user)
    create_arrivals(walk, 3)
    expect(helper.deletable?(editable: true, arrival: walk.arrivals.order(:created_at).last, arrivals: walk.arrivals)).to be true
  end
end
