# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  def current_walk
    current_user&.walk
  end
end
