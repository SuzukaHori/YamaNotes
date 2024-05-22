# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ArrivalsHelper, type: :helper do
  let(:user) { FactoryBot.create(:user) }
  let(:walk) { user.create_walk(clockwise: true) }

  it '#arrived_distance' do
    create_arrivals(walk, 3)
    expect(helper.arrived_distance(walk.arrivals)).to eq(2.9)
  end

  it '#remaining_distance' do
    create_arrivals(walk, 3)
    expect(helper.remaining_distance(walk.arrivals)).to eq(Station.total_distance - 2.9)
  end

  it '#number_of_walked' do
    create_arrivals(walk, 3)
    expect(helper.number_of_walked(walk.arrivals)).to eq(2)
  end

  it '#number_of_remaining' do
    create_arrivals(walk, 3)
    expect(helper.number_of_remaining(walk.arrivals)).to eq(Station.count - 2)
  end

  it '#deletable?' do
    allow(helper).to receive(:current_user).and_return(user)
    create_arrivals(walk, 3)
    expect(helper.deletable?(walk.arrivals.order(:created_at).last, walk)).to be true
  end
end
