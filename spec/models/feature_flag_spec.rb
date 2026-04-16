# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FeatureFlag, type: :model do
  describe '.enabled?' do
    context 'フラグが存在しない場合' do
      it 'false を返すこと' do
        expect(FeatureFlag.enabled?(:nonexistent)).to be false
      end
    end

    context 'フラグが enabled: true の場合' do
      before { FeatureFlag.create!(name: 'test_feature', enabled: true) }

      it 'true を返すこと' do
        expect(FeatureFlag.enabled?(:test_feature)).to be true
      end
    end

    context 'フラグが enabled: false の場合' do
      before { FeatureFlag.create!(name: 'test_feature', enabled: false) }

      it 'false を返すこと' do
        expect(FeatureFlag.enabled?(:test_feature)).to be false
      end
    end
  end

  describe '.enable!' do
    context 'フラグが存在しない場合' do
      it 'レコードを作成してフラグを有効にすること' do
        FeatureFlag.enable!(:new_feature)
        expect(FeatureFlag.enabled?(:new_feature)).to be true
      end
    end

    context 'フラグが disabled の場合' do
      before { FeatureFlag.create!(name: 'new_feature', enabled: false) }

      it 'フラグを有効にすること' do
        FeatureFlag.enable!(:new_feature)
        expect(FeatureFlag.enabled?(:new_feature)).to be true
      end
    end
  end

  describe '.disable!' do
    context 'フラグが存在しない場合' do
      it 'レコードを作成してフラグを無効にすること' do
        FeatureFlag.disable!(:new_feature)
        expect(FeatureFlag.enabled?(:new_feature)).to be false
      end
    end

    context 'フラグが enabled の場合' do
      before { FeatureFlag.create!(name: 'new_feature', enabled: true) }

      it 'フラグを無効にすること' do
        FeatureFlag.disable!(:new_feature)
        expect(FeatureFlag.enabled?(:new_feature)).to be false
      end
    end
  end
end
