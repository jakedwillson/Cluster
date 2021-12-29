module TeamsHelper
  # Public: returns a DM link for a conversation between two users
  # and creates a new conversation if necessary
  def direct_message_between_users(user, current_user)
    return unless user.is_a?(User) && current_user.is_a?(User) && user != current_user
    conversation = Conversation.find_or_create!(user, current_user)
    conversations_show_path(id: conversation.id)
  end

  # Public: returns days left until deadline is hit for task
  def days_left(task)
    diff = task.deadline - Date.today
    "#{diff.to_i}"
  end

  # Public: returns select box for task assignment
  def other_available_users_for_task(task)
    users = []
    users << User.find_by_id(task.user_id) if task.user_id.present?
    task.team.users.each { |user| users << user unless user.task_assignment(task.team) }
    users
  end

  # Public: returns all team members, with the current user first in the list
  def team_members(team, current_user)
    arr = [current_user]
    team.users.each { |user| arr << user unless user == current_user }
    arr
  end
end
