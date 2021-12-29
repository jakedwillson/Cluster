class HomeController < ApplicationController
  before_action :set_home, only: [:show]

  # Public: takes a user_id parameter to render a user homepage
  #
  # returns nothing
  def show
    @user = current_user
  end

  private
    # Private: ensures that current user in the session is viewing personal homepage
    #
    # redirects to login otherwise
    def set_home
      redirect_to(root_url) unless current_user
      redirect_to(teams_path)
    end
end
