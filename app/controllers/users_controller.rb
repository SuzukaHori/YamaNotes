# frozen_string_literal: true

class UsersController < ApplicationController
  def destroy
    current_user.destroy!
    redirect_to root_url, notice: t('.withdrawn')
  end
end
