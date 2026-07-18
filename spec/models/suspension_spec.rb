# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Suspension, type: :model do
  let!(:walk) { FactoryBot.create(:walk, :with_arrivals) }

  describe '#walk_must_be_in_progress' do
    context '実施中の歩行記録の場合' do
      it 'valid になること' do
        suspension = FactoryBot.build(:suspension, walk:)
        expect(suspension).to be_valid
      end
    end

    context 'リタイア済みの歩行記録の場合' do
      let!(:walk) { FactoryBot.create(:walk, :with_arrivals, active: false) }

      it 'invalid になること' do
        suspension = FactoryBot.build(:suspension, walk:)
        expect(suspension).to be_invalid
        expect(suspension.errors.full_messages.join).to eq '実施中の歩行記録以外は中断できません'
      end
    end

    context '一周完了した歩行記録の場合' do
      let!(:walk) { FactoryBot.create(:walk, :with_arrivals, arrivals_count: Station.cache_count + 1) }

      it 'invalid になること' do
        suspension = FactoryBot.build(:suspension, walk:)
        expect(suspension).to be_invalid
        expect(suspension.errors.full_messages.join).to eq '実施中の歩行記録以外は中断できません'
      end
    end
  end

  describe '#prohibit_multiple_ongoing_suspensions' do
    context '進行中の中断がすでにある場合' do
      before { FactoryBot.create(:suspension, walk:) }

      it 'invalid になること' do
        suspension = FactoryBot.build(:suspension, walk:)
        expect(suspension).to be_invalid
        expect(suspension.errors.full_messages.join).to eq 'すでに中断中です'
      end

      it 'バリデーションをスキップしても DB の部分ユニークインデックスで弾かれること' do
        suspension = FactoryBot.build(:suspension, walk:)
        expect { suspension.save(validate: false) }.to raise_error(ActiveRecord::RecordNotUnique)
      end
    end

    context '終了済みの中断だけがある場合' do
      before { FactoryBot.create(:suspension, :ended, walk:) }

      it 'valid になること' do
        suspension = FactoryBot.build(:suspension, walk:)
        expect(suspension).to be_valid
      end
    end
  end

  describe '#ended_at_must_be_after_started_at' do
    it '終了時刻が開始時刻より前の場合、invalid になること' do
      suspension = FactoryBot.build(:suspension, walk:, ended_at: 1.hour.ago)
      expect(suspension).to be_invalid
      expect(suspension.errors.full_messages.join).to eq '中断終了時刻は中断開始時刻より後の時刻を設定してください'
    end
  end

  describe '#check_suspension_times' do
    # 中断作成時に walk.arrivals がロードされるため、到着は中断より先に作成する
    let!(:walk) do
      FactoryBot.create(:walk).tap do |walk|
        FactoryBot.create(:arrival, walk:, arrived_at: 1.day.ago, station_id: 1)
      end
    end
    let!(:suspension) { FactoryBot.create(:suspension, :ended, walk:, started_at: 2.hours.ago) }

    it '開始・終了時刻を更新できること' do
      expect(suspension.update(started_at: 3.hours.ago, ended_at: 1.hour.ago)).to be true
    end

    it '未来の開始時刻は設定できないこと' do
      suspension.started_at = 1.hour.from_now
      expect(suspension.valid?).to be false
      expect(suspension.errors.full_messages.join).to include '中断開始時刻に未来の時刻は設定できません'
    end

    it '未来の終了時刻は設定できないこと' do
      suspension.ended_at = 1.hour.from_now
      expect(suspension.valid?).to be false
      expect(suspension.errors.full_messages.join).to eq '中断終了時刻に未来の時刻は設定できません'
    end

    it '出発時刻より前の開始時刻は設定できないこと' do
      suspension.started_at = 2.days.ago
      expect(suspension.valid?).to be false
      expect(suspension.errors.full_messages.join).to eq '中断開始時刻は出発時刻より後の時刻を設定してください'
    end

    it '他の中断と重複する期間は設定できないこと' do
      FactoryBot.create(:suspension, :ended, walk:, started_at: 5.hours.ago)
      suspension.started_at = 4.6.hours.ago
      expect(suspension.valid?).to be false
      expect(suspension.errors.full_messages.join).to eq '他の中断と期間が重複しています'
    end

    it '一周完了した歩行記録の中断は編集できないこと' do
      create_arrivals(walk, Station.cache_count)
      walk.reload
      suspension.started_at = 3.hours.ago
      expect(suspension.valid?).to be false
      expect(suspension.errors.full_messages.join).to eq '実施中の歩行記録以外は中断できません'
    end
  end

  describe 'reason のバリデーション' do
    it '250文字まで入力できること' do
      suspension = FactoryBot.build(:suspension, walk:, reason: 'あ' * 250)
      expect(suspension).to be_valid
    end

    it '251文字以上は入力できないこと' do
      suspension = FactoryBot.build(:suspension, walk:, reason: 'あ' * 251)
      expect(suspension).to be_invalid
      expect(suspension.errors.full_messages.join).to eq '中断理由は250文字以内で入力してください'
    end
  end

  describe '#ongoing?' do
    it '終了時刻がない場合は true になること' do
      suspension = FactoryBot.create(:suspension, walk:)
      expect(suspension).to be_ongoing
    end

    it '終了時刻がある場合は false になること' do
      suspension = FactoryBot.create(:suspension, :ended, walk:)
      expect(suspension).not_to be_ongoing
    end
  end

  describe '#duration_seconds' do
    it '終了済みの場合、開始から終了までの秒数が返ること' do
      suspension = FactoryBot.create(:suspension, :ended, walk:)
      expect(suspension.duration_seconds).to eq 30.minutes
    end

    it '進行中の場合、開始から現在までの秒数が返ること' do
      suspension = FactoryBot.create(:suspension, walk:, started_at: 10.minutes.ago)
      expect(suspension.duration_seconds).to be_within(5).of(10.minutes)
    end
  end
end
