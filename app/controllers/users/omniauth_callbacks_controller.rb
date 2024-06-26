# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: :google_oauth2
  skip_before_action :authenticate_user!

  def google_oauth2
    auth = request.env['omniauth.auth']
    @user = User.find_or_create_by(provider: auth.provider, uid: auth.uid)
    if @user.persisted?
      sign_in @user
    else
      session['devise.google_oauth2_data'] = request.env['omniauth.auth'].except(:extra)
    end
    set_flash_message(:notice, :success, kind: 'Google') if is_navigational_format?
    redirect_to @user.walk ? walk_path : new_walk_path
  end

  def failure
    redirect_to root_path
  end
end
