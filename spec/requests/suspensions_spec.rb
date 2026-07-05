# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Suspensions', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let!(:walk) do
    FactoryBot.create(:walk, user:).tap do |walk|
      FactoryBot.create(:arrival, walk:, arrived_at: 1.day.ago, station_id: 1)
    end
  end
  let!(:suspension) { FactoryBot.create(:suspension, :ended, walk:, started_at: 2.hours.ago) }

  before do
    sign_in user
  end

  describe 'GET /suspensions/:id/edit' do
    it '編集画面が表示される' do
      get edit_suspension_path(suspension)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'PATCH /suspensions/:id' do
    context '正しいパラメーターの場合' do
      it '中断時刻が更新される' do
        expect do
          patch suspension_path(suspension), params: { suspension: { started_at: 3.hours.ago, ended_at: 1.hour.ago } }
        end.to(change { suspension.reload.started_at })
      end
    end

    context '不正なパラメーターの場合' do
      it '更新されないこと' do
        expect do
          patch suspension_path(suspension), params: { suspension: { started_at: 1.hour.from_now } }
        end.not_to(change { suspension.reload.started_at })
        expect(response).to have_http_status(:unprocessable_content)
      end
    end

    context '他のユーザーの中断の場合' do
      let(:other_user) { FactoryBot.create(:user) }

      before { sign_in other_user }

      it '404 が返る' do
        patch suspension_path(suspension), params: { suspension: { started_at: 3.hours.ago } }
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'リタイア済みの歩行記録の中断の場合' do
      before { walk.update!(active: false) }

      it '404 が返る' do
        patch suspension_path(suspension), params: { suspension: { started_at: 3.hours.ago } }
        expect(response).to have_http_status(:not_found)
      end
    end

    context '一周完了した歩行記録の中断の場合' do
      before { create_arrivals(walk, Station.cache_count) }

      it '404 が返る' do
        patch suspension_path(suspension), params: { suspension: { started_at: 3.hours.ago } }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'DELETE /suspensions/:id' do
    it '中断が削除される' do
      expect { delete suspension_path(suspension) }.to change(Suspension, :count).by(-1)
      expect(response).to redirect_to arrivals_path
    end

    context 'リタイア済みの歩行記録の中断の場合' do
      before { walk.update!(active: false) }

      it '404 が返る' do
        delete suspension_path(suspension)
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
