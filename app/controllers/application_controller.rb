# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  helper_method :current_walk

  def current_walk
    # TODO: テストを直す
    return nil if current_user.walks.empty?

    current_user.walks.order(:created_at).last
  end
end
