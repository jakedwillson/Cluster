class ApplicationController < ActionController::Base
  helper_method :current_user

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # allows additional parameters during account setup and update
  before_action :configure_permitted_parameters, if: :devise_controller?

  # Public: returns the current user in the session and sets the instance variable
  #
  # returns nil if user does not yet have an account
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by_id(session[:user_id])
    else
      @current_user = nil
    end
  end

  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :email, :password, :username])
      devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :email, :password, :current_password, :username])
      devise_parameter_sanitizer.permit(:accept_invitation, keys: [:first_name, :last_name, :phone, :email, :username])
    end
end
