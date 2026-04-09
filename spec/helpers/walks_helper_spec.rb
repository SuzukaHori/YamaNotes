# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WalksHelper, type: :helper do
  let!(:user) { FactoryBot.create(:user) }
  let!(:walk) { FactoryBot.create(:walk, user:) }

  before do
    FactoryBot.create(:arrival, walk:, arrived_at: (1.day.ago - 1.minute).beginning_of_minute, station_id: 1)
  end

  describe '#walk_status_label' do
    subject(:label) { helper.walk_status_label(walk) }

    context '一周完了のとき' do
      before { create_arrivals(walk, Station.cache_count) }

      it '「一周完了」と表示される' do
        expect(label).to have_text('一周完了')
      end

      it '緑色のバッジになる' do
        expect(label).to include('bg-green-50', 'text-green-700')
      end
    end

    context '歩行中のとき' do
      it '「歩行中」と表示される' do
        expect(label).to have_text('歩行中')
      end

      it '青色のバッジになる' do
        expect(label).to include('bg-blue-50', 'text-blue-700')
      end
    end

    context 'リタイアのとき' do
      let!(:walk) { FactoryBot.create(:walk, user:, active: false) }

      it '「リタイア」と表示される' do
        expect(label).to have_text('リタイア')
      end

      it 'グレーのバッジになる' do
        expect(label).to include('bg-gray-50', 'text-gray-600')
      end
    end
  end

  it '#elapsed_time' do
    expect(helper.elapsed_time(walk)).to eq('約24時間1分')
  end

  describe '#time_to_reach_goal' do
    it '歩行が終了していない時、nilが返る' do
      create_arrivals(walk, 29)
      expect(helper.time_to_reach_goal(walk)).to be_nil
    end

    it '歩行が終了済みの場合、出発からゴールまでの時間が返る' do
      create_arrivals(walk, 30)
      expect(helper.time_to_reach_goal(walk)).to eq '約24時間1分'
    end
  end
end
