# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include Devise::Controllers::Rememberable
  skip_before_action :verify_authenticity_token, only: %i[google_oauth2 failure]
  skip_before_action :authenticate_user!
  before_action :redirect_if_already_logged_in

  def google_oauth2
    auth = request.env['omniauth.auth']
    @user = User.find_or_create_by(provider: auth.provider, uid: auth.uid)
    if @user.persisted?
      request.env['devise.mapping'] = Devise.mappings[:user]
      request.env['omniauth.auth'] = auth
      remember_me(@user)
      sign_in @user, event: :authentication
    else
      session['devise.google_oauth2_data'] = request.env['omniauth.auth'].except(:extra)
    end
    set_flash_message(:notice, :success, kind: 'Google') if is_navigational_format?
    redirect_to @user.active_walk.present? ? walk_path(@user.active_walk) : new_walk_path
  end

  def failure
    error = request.env['omniauth.error']
    error_type = request.env['omniauth.error.type']

    Rails.logger.error "OmniAuth認証失敗: #{error.message} (Type: #{error_type})"

    flash[:alert] = '認証に失敗しました。もう一度お試しください。'
    redirect_to root_path
  end

  private

  def redirect_if_already_logged_in
    return unless user_signed_in?

    alert = 'すでにログインしています。'
    if current_walk
      redirect_to walk_path, alert: alert
    else
      redirect_to new_walk_path, alert: alert
    end
  end
end
