# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Arrivals', type: :request do
  before do
    sign_in login_user
  end

  describe '#index' do
    let!(:login_user) { FactoryBot.create(:user) }

    context '歩行記録がある場合' do
      let!(:walk) do
        FactoryBot.create(:walk, :with_arrivals, user: login_user, clockwise: true)
      end

      it '到着一覧ページが表示されること' do
        get arrivals_path

        node = Capybara.string(response.body)
        expect(node).to have_content('到着履歴')
        expect(node).to have_content('品川駅')
      end
    end

    context '歩行記録がない場合' do
      it 'トップページにリダイレクトすること' do
        get arrivals_path

        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('歩行記録が存在しません。')
      end
    end
  end

  describe '#show' do
    let!(:login_user) { FactoryBot.create(:user) }
    let!(:walk) do
      FactoryBot.create(:walk, user: login_user, clockwise: true)
    end

    context '到着記録が存在する場合' do
      let!(:arrival) { FactoryBot.create(:arrival, walk:, station_id: 1) }

      it '到着駅とイラストが表示されること' do
        get arrival_path(arrival)

        node = Capybara.string(response.body)
        expect(node).to have_content('品川駅に到着')
        expect(node).to have_selector('img[alt="品川駅のイラスト"]')
      end
    end

    context '到着記録が存在しない場合' do
      it '404になること' do
        get arrival_path(id: 1)
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe '#edit' do
    let!(:login_user) { FactoryBot.create(:user) }

    context '到着記録が存在する場合' do
      let!(:walk) do
        FactoryBot.create(:walk, user: login_user, clockwise: true)
      end
      let!(:walk_user) { FactoryBot.create(:user) }
      let!(:arrival) { FactoryBot.create(:arrival, walk:, station_id: 1) }

      it '編集用のフォームが表示されること' do
        get edit_arrival_path(arrival)

        node = Capybara.string(response.body)
        expect(node).to have_field('メモ')
        expect(node).to have_button('保存')
      end
    end

    context '到着記録が存在しない場合' do
      let!(:login_user) { FactoryBot.create(:user) }

      it '404になること' do
        get edit_arrival_path(id: 1)
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe '#create' do
    let!(:login_user) { FactoryBot.create(:user) }
    let!(:walk) do
      FactoryBot.create(:walk, user: login_user, clockwise: true)
    end
    let(:arrival) { walk.arrivals.last }

    context '正しいパラメーターの場合' do
      let!(:arrival_params) { { station_id: 2, arrived_at: Time.current } }

      it '到着記録が作成されること' do
        expect do
          post arrivals_path, params: { arrival: arrival_params }
        end.to change(Arrival, :count).by(1)
        expect(response).to redirect_to arrival_path(arrival)
      end
    end

    context '不正なパラメーターの場合' do
      let!(:arrival_params) { { station_id: 0, arrived_at: Time.current } }

      it '到着記録が作成されないこと' do
        expect do
          post arrivals_path, params: { arrival: arrival_params }
        end.not_to change(Arrival, :count)
        expect(flash[:alert]).to eq('到着記録を保存できませんでした。')
      end
    end
  end

  describe '#update' do
    let!(:walk) do
      FactoryBot.create(:walk, user: walk_user, clockwise: true)
    end
    let!(:walk_user) { FactoryBot.create(:user) }
    let!(:arrival) { FactoryBot.create(:arrival, walk:, station_id: 1, memo: '更新前') }

    context 'ログイン中のユーザーが歩行中のユーザーの場合' do
      let!(:login_user) { walk_user }

      context '正しいパラメーターの場合' do
        let!(:arrival_params) { { arrived_at: Time.current, memo: '更新済み' } }

        it '到着記録が更新されること' do
          expect do
            patch arrival_path(arrival), params: { arrival: arrival_params }
          end.to change { arrival.reload.memo }.to('更新済み')
        end
      end

      context '不正なパラメーターの場合' do
        let!(:arrival_params) { { arrived_at: Time.current, memo: '長いメモ' * 200 } }

        it '到着記録が更新されないこと' do
          expect do
            patch arrival_path(arrival), params: { arrival: arrival_params }
          end.not_to(change { arrival.reload.memo })
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context 'ログイン中のユーザーが歩行中のユーザーでない場合' do
      let!(:login_user) { FactoryBot.create(:user, :with_walk) }
      let!(:arrival_params) { { arrived_at: Time.current, memo: '更新済み' } }

      it '到着記録が更新されず、404になること' do
        expect do
          patch arrival_path(arrival), params: { arrival: arrival_params }
        end.not_to(change { arrival.reload.memo })
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe '#destroy' do
    let!(:walk) do
      FactoryBot.create(:walk, user: walk_user, clockwise: true)
    end
    let!(:walk_user) { FactoryBot.create(:user) }
    let!(:arrival) { FactoryBot.create(:arrival, walk:, station_id: 1) }

    context 'ログイン中のユーザーが歩行中のユーザーの場合' do
      let!(:login_user) { walk_user }

      it '到着記録が削除されること' do
        expect do
          delete arrival_path(arrival)
        end.to change(Arrival, :count).by(-1)
      end
    end

    context 'ログイン中のユーザーが歩行中のユーザーでない場合' do
      let!(:login_user) { FactoryBot.create(:user, :with_walk) }

      it '到着記録が削除されず、404になること' do
        expect do
          delete arrival_path(arrival)
        end.not_to change(Arrival, :count)
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
