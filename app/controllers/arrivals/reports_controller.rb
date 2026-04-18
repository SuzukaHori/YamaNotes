# frozen_string_literal: true

class Arrivals::ReportsController < ApplicationController
  skip_before_action :authenticate_user!

  def show
    @arrival = Arrival.find(params[:arrival_id])
    @walk = @arrival.walk
  end
end
