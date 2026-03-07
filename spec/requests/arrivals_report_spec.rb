# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Reports', type: :request do
  let(:walk) { FactoryBot.create(:walk, clockwise: true) }

  describe '#show' do
    subject(:show_report) { get arrival_report_path(walk.arrivals.last) }

    context '通常の到着の場合' do
      before { create_arrivals(walk, 1) }

      it do
        show_report
        expect(response.body).to include('品川駅に到着')
        expect(response.body).to include('品川駅のイラスト')
      end
    end

    context 'ゴール時の場合' do
      before { create_arrivals(walk, 31) }

      it do
        show_report
        expect(response.body).to include('品川駅にゴール')
        expect(response.body).to include('表彰状')
      end
    end
  end
end
