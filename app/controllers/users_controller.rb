class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def confirm_email
    user = User.find_by_confirm_token(params[:id])
    if user
      user.email_activate
      flash[:success] = "Welcome to the Sample App! Your email has been confirmed.
      Please sign in to continue."
      redirect_to login_path
    else
      flash[:error] = "Sorry. User does not exist"
      redirect_to root_url
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  def index
    @users = User.all
  end

  # GET /users/new
  def new
    send_home_if_logged_in
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @user.password = params[:password]
    respond_to do |format|
      if @user.save
        format.html { redirect_to root_url, notice: "Confirm email address to continue" }
        format.json { head :no_content }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to home_path, notice: I18n.t('controller.users.notices.account_successfully_updated') }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to root_url, notice: I18n.t('controller.users.notices.account_successfully_deleted') }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = current_user
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name, :role, :username, :user_name)
    end

    # invoked when new user account is being set up
    def send_home_if_logged_in
      redirect_to(home_url) if current_user
    end
end
