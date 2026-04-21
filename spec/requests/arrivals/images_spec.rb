# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Arrivals::Images', type: :request do
  let!(:walk_user) { FactoryBot.create(:user) }
  let!(:walk) { FactoryBot.create(:walk, user: walk_user, clockwise: true) }
  let!(:arrival) { FactoryBot.create(:arrival, walk:, station_id: 1) }

  before { sign_in login_user }

  describe '#destroy' do
    subject(:destroy_image) { delete arrival_image_path(arrival) }

    before { arrival.image.attach(fixture_file_upload('spec/fixtures/files/sample.jpg', 'image/jpeg')) }

    context '自分の到着記録の画像を削除する場合' do
      let(:login_user) { walk_user }

      it '画像が削除され、編集フォームにリダイレクトすること' do
        destroy_image
        expect(arrival.reload.image).not_to be_attached
        expect(response).to redirect_to(edit_arrival_path(arrival))
      end
    end

    context '他のユーザーの到着記録の場合' do
      let(:login_user) { FactoryBot.create(:user) }

      it '404になること' do
        destroy_image
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
