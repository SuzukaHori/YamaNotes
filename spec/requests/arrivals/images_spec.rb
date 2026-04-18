# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Arrivals::Images', type: :request do
  let!(:login_user) { FactoryBot.create(:user) }
  let!(:walk) { FactoryBot.create(:walk, user: login_user, clockwise: true) }
  let!(:arrival) { FactoryBot.create(:arrival, walk:, station_id: 1) }

  before { sign_in login_user }

  describe '#create' do
    subject(:create_image) { post arrival_image_path(arrival), params: { image: } }

    context '画像を添付できる場合' do
      let(:image) { fixture_file_upload('spec/fixtures/files/sample.jpg', 'image/jpeg') }

      it '画像が添付され、到着一覧にリダイレクトすること' do
        create_image
        expect(arrival.reload.image).to be_attached
        expect(response).to redirect_to(arrivals_path)
        expect(flash[:notice]).to eq('画像を追加しました。')
      end
    end

    context '画像を添付できない場合' do
      context 'PNG/JPEG以外のファイルの場合' do
        let(:image) { fixture_file_upload('spec/fixtures/files/sample.gif', 'image/gif') }

        it '画像が添付されず、エラーメッセージとともに到着一覧にリダイレクトすること' do
          create_image
          expect(arrival.reload.image).not_to be_attached
          expect(response).to redirect_to(arrivals_path)
          expect(flash[:alert]).to include('画像はPNGまたはJPEG形式のファイルを選択してください')
        end
      end

      context '他のユーザーの到着記録の場合' do
        let!(:other_arrival) { FactoryBot.create(:arrival, walk: FactoryBot.create(:walk, clockwise: true), station_id: 1) }
        let(:image) { fixture_file_upload('spec/fixtures/files/sample.jpg', 'image/jpeg') }

        subject(:create_image) { post arrival_image_path(other_arrival), params: { image: } }

        it '404になること' do
          create_image
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end
end
