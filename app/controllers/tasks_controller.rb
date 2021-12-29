class TasksController < ApplicationController
  def index
    @tasks = Task.all
  end

  def new
    @team = Team.find_by_id(params[:team_id])
    @task = @team.tasks.build
    redirect_to(root_url) unless @team && @task
  end

  def create
    @team = Team.find_by_id(params[:team_id])
    @task = @team.tasks.build(task_params)
    if @task.save
      redirect_to(team_path(@team), :flash => { :notice => "Created Task Successfully" })
    else
      redirect_to(new_task_path(team_id: @team.id), :flash => { :errors => @task.errors.first.to_s })
    end
  end

  def show
    @task = Task.find_by_id(params[:id])
    redirect_to(root_url) unless @task
  end

  # Public: task status updated to 3 (complete)
  def mark_complete
    @task = Task.find_by_id(params[:id])
    redirect_to(root_url) unless @task
    @task.mark_complete!
    redirect_to(team_path(@task.team), :flash => { :notice => "Task Marked Complete" })
  rescue
    redirect_to(root_url)
  end

  # Public: task status updated to 1 (idle)
  def return_to_queue
    @task = Task.find_by_id(params[:id])
    redirect_to(root_url) unless @task
    @task.return_to_queue!
    redirect_to(team_path(@task.team), :flash => { :notice => "Task Returned to Queue" })
  rescue
    redirect_to(root_url)
  end

  def edit
    @task = Task.find_by_id(params[:id])
    redirect_to(root_url) unless @task
  end

  def re_queue_task
    @task = Task.find_by_id(params[:id])
    redirect_to(root_url) unless @task
    @task.update!(status: 1)
    redirect_to(team_path(@task.team), :flash => { :notice => "Task Returned to Queue" })
  rescue
    redirect_to(root_url)
  end

  def take
    @task = Task.find_by_id(params[:id])
    if current_user.task_assignment(@task.team)
      return redirect_to(team_path(@task.team), :flash => { :alert => "You already have a task" })
    end
    @task.update!(user_id: current_user.id, status: 2)
    redirect_to(team_path(@task.team), :flash => { :notice => "Task Accepted Successfully" })
  rescue
    redirect_to(root_url)
  end

  def delete
    @task = Task.find_by_id(params[:id])
    @task.destroy!
    redirect_to(team_path(@task.team), :flash => { :notice => "Task Destroyed Successfully" })
  rescue
    redirect_to(root_url)
  end

  def update
    @task = Task.find_by_id(params[:id])
    @task.update!(task_params)
    @task.assign_user(User.find_by_id(params[:user_id].to_i)) if params[:user_id] && params[:user_id] != @task.user_id
    redirect_to(team_path(@task.team), :flash => { :notice => "Updated Task Successfully" })
  rescue => ex
    redirect_to(team_path(@task.team), :flash => { :errors => ex.to_s })
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task).permit(:team_id, :id, :user_id, :name, :note, :status, :deadline, :github_url)
    end
end
