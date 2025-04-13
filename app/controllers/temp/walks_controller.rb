# frozen_string_literal: true

class Temp::WalksController < ApplicationController
  # URL変更のため一時的に定義しているが、後に削除する
  def show
    redirect_to current_walk
  end
end
