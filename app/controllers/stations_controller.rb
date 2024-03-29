class StationsController < ApplicationController
  def index
    stations = Station.all
    render json: stations
  end
end
