# frozen_string_literal: true

class Arrivals::ReportController < ApplicationController
  skip_before_action :authenticate_user!

  def show
    @arrival = Arrival.find(params[:arrival_id])
    @walk = @arrival.walk

    return if @walk.publish || (user_signed_in? && @walk.user == current_user)

    redirect_to root_path, notice: t('public.walks.arrivals.index.private')
  end
end
