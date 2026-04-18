# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Arrival::Image, type: :model do
  let!(:walk) { FactoryBot.create(:walk) }
  let!(:arrival) { FactoryBot.create(:arrival, walk:, station_id: 1) }

  describe '#image_content_type_must_be_valid' do
    it 'PNG 画像を添付できること' do
      arrival.image.attach(fixture_file_upload('sample.png', 'image/png'))
      expect(arrival).to be_valid
    end

    it 'JPEG 画像を添付できること' do
      arrival.image.attach(fixture_file_upload('sample.jpg', 'image/jpeg'))
      expect(arrival).to be_valid
    end

    it 'PNG/JPEG 以外のファイルを添付できないこと' do
      arrival.image.attach(fixture_file_upload('sample.gif', 'image/gif'))
      expect(arrival).not_to be_valid
      expect(arrival.errors[:image].join).to include 'はPNGまたはJPEG形式のファイルを選択してください'
    end
  end

  describe '#image_size_must_be_within_limit' do
    it '5MB より小さいファイルを添付できること' do
      arrival.image.attach(fixture_file_upload('sample.png', 'image/png'))
      expect(arrival).to be_valid
    end

    it 'ちょうど 5MB のファイルを添付できること' do
      arrival.image.attach(
        io: StringIO.new('a' * 5.megabytes),
        filename: 'exact.png',
        content_type: 'image/png'
      )
      expect(arrival).to be_valid
    end

    it '5MB を超えるファイルを添付できないこと' do
      arrival.image.attach(
        io: StringIO.new('a' * (5.megabytes + 1)),
        filename: 'large.png',
        content_type: 'image/png'
      )
      expect(arrival).not_to be_valid
      expect(arrival.errors[:image].join).to include 'は5MB以下のファイルを選択してください'
    end
  end

  describe '#attach_image' do
    context '400x400 を超える JPEG の場合' do
      it 'WebP に変換・リサイズされて保存されること' do
        original_size = File.size(Rails.root.join('spec/fixtures/files/large.jpg'))
        arrival.attach_image(fixture_file_upload('large.jpg', 'image/jpeg'))
        expect(arrival.image).to be_attached
        expect(arrival.image.blob.content_type).to eq 'image/webp'
        expect(arrival.image.blob.byte_size).to be < original_size
      end
    end

    context '400x400 以下の画像の場合' do
      it 'WebP に変換されて保存されること' do
        arrival.attach_image(fixture_file_upload('sample.jpg', 'image/jpeg'))
        expect(arrival.image).to be_attached
        expect(arrival.image.blob.content_type).to eq 'image/webp'
      end
    end

    context 'PNG 画像の場合' do
      it 'WebP に変換されて保存されること' do
        arrival.attach_image(fixture_file_upload('sample.png', 'image/png'))
        expect(arrival.image).to be_attached
        expect(arrival.image.blob.content_type).to eq 'image/webp'
      end
    end

    context 'GIF 画像の場合' do
      it 'リサイズせずそのまま添付し、バリデーションエラーになること' do
        arrival.attach_image(fixture_file_upload('sample.gif', 'image/gif'))
        expect(arrival).not_to be_valid
        expect(arrival.errors[:image].join).to include 'はPNGまたはJPEG形式のファイルを選択してください'
      end
    end
  end
end
