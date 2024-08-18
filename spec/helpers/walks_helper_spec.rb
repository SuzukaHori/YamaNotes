# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WalksHelper, type: :helper do
  let!(:user) { FactoryBot.create(:user) }
  let!(:walk) { FactoryBot.create(:walk, user:) }

  before do
    FactoryBot.create(:arrival, walk:, arrived_at: (1.day.ago - 1.minute).beginning_of_minute, station_id: 1)
  end

  it '#elapsed_time' do
    expect(helper.elapsed_time(walk)).to eq('24時間1分')
  end

  describe '#time_to_reach_goal' do
    it '歩行が終了していない時、nilが返る' do
      create_arrivals(walk, 29)
      expect(helper.time_to_reach_goal(walk)).to be_nil
    end

    it '歩行が終了済みの場合、出発からゴールまでの時間が返る' do
      create_arrivals(walk, 30)
      expect(helper.time_to_reach_goal(walk)).to eq '24時間1分'
    end
  end
end
