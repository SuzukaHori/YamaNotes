# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :set_locale
  helper_method :current_walk

  # 現在実施中の歩行を返す
  # active: true の歩行は一度に一つしか持てない仕様
  def current_walk
    return nil unless user_signed_in?

    @current_walk ||= current_user.walks.find_by(active: true)
  end

  private

  def set_locale
    I18n.locale = extract_locale || I18n.default_locale
  end

  def extract_locale
    parsed = params[:locale]&.to_sym
    parsed if I18n.available_locales.include?(parsed)
  end
end
