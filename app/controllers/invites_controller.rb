class InvitesController < ApplicationController
  def new
    @invite = Invite.new
  end

  # Public: creates an invite from the provided parameters
  # and sends an email to the recipient with an acceptance token
  #
  # sends request asynchronously
  def create
    @team = Team.find_by_id(params[:team_id])
    invite = params[:invite]
    email_or_username = invite[:email_or_username]

    raise Exception unless email_or_username && is_email?(invite[:email_or_username])

    email = email_or_username
    @invite = @team.invites.create!(team_id: @team.id, sender_id: current_user.id, email: email)
    SendInviteJob.set(wait: 3.seconds).perform_later(@invite)
    redirect_to(@team)
  end

  # Public: accepts team invite if valid token provided
  #
  # redirects user conditionally depending on session status and invite attributes
  def accept
    @invite = Invite.find_by_token(params[:token].to_s)

    return redirect_to(login_path) unless @invite # CHANGE LATER

    @invite.update!(accepted: true)

    team = Team.find_by_id(@invite.team_id)
    user = User.find_by_email(@invite.email)

    return redirect_to(logout_path) if user.nil? && current_user
    return redirect_to(signup_path) unless user

    TeamUser.find_or_create_by!(team_id: team.id, user_id: user.id)

    return redirect_to(logout_path) if current_user && current_user.email != @invite.email
    return redirect_to(login_path) unless current_user
    redirect_to(team)
  end

  # Public: checks if string is email format
  def is_email?(str)
    str.to_s =~ /\A[^@]+@[^@]+\Z/
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def invite_params
      params.require(:invite).permit(:email_or_username, :email, :team_id, :sender_id, :token)
    end
end
