# frozen_string_literal: true

# Chrome 158 以降は、Capybara 3.40.0 の ChromeDriver#reset! が
# Storage.clearDataForOrigin に渡す origin: '*' を
# "invalid argument: * is not a valid URL" として拒否する。
# '*' での呼び出しだけを、ワイルドカードを使わない後始末に置き換える。
# Capybara 本家 Issue #2865 で修正待ち。修正版がリリースされたらこのファイルを削除する。
module ChromeResetWithoutWildcardOrigin
  private

  def execute_cdp(cmd, params = {})
    return super unless cmd == 'Storage.clearDataForOrigin' && params[:origin] == '*'

    super('Network.clearBrowserCookies')

    server = Capybara.current_session.server
    return unless server && params[:storageTypes].include?('local_storage')

    super(cmd, { origin: server.base_url, storageTypes: 'local_storage' })
  end
end

Capybara::Selenium::Driver::ChromeDriver.prepend(ChromeResetWithoutWildcardOrigin)
