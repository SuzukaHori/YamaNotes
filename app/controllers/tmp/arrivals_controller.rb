# frozen_string_literal: true

class Tmp::ArrivalsController < ApplicationController
  skip_before_action :authenticate_user!
  # URL変更のため一時的に定義しているが、後に削除する

  def index
    user = User.find(params[:user_id])
    walk = user.walks.order(:created_at).first!
    redirect_to walk_arrivals_url(walk)
  end
end
