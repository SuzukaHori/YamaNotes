# frozen_string_literal: true

namespace :stations do
  desc '駅の key カラムにローマ字キーを挿入する'
  task set_keys: :environment do
    keys = {
      1  => 'shinagawa',
      2  => 'osaki',
      3  => 'gotanda',
      4  => 'meguro',
      5  => 'ebisu',
      6  => 'shibuya',
      7  => 'harajuku',
      8  => 'yoyogi',
      9  => 'shinjuku',
      10 => 'shin_okubo',
      11 => 'takadanobaba',
      12 => 'mejiro',
      13 => 'ikebukuro',
      14 => 'otsuka',
      15 => 'sugamo',
      16 => 'komagome',
      17 => 'tabata',
      18 => 'nishi_nippori',
      19 => 'nippori',
      20 => 'uguisudani',
      21 => 'ueno',
      22 => 'okachimachi',
      23 => 'akihabara',
      24 => 'kanda',
      25 => 'tokyo',
      26 => 'yurakucho',
      27 => 'shimbashi',
      28 => 'hamamatsucho',
      29 => 'tamachi',
      30 => 'takanawa_gateway'
    }

    keys.each do |id, key|
      station = Station.find_by(id:)
      if station
        station.update_column(:key, key)
        puts "#{station.name}: key = #{key}"
      else
        puts "ID #{id} の駅が見つかりません"
      end
    end

    puts '完了'
  end
end
