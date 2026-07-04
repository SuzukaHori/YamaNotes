# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Suspensions', :js, type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let(:walk) { user.walks.take }

  before do
    sign_in user
    start_walk
    visit walk_path(walk)
  end

  it '中断すると到着ボタンが消え、中断中ラベルが表示される' do
    click_on '中断する'
    expect(page).to have_text('歩行を中断しました。')
    expect(page).to have_text('中断中')
    expect(page).to have_no_button('到着')
  end

  it '再開すると到着ボタンが戻る' do
    click_on '中断する'
    click_on '再開する'
    expect(page).to have_text('歩行を再開しました。')
    expect(page).to have_button('到着')
    expect(page).to have_no_text('中断中')
  end
end
