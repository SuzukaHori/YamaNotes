# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IconHelper, type: :helper do
  describe '#icon_svg' do
    it 'クラス属性を付与したSVGファイルの内容を返すこと' do
      result = helper.icon_svg('x_mark', class: 'w-6 h-6')
      expect(result).to include('<svg class="w-6 h-6"')
      expect(result).to include('</svg>')
    end
  end
end
