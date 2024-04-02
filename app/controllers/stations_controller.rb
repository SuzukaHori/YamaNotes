class StationsController < ApplicationController
  before_action :authenticate_user!

  def index
    stations = Station.all
    render json: stations
  end
end
