# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  helper_method :current_walk

  # 現在実施中の歩行を返す
  # active: true の歩行は一度に一つしか持てない仕様
  def current_walk
    return nil unless user_signed_in?

    @current_walk ||= current_user.walks.find_by(active: true)
  end
end
