# frozen_string_literal: true

class SuspensionsController < ApplicationController
  before_action :set_suspension

  def edit; end

  def update
    if @suspension.update(suspension_params)
      flash.now.notice = t('suspensions.update.updated')
    else
      render 'edit', status: :unprocessable_content
    end
  end

  def destroy
    redirect_to arrivals_path if @suspension.destroy
  end

  private

  def set_suspension
    @suspension = current_user.suspensions.where(walks: { active: true }).find(params[:id])
    raise ActiveRecord::RecordNotFound if @suspension.walk.finished?
  end

  def suspension_params
    params.require(:suspension).permit(:started_at, :ended_at)
  end
end
