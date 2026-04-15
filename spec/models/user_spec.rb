# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーション' do
    describe ':uid' do
      it '数字のみの文字列は有効であること' do
        user = FactoryBot.build(:user, uid: '123456789012345678901')
        expect(user).to be_valid
      end

      it '空は無効であること' do
        user = FactoryBot.build(:user, uid: '')
        expect(user).to be_invalid
        expect(user.errors[:uid]).to be_present
      end

      it '数字以外を含む文字列は無効であること' do
        user = FactoryBot.build(:user, uid: 'abc123')
        expect(user).to be_invalid
      end

      it 'ハイフンを含む文字列は無効であること' do
        user = FactoryBot.build(:user, uid: '123-456')
        expect(user).to be_invalid
      end

      it '同じ provider + uid の組み合わせは重複エラーになること' do
        FactoryBot.create(:user, uid: '10000000001', provider: 'google_oauth2')
        duplicate = FactoryBot.build(:user, uid: '10000000001', provider: 'google_oauth2')
        expect(duplicate).to be_invalid
        expect(duplicate.errors[:uid]).to be_present
      end
    end
  end
end
