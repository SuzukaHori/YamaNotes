# frozen_string_literal: true

class Walk::ArrivalsController < ApplicationController
  # 公開ページのURL変更に伴い、一時的にスキップしている
  # リダイレクト処理が使われていないことを確認したら削除する
  skip_before_action :authenticate_user!

  before_action :set_walk, only: %i[index]
  # 公開ページのURL変更に伴い、一時的にリダイレクトしている
  before_action :redirect_unless_walk_user, only: %i[index]

  def index
    @arrivals = @walk.arrivals.order(:created_at).includes(:station)
  end

  private

  def set_walk
    @walk = Walk.find(params[:walk_id])
  end

  def redirect_unless_walk_user
    return if user_signed_in? && @walk.user == current_user

    redirect_to public_walk_arrivals_url(@walk)
  end
end
