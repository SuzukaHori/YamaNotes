class WalksController < ApplicationController
  def show
    @walk = current_user.walk
  end

  def new
    @walk = Walk.new
  end

  def create
    if current_user.walk.present?
      flash[:notice] = "Walkは一つしか作成できません"
      redirect_to walk_url
    else
      @walk = current_user.build_walk
      @walk.clockwise = params[:clockwise]
      if @walk.save
        flash[:success] = 'Walk was successfully created.'
        redirect_to walk_url
      else
        render :new, status: :unprocessable_entity
      end
    end
  end

  def update; end

  def delete; end

  private

  def walk_params
    params.require(:walk).permit(:user_id, :clockwise)
  end
end