# rake change_uid_to_string:change_uid_to_string

namespace :change_uid_to_string do
  desc "Userテーブルのuidをstringに変更するタスク"
  task change_uid_to_string: :environment do
    puts "User#{User.count}件のuidの修正作業を開始"

    ActiveRecord::Base.transaction do
      User.find_each do |user|
        uid = user.uid
        user.update!(uid: uid.to_i.to_s)
        p "user: #{uid} → #{user.uid} updated"
      end
    end

    puts "User#{User.count}件のuidの修正作業を終了"
  end
end
