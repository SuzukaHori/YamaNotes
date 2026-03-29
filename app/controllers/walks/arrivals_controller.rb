# frozen_string_literal: true

class Walks::ArrivalsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :set_walk

  def index
    @arrivals = @walk.arrivals.order(:created_at).includes(:station)
  end

  private

  def set_walk
    if user_signed_in?
      @walk = current_user.walks.find(params[:walk_id])
    else
      walk = Walk.find_by!(id: params[:walk_id], publish: true)
      redirect_to public_walk_arrivals_url(walk)
    end
  end
end
