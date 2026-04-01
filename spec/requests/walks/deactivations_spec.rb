# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Walks::Deactivations', type: :request do
  let(:user) { FactoryBot.create(:user) }

  before do
    sign_in user
  end

  describe 'POST /walks/:walk_id/deactivation' do
    subject(:deactivate_walk) { post walk_deactivation_path(walk) }

    context '一周終了した場合' do
      let!(:walk) do
        FactoryBot.create(:walk, :with_arrivals, arrivals_count: Station.count + 1, user:, clockwise: true)
      end

      it 'active: falseに更新され、歩行完了が表示される' do
        expect { deactivate_walk }.to change { walk.reload.active }.from(true).to(false)

        expect(response).to redirect_to new_walk_path
        expect(flash[:notice]).to eq('歩行を完了しました。')
      end
    end

    context 'リタイアした場合' do
      let!(:walk) do
        FactoryBot.create(:walk, :with_arrivals, arrivals_count: 1, user:, clockwise: true)
      end

      it 'active: falseに更新され、リタイア完了が表示される' do
        expect { deactivate_walk }.to change { walk.reload.active }.from(true).to(false)

        expect(response).to redirect_to new_walk_path
        expect(flash[:notice]).to eq('リタイアしました。')
      end
    end
  end
end
