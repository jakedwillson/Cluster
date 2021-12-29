class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update, :destroy, :show_info]

  def show
    @users = @team.users
    @tasks = @team.tasks
  end

  # assigns all teams associated with a given user to the instance variable
  def index
    @teams = current_user.try(:all_associated_teams)
  end

  # lists team information
  def show_info
  end

  # assigns the current user to the created_by attribute of the new team
  def create
    @team = Team.new(team_params)
    @team.created_by = current_user.try(:id)
    if @team.save(team_params)
      @team.add_user(current_user)
      redirect_to(@team)
    else
      render('new')
    end
  end

  def new
    @team = Team.new
  end

  def update
    if @team.update(team_params)
      return redirect_to(teams_path, :flash => { :notice => "Updated Team Successfully" })
    end
    render 'edit'
  rescue => ex
    redirect_to(teams_path, :flash => { :alert => ex.to_s })
  end

  def edit
  end

  def destroy
  end

  private

    # assigns the team with a given id to the team instance variable
    # and ensures that the current user is authorized to view
    def set_team
      @team = Team.find_by_id(params[:id])
      redirect_to(root_url) unless @team && current_user_is_on_this_team?
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def team_params
      params.require(:team).permit(:name, :description, :created_by, :github_url, :id)
    end

    # ensures user is an active member of the team
    def current_user_is_on_this_team?
      TeamUser.exists?(user_id: current_user.try(:id), team_id: params[:id])
    end
end
