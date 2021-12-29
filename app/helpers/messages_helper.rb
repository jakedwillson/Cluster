module MessagesHelper
  # Public: returns a link to the conversation between the current_user and the selected user
  def direct_message_link(user, current_user)
    return I18n.t('helpers.messages.errors.invalid_user') unless user.is_a?(User) && current_user.is_a?(User)
    return I18n.t('helpers.messages.errors.sender_and_receiver_same') if user == current_user
    link_to("Direct Message", conversations_path(sender_id: current_user.id, recipient_id: user.id), method: "post")
  end
end
