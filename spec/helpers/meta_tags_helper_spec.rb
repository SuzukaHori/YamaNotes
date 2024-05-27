# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MetaTagsHelper, type: :helper do
  it '#default_meta_tags' do
    tag = default_meta_tags
    expect(tag[:site]).to eq('YamaNotes')
    expect(tag[:description]).to eq('山手線一周に徒歩で挑戦する人のための記録アプリ')
    expect(tag[:twitter][:image]).to include('ogp.png')
  end
end
