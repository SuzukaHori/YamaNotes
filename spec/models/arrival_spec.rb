# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Arrival, type: :model do
  let!(:walk) { FactoryBot.create(:walk) }
  let!(:arrival) { FactoryBot.create(:arrival, walk:, station_id: 1) }
  let(:arrival_second) { FactoryBot.create(:arrival, walk:, station_id: 2) }

  describe '#prohibit_arrival_without_next_station' do
    it '近接する駅に到着できること' do
      expect { arrival_second }.to change(Arrival, :count).by(1)
    end

    it '近接しない駅には到着できないこと' do
      expect do
        FactoryBot.create(:arrival, walk:, station_id: 13, arrived_at: Time.current)
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe '#check_arrived_time' do
    it '到着時刻を更新できること' do
      arrived_at = arrival.arrived_at - 60
      expect(arrival.update(arrived_at:)).to be true
    end

    it '未来の時刻を到着時刻に設定できないこと' do
      arrival_second.arrived_at += 60
      expect(arrival_second.valid?).to be false
    end

    it '一つ前の到着時刻より前の時刻を設定できないこと' do
      arrival_second.arrived_at = arrival.arrived_at - 60
      expect(arrival_second.valid?).to be false
    end

    it '一つ後ろの到着時刻より後の時刻を設定できないこと' do
      arrival.arrived_at = arrival_second.arrived_at + 60
      expect(arrival.valid?).to be false
    end
  end

  describe '#convert_blank_to_nil' do
    it '空文字をnilに変換すること' do
      arrival.memo = ''
      arrival.save!
      expect(arrival.memo.nil?).to be true
    end
  end

  describe '#check_arrival_location' do
    it '最後の到着を削除できること' do
      arrival_second
      expect { arrival_second.destroy! }.to change(Arrival, :count).by(-1)
    end

    it '最後の到着以外を削除できないこと' do
      arrival_second
      expect { arrival.destroy! }.to raise_error(ActiveRecord::RecordNotDestroyed)
    end
  end

  describe '#truncate_seconds_of_arrived_time' do
    it '秒以下の時間を切り捨てて保存されること' do
      arrival = FactoryBot.create(:arrival, walk:, station_id: 2, arrived_at: Time.gm(2000, 1, 1, 1, 1, 59))
      expect(arrival.arrived_at).to eq(Time.gm(2000, 1, 1, 1, 1))
    end
  end

  describe '#arrivals_count_must_be_within_limit' do
    it '駅数+1以上の到着を追加できないこと' do
      create_arrivals(walk, 30)
      over_arrival = walk.arrivals.new(station_id: 2, arrived_at: Time.current)
      expect(over_arrival.valid?).to be false
      expect(over_arrival.errors.full_messages.join).to eq '駅の数以上の到着記録は作成できません'
    end
  end
end
