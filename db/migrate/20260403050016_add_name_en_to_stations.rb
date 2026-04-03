class AddNameEnToStations < ActiveRecord::Migration[8.1]
  ENGLISH_NAMES = {
    1  => "Shinagawa",
    2  => "Osaki",
    3  => "Gotanda",
    4  => "Meguro",
    5  => "Ebisu",
    6  => "Shibuya",
    7  => "Harajuku",
    8  => "Yoyogi",
    9  => "Shinjuku",
    10 => "Shin-Okubo",
    11 => "Takadanobaba",
    12 => "Mejiro",
    13 => "Ikebukuro",
    14 => "Otsuka",
    15 => "Sugamo",
    16 => "Komagome",
    17 => "Tabata",
    18 => "Nishi-Nippori",
    19 => "Nippori",
    20 => "Uguisudani",
    21 => "Ueno",
    22 => "Okachimachi",
    23 => "Akihabara",
    24 => "Kanda",
    25 => "Tokyo",
    26 => "Yurakucho",
    27 => "Shimbashi",
    28 => "Hamamatsucho",
    29 => "Tamachi",
    30 => "Takanawa Gateway"
  }.freeze

  def up
    add_column :stations, :name_en, :string

    ENGLISH_NAMES.each do |id, name_en|
      execute "UPDATE stations SET name_en = #{connection.quote(name_en)} WHERE id = #{id}"
    end
  end

  def down
    remove_column :stations, :name_en
  end
end
