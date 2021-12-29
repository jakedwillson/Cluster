module ConversationsHelper
  # Public: returns conversations sorted from newest -> oldest
  #
  # 1) most recent messages will determine which conversations are newest
  # 2) if no messages, most recent conversation records will be first
  def newest_conversations_first(user)
    return [] unless user && user.conversations.count > 0
    convs = user.conversations.sort_by { |conv| [conv.most_recent_update] }.reverse
    c = []
    convs.each { |conv| c << conv if conv.messages.count > 0 || conv == @conversation }
    c
  end

  # Public: returns active link iff the conversation is the same as the
  # instance variable (current one being displayed)
  def chat_list_link(conversation)
    return "chat_list active_chat" if conversation == @conversation
    "chat_list"
  end

  # Public: returns user initials
  # or first two characters in username
  def user_initials(user)
    user.username[0].upcase + user.username[1].upcase
  end
end
