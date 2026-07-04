# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Walks::Suspensions', type: :request do
  let(:user) { FactoryBot.create(:user) }

  before do
    sign_in user
  end

  describe 'POST /walks/:walk_id/suspension' do
    subject(:suspend_walk) { post walk_suspension_path(walk) }

    let!(:walk) { FactoryBot.create(:walk, :with_arrivals, user:) }

    it '中断が開始される' do
      expect { suspend_walk }.to change { walk.suspensions.ongoing.count }.from(0).to(1)

      expect(response).to redirect_to walk_path(walk)
      expect(flash[:notice]).to eq('歩行を中断しました。')
    end

    context 'すでに中断中の場合' do
      before { FactoryBot.create(:suspension, walk:) }

      it '中断は作成されず、アラートが表示される' do
        expect { suspend_walk }.not_to(change { walk.suspensions.count })

        expect(response).to redirect_to walk_path(walk)
        expect(flash[:alert]).to eq('すでに中断中です')
      end
    end

    context '他のユーザーの歩行記録の場合' do
      let!(:walk) { FactoryBot.create(:walk, :with_arrivals) }

      it '404 が返る' do
        suspend_walk
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'PATCH /walks/:walk_id/suspension' do
    subject(:resume_walk) { patch walk_suspension_path(walk) }

    let!(:walk) { FactoryBot.create(:walk, :with_arrivals, user:) }

    context '中断中の場合' do
      let!(:suspension) { FactoryBot.create(:suspension, walk:) }

      it '中断が終了する' do
        expect { resume_walk }.to change { suspension.reload.ended_at }.from(nil)

        expect(response).to redirect_to walk_path(walk)
        expect(flash[:notice]).to eq('歩行を再開しました。')
      end
    end

    context '中断中でない場合' do
      it 'アラートが表示される' do
        resume_walk

        expect(response).to redirect_to walk_path(walk)
        expect(flash[:alert]).to eq('中断中ではありません。')
      end
    end
  end
end
