# frozen_string_literal: true

# Active Storage が自動で定義する POST /rails/active_storage/direct_uploads を無効化する。
# このアプリはダイレクトアップロードを使用しておらず、認証なしで叩けるため閉じておく。
# draw_routes = false にすると画像表示に必要な blobs/redirect ルートまで消えるため、コントローラー単位で無効化する。
Rails.application.config.to_prepare do
  ActiveStorage::DirectUploadsController.before_action { head :not_found }
end
