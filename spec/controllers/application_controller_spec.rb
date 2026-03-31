# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  include Devise::Test::ControllerHelpers

  controller do
    def index; end
  end

  describe '#current_walk' do
    context 'ユーザーがサインインしていない場合' do
      it 'nilを返す' do
        expect(controller.current_walk).to be_nil
      end
    end

    context 'ユーザーがサインインしている場合' do
      let(:user) { FactoryBot.create(:user) }

      before { sign_in user }

      context '歩行記録が存在しない場合' do
        it 'nilを返す' do
          expect(controller.current_walk).to be_nil
        end
      end

      context '無効な記録のみ存在する場合' do
        let!(:walk) { FactoryBot.create(:walk, user:, active: false) }

        it 'nilを返す' do
          expect(controller.current_walk).to be_nil
        end
      end

      context '実施中の歩行が存在する場合' do
        let!(:walk) { FactoryBot.create(:walk, user:, active: true) }

        it '実施中の歩行を返す' do
          expect(controller.current_walk).to eq(walk)
        end
      end
    end
  end
end
