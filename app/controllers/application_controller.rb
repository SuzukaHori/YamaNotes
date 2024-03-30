# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def current_walk
    current_user.walk
  end
end
