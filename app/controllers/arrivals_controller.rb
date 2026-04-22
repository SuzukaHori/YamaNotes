# frozen_string_literal: true

class ArrivalsController < ApplicationController
  before_action :set_walk, only: %i[index show]
  before_action :set_arrival, only: %i[show edit update destroy]
  before_action :set_user, only: %i[index]

  def index
    @arrivals = current_walk.arrivals.order(:created_at).includes(:station)
  end

  def show
    @station = @arrival.station
    @arrived_distance = @walk.arrived_distance
    @number_of_walked = @walk.number_of_walked
  end

  def edit; end

  def create
    @arrival = current_walk.arrivals.new(**arrival_params, arrived_at: Time.current)
    if @arrival.save
      redirect_to @arrival
    else
      redirect_to walk_path(current_walk), alert: t('arrivals.create.save_failed')
    end
  end

  def update
    @arrival.assign_attributes(arrival_params.except(:image))
    @arrival.attach_image(arrival_params[:image]) if arrival_params[:image]

    if @arrival.save
      flash.now.notice = t('arrivals.update.updated')
    else
      render 'edit', status: :unprocessable_content
    end
  end

  def destroy
    redirect_to arrivals_path if @arrival.destroy
  end

  private

  def set_arrival
    @arrival = current_user.arrivals.find(params[:id])
  end

  def set_user
    @user = current_user
  end

  def set_walk
    @walk = current_walk

    return if @walk

    redirect_to root_path, alert: t('arrivals.create.no_walk')
  end

  def arrival_params
    params.require(:arrival).permit(:station_id, :arrived_at, :memo, :image)
  end
end
