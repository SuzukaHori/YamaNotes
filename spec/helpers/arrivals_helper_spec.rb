require 'rails_helper'

RSpec.describe ArrivalsHelper, type: :helper do
  let(:user) { FactoryBot.create(:user) }
  let(:walk) { user.create_walk(clockwise: true) }

  it '#total_distance' do
    create_arrivals(walk, 3)
    expect(helper.total_distance(walk.arrivals)).to eq(2.9)
  end

  it '#remaining_distance' do
    create_arrivals(walk, 3)
    expect(helper.remaining_distance(walk.arrivals)).to eq(31.6)
  end

  it '#number_of_walked' do
    create_arrivals(walk, 3)
    expect(helper.number_of_walked(walk.arrivals)).to eq(2)
  end

  it '#number_of_remaining' do
    create_arrivals(walk, 3)
    expect(helper.number_of_remaining(walk.arrivals)).to eq(28)
  end

  it '#deletable?' do
    allow(helper).to receive(:current_user).and_return(user)
    create_arrivals(walk, 3)
    expect(helper.deletable?(walk.arrivals.last, walk)).to be true
  end
end
