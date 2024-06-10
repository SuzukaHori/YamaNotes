# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ArrivalsHelper, type: :helper do
  let(:user) { FactoryBot.create(:user) }
  let(:walk) { user.create_walk(clockwise: true) }

  it '#remaining_distance' do
    create_arrivals(walk, 3)
    expect(helper.remaining_distance(arrived_distance: walk.arrived_distance)).to eq(Station.total_distance - 2.9)
  end

  it '#number_of_remaining' do
    create_arrivals(walk, 3)
    expect(helper.number_of_remaining(number_of_walked: walk.number_of_walked)).to eq(Station.cache_count - 2)
  end

  it '#deletable?' do
    allow(helper).to receive(:current_user).and_return(user)
    create_arrivals(walk, 3)
    expect(helper.deletable?(editable: true, arrival: walk.arrivals.order(:created_at).last, arrivals: walk.arrivals)).to be true
  end
end
