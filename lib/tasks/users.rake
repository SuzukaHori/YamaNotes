# frozen_string_literal: true

namespace :users do
  desc 'uid カラムを decimal から string に変換する前の安全確認'
  task verify_uid_migration: :environment do
    puts 'uid の移行前検証を開始します...'

    errors = []
    total  = User.count
    puts "対象ユーザー数: #{total}"

    User.find_each do |user|
      uid_as_string = user.uid.to_i.to_s

      errors << "ID #{user.id}: uid=#{user.uid.inspect} は数字のみの文字列に変換できません" unless uid_as_string.match?(/\A\d+\z/)
    end

    if errors.empty?
      puts "検証完了: #{total} 件すべて問題なし。マイグレーションを実行できます。"
    else
      puts "検証失敗: #{errors.size} 件の問題が見つかりました。マイグレーションを中止してください。"
      errors.each { |e| puts "  - #{e}" }
      exit 1
    end
  end
end
