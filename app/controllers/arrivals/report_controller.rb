# frozen_string_literal: true

class Arrivals::ReportController < ApplicationController
  skip_before_action :authenticate_user!

  def show
    @arrival = Arrival.find(params[:arrival_id])
  end
end
