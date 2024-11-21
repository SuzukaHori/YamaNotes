# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  helper_method :current_walk

  def current_walk
    current_user&.active_walk
  end
end
