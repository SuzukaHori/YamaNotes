# frozen_string_literal: true

class Walks::DeactivationsController < ApplicationController
  before_action :set_walk

  def create
    @walk.update!(active: false)
    redirect_to new_walk_path, notice: @walk.finished? ? '歩行を完了しました。' : 'リタイアしました。'
  end

  private

  def set_walk
    @walk = current_user.walks.find(params[:walk_id])
  end
end
