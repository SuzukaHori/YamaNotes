require 'rails_helper'

RSpec.describe 'Users/Arrivals', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @walk = @user.build_walk(publish: true)
    @walk.save!
    10.times do |n|
      @walk.arrivals.create!(station_id: n + 1, arrived_at: Time.current)
    end
  end

  scenario '公開状態の到着履歴にアクセスする' do
    visit public_arrivals_path(@user)
    expect(page).to have_content('品川駅')
  end

  scenario '未公開状態の到着履歴にアクセスする' do
    @walk.update!(publish: false)
    visit public_arrivals_path(@user)
    expect(page).to_not have_content('品川駅')
    expect(page).to have_content('この到着記録は非公開です')
  end

  scenario '未公開状態の到着履歴に作成者本人がアクセスする' do
    @walk.update!(publish: false)
    sign_in @user
    visit public_arrivals_path(@user)
    expect(page).to have_content('品川駅')
  end
end
