class StaticsController < ApplicationController
  def top
    return unless user_signed_in?

    redirect_to walk_url
  end
end
