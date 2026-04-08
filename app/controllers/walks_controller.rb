# frozen_string_literal: true

class WalksController < ApplicationController
  before_action :set_walk, only: %i[show destroy edit update]
  before_action :set_maptiler_key, only: %i[show]
  before_action :redirect_if_walk_not_exist, only: %i[show]

  def index
    @walks = current_user.walks.includes(:arrivals).order(id: :desc)
  end

  def show
    @arrival = Arrival.new
    @arrivals = @walk.arrivals.order(:created_at).pluck(:station_id)
    @station = @walk.current_station
    @arrived_distance = @walk.arrived_distance
    @number_of_walked = @walk.number_of_walked
  end

  def edit; end

  def new
    @walk = Walk.new
    @arrival = @walk.arrivals.new
  end

  def create
    walk = Walk.new(**walk_params, user: current_user)
    if walk.invalid?
      redirect_to walk_path(current_walk), alert: walk.errors.full_messages.join
      return
    end

    walk.transaction do
      walk.save!
      walk.arrivals.create!(**arrival_params, arrived_at: Time.current)
    end
    redirect_to walk_path(walk), notice: t('.created')
  end

  def destroy
    if @walk.active?
      redirect_to walks_path, alert: t('.cannot_delete_active')
      return
    end

    @walk.destroy!
    redirect_to walks_path, notice: t('.deleted')
  end

  def update
    @walk.update!(walk_params)

    redirect_to edit_walk_path(@walk), notice: @walk.publish ? t('.published') : t('.unpublished')
  end

  private

  def redirect_if_walk_not_exist
    return unless current_walk.nil?

    redirect_to new_walk_path
  end

  def walk_params
    params.require(:walk).permit(:clockwise, :publish)
  end

  def arrival_params
    params.require(:arrival).permit(:station_id, :arrived_at, :memo)
  end

  def set_walk
    @walk = current_user.walks.find(params[:id])
  end

  def set_maptiler_key
    gon.maptiler_key = ENV.fetch('MAPTAILER_KEY', nil)
  end
end
