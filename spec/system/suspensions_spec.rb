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
    suspend_walk
    expect(page).to have_text('歩行を中断しました。')
    expect(page).to have_text('中断中')
    expect(page).to have_no_button('到着')
  end

  it '再開すると到着ボタンが戻る' do
    suspend_walk
    click_on '再開する'
    expect(page).to have_text('歩行を再開しました。')
    expect(page).to have_button('到着')
    expect(page).to have_no_text('中断中')
  end

  it '理由を入力して中断すると、到着履歴に理由が表示される' do
    suspend_walk(reason: '昼食休憩')
    expect(page).to have_text('歩行を中断しました。')
    visit arrivals_path
    expect(page).to have_text('昼食休憩')
  end

  it '到着履歴から中断の開始時刻を編集できる' do
    walk.arrival_of_departure.update!(arrived_at: 3.hours.ago)
    suspend_walk
    click_on '再開する'
    visit arrivals_path
    edit_suspension_start_time(walk.suspensions.take, 1.hour.ago)
    expect(page).to have_text('中断を更新しました')
  end

  it '到着履歴から中断を削除できる' do
    suspend_walk
    click_on '再開する'
    visit arrivals_path

    within "turbo-frame#suspension_#{walk.suspensions.take.id}" do
      accept_confirm { click_on '削除' }
    end
    expect(page).to have_no_text('中断')
  end

  private

  def suspend_walk(reason: nil)
    click_on 'suspension_modal_button'
    fill_in 'suspension_reason', with: reason if reason
    within('dialog[open]') { click_on '中断する' }
  end

  def edit_suspension_start_time(suspension, target)
    within "turbo-frame#suspension_#{suspension.id}" do
      click_on '編集'
      select format('%02d', target.hour), from: 'suspension_started_at_4i'
      select format('%02d', target.min), from: 'suspension_started_at_5i'
      click_on '保存'
    end
  end
end
