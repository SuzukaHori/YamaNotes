# frozen_string_literal: true

class Tmp::Walks::ArrivalsController < ApplicationController
  skip_before_action :authenticate_user!
  # URL変更のため一時的に定義しているが、後に削除する

  def index
    walk = Walk.find_by!(id: params[:walk_id], publish: true)
    redirect_to public_walk_arrivals_url(walk)
  end
end
