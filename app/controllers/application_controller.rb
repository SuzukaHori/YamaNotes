# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  helper_method :current_walk

  def current_walk
    return nil unless user_signed_in?

    current_user.walks.find_by(active: true)
  end
end
