# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ActiveStorage::DirectUploads', type: :request do
  describe 'POST /rails/active_storage/direct_uploads' do
    subject(:post_direct_upload) do
      post rails_direct_uploads_path,
           params: { blob: { filename: 'test.png', byte_size: 10, checksum: 'dummy', content_type: 'image/png' } },
           as: :json
    end

    it '404 を返し、Blob を作成しない' do
      expect { post_direct_upload }.not_to change(ActiveStorage::Blob, :count)
      expect(response).to have_http_status(:not_found)
    end
  end
end
