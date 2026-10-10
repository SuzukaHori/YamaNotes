# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Walk, type: :model do
  describe '#current_station' do
    let!(:walk) { FactoryBot.create(:walk) }

    it '現在の駅を取得できること' do
      create_arrivals(walk, Station.cache_count)
      expect(walk.current_station.key).to eq 'takanawa_gateway'
    end
  end

  describe '#arrived_stations' do
    let!(:walk) { FactoryBot.create(:walk) }

    it '到着駅一覧を取得できること' do
      create_arrivals(walk, Station.cache_count)
      expect(walk.arrived_stations.length).to eq(Station.cache_count)
    end
  end

  describe '#arrived_distance' do
    let!(:walk) { FactoryBot.create(:walk) }

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
    let!(:walk) { FactoryBot.create(:walk) }

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
    let!(:walk) { FactoryBot.create(:walk) }

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
    let!(:walk) { FactoryBot.create(:walk) }

    it '歩行済みの駅数が返ること' do
      create_arrivals(walk, 5)
      expect(walk.number_of_walked).to eq(4)
    end
  end

  describe '#finished?' do
    let!(:walk) { FactoryBot.create(:walk) }

    it '一周終了していない場合はfalseになる' do
      create_arrivals(walk, Station.cache_count)
      expect(walk).not_to be_finished
    end

    it '一周終了時にはtrueになる' do
      create_arrivals(walk, Station.cache_count + 1)
      expect(walk).to be_finished
    end
  end

  describe '#suspended?' do
    let!(:walk) { FactoryBot.create(:walk, :with_arrivals) }

    it '進行中の中断がある場合は true になること' do
      FactoryBot.create(:suspension, walk:)
      expect(walk).to be_suspended
    end

    it '終了済みの中断しかない場合は false になること' do
      FactoryBot.create(:suspension, :ended, walk:)
      expect(walk).not_to be_suspended
    end

    it '中断がない場合は false になること' do
      expect(walk).not_to be_suspended
    end
  end

  describe '#total_suspended_seconds' do
    let!(:walk) { FactoryBot.create(:walk, :with_arrivals) }

    it '終了済みの中断の合計秒数が返ること' do
      FactoryBot.create(:suspension, :ended, walk:, started_at: 3.hours.ago)
      FactoryBot.create(:suspension, :ended, walk:, started_at: 1.hour.ago)
      expect(walk.total_suspended_seconds).to eq 1.hour
    end

    it '進行中の中断は現在時刻までの秒数が加算されること' do
      FactoryBot.create(:suspension, walk:, started_at: 10.minutes.ago)
      expect(walk.total_suspended_seconds).to be_within(5).of(10.minutes)
    end
  end

  describe '#elapsed_seconds' do
    let!(:walk) { FactoryBot.create(:walk) }

    before do
      FactoryBot.create(:arrival, walk:, arrived_at: 24.hours.ago, station_id: 1)
    end

    # arrived_at は保存時に秒が切り捨てられるため、誤差は最大60秒
    it '中断がない場合、出発からの経過秒数が返ること' do
      expect(walk.elapsed_seconds).to be_within(60).of(24.hours)
    end

    it '終了済みの中断の秒数が差し引かれること' do
      FactoryBot.create(:suspension, :ended, walk:, started_at: 2.hours.ago)
      expect(walk.elapsed_seconds).to be_within(60).of(23.5.hours)
    end

    it '中断中は中断開始時点で経過秒数が止まること' do
      FactoryBot.create(:suspension, walk:, started_at: 2.hours.ago)
      expect(walk.elapsed_seconds).to be_within(60).of(22.hours)
    end
  end

  describe '#time_to_reach_goal_seconds' do
    let!(:walk) { FactoryBot.create(:walk) }

    it '一周終了していない場合は nil が返ること' do
      create_arrivals(walk, Station.cache_count)
      expect(walk.time_to_reach_goal_seconds).to be_nil
    end

    it '出発からゴールまでの秒数から中断の合計が差し引かれること' do
      create_arrivals(walk, 1)
      FactoryBot.create(:suspension, :ended, walk:, started_at: 5.hours.ago)
      create_arrivals(walk, Station.cache_count)
      walk.arrival_of_departure.update!(arrived_at: 10.hours.ago)

      expect(walk.time_to_reach_goal_seconds).to be_within(60).of(9.5.hours)
    end
  end

  describe '#active_walk_uniqueness' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:walk) { FactoryBot.build(:walk, user: user) }

    context '同じユーザーの active な歩行記録が存在する場合' do
      let!(:other_walk) { FactoryBot.create(:walk, user: user, active: true) }

      it 'invalid になること' do
        expect(walk).to be_invalid
        expect(walk.errors).to be_added(:user_id, :only_one_active_walk)
      end
    end

    context '同じユーザーの active でない歩行記録が存在する場合' do
      let!(:other_walk) { FactoryBot.create(:walk, user: user, active: false) }

      it 'valid になること' do
        expect(walk).to be_valid
      end
    end

    context '同じユーザーの歩行記録が存在しない場合' do
      it 'valid になること' do
        expect(walk).to be_valid
      end
    end
  end
end
