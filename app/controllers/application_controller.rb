# frozen_string_literal: true

class ApplicationController < ActionController::Base
  around_action :switch_locale
  before_action :authenticate_user!
  helper_method :current_walk

  # 現在実施中の歩行を返す
  # active: true の歩行は一度に一つしか持てない仕様
  def current_walk
    return nil unless user_signed_in?

    @current_walk ||= current_user.walks.find_by(active: true)
  end

  def switch_locale(&action)
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  def default_url_options
    { locale: I18n.locale }
  end
end
