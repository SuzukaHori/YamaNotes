class StaticsController < ApplicationController
  def top
    if user_signed_in?
      redirect_to walk_url
    end
  end
end
