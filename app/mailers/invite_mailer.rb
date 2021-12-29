class InviteMailer < ApplicationMailer
  # Public: mails an invite to the email address in the invite
  # by rendering the invitation instructions template
  #
  # returns nothing
  def team_invite(invite)
    raise Exception unless invite.is_a?(Invite)
    @invite = invite
    @sender_name = User.find_by_id(invite.sender_id).full_name
    @token = invite.token.to_s
    mail(:template_path => "devise/mailer", :template_name => "invitation_instructions", :to => @invite.email.to_s)
  end
end
