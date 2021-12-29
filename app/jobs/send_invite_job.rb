class SendInviteJob < ApplicationJob
  queue_as :default
  # Public: sends team invites to provided email
  #
  # returns nothing
  def perform(invite)
    raise Exception unless invite.is_a?(Invite)
    @invite = invite
    InviteMailer.team_invite(@invite).deliver_later
  end
end
