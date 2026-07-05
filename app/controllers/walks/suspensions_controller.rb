# frozen_string_literal: true

class Walks::SuspensionsController < ApplicationController
  before_action :set_walk

  def create
    suspension = @walk.suspensions.new(suspension_params.merge(started_at: Time.current))
    if suspension.save
      redirect_to walk_path(@walk), notice: t('.suspended')
    else
      redirect_to walk_path(@walk), alert: suspension.errors.full_messages.join
    end
  end

  def update
    suspension = @walk.ongoing_suspension
    if suspension.nil?
      redirect_to walk_path(@walk), alert: t('.not_suspended')
      return
    end

    suspension.update!(ended_at: Time.current)
    redirect_to walk_path(@walk), notice: t('.resumed')
  end

  private

  def set_walk
    @walk = current_user.walks.find(params[:walk_id])
  end

  def suspension_params
    params.fetch(:suspension, ActionController::Parameters.new).permit(:reason)
  end
end
