class WelcomeController < ApplicationController
  # Public: general welcome page
  #
  # redirects to homepage if a current member is logged into the session
  def index
    # The commented-out line below is the only line that needs to exist in this method, but
    # it is being removed for now as a way to bypass the email authentication process, which
    # is currently not working. Therefore, as a workaround, instead of worrying about authentication
    # at all, when a user hits the homepage, they will be logged in as the first user in the database.
    # This is being done to demonstrate the application's functionality beyond the scope of email
    # authentication.
    #
    #   redirect_to(teams_path) if current_user
    session[:user_id] = User.first.id unless current_user
    redirect_to(teams_path)
  end
end
