class ArrivalsController < ApplicationController
  def create
    arrivals = current_user.walk.arrivals
    if arrivals.find_by(station_id: params[:station_id]) && arrivals.find_by(station_id: params[:station_id]).arrived_at.nil?
      @arrival = arrivals.find_by(station_id: params[:station_id])
      @arrival.arrived_at = Time.current
    else
      @arrival = arrivals.new(station_id: params[:station_id], arrived_at: Time.current)
    end
    if @arrival.valid? && @arrival.save!
      flash[:notice] = "Sucess"
      redirect_to new_arrival_path
    else
      flash[:alert] = "Failed"
      redirect_to walk_url
    end
  end
end
