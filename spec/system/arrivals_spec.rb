# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'Arrivals_examples' do |clockwise|
  let(:user) { FactoryBot.create(:user) }
  let(:walk) { user.walks.create(clockwise:) }

  before do
    sign_in user
  end

  it '歩行を開始する' do
    expect do
      start_walk(clockwise:)
    end.to change(Arrival, :count).by(1)
  end
end

RSpec.describe 'Arrivals', type: :system do
  context '外回りモードの場合' do
    include_examples 'Arrivals_examples', clockwise: true
  end

  context '内回りモードの場合' do
    include_examples 'Arrivals_examples', clockwise: false
  end
end
