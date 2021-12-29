class SessionsController < ApplicationController
  before_action :send_home_if_logged_in, only: [:new, :create]

  # Public: renders an authentication prompt
  #
  # returns nothing
  def new
    redirect_to(home_url) if current_user
  end

  # Public: authenticates user in the current session and redirects to home page
  #
  # flashes error if authentication invalid
  def create
    user = User.find_by_email(params[:email])
    if user && user.password == params[:password]
      if user.confirmed_at
        session[:user_id] = user.id
        return redirect_to(home_url, notice: "Welcome #{user.username}!")
      end
      flash.now[:error] = 'Please activate your account by following the
      instructions in the account confirmation email you received to proceed'
      return render "new"
    end
    flash.now[:alert] = I18n.t('controller.sessions.alerts.invalid_email_or_password')
    render "new"
  end

  # Public: signs user out of session and redirects to root_url
  #
  # returns nothing
  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: I18n.t('controller.sessions.notices.logged_out')
  end

  private
    def send_home_if_logged_in
      redirect_to(home_url) if current_user
    end
end