# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  around_action :switch_locale
  helper_method :current_walk

  # 現在実施中の歩行を返す
  # active: true の歩行は一度に一つしか持てない仕様
  def current_walk
    return nil unless user_signed_in?

    @current_walk ||= current_user.walks.find_by(active: true)
  end

  private

  def switch_locale(&action)
    locale = params[:locale]
    if I18n.available_locales.map(&:to_s).include?(locale)
      I18n.with_locale(locale, &action)
    else
      I18n.with_locale(I18n.default_locale, &action)
    end
  end

  def default_url_options
    I18n.locale == I18n.default_locale ? {} : { locale: I18n.locale }
  end
end
