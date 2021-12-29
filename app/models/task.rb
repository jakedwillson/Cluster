class Task < ApplicationRecord

  before_validation :default_values

  # status: (1) idle (2) assigned (3) finished
  validates :status, presence: true, inclusion: { in: 1..3 }
  validates :name, presence: true, length: { in: 1..60 }
  validates :note, allow_blank: true, length: { maximum: 1000 }

  validate :valid_or_nil_user_id

  belongs_to :team

  # Public: assigns user to the task
  def assign_user(user)
    return I18n.t('model.user.errors.invalid_user_id') unless user.is_a?(User)
    return I18n.t('model.team.errors.user_not_on_team') unless TeamUser.exists?(team_id: team_id, user_id: user.id)
    update!(user_id: user.id, status: 2)
  end

  # Public: returns user who is assigned to task (if any)
  def user
    User.find_by_id(user_id)
  end

  # Public: marks task as complete (status = 3)
  def mark_complete!
    update!(status: 3, user_status: "Complete")
  end

  # Public: returns task to queue (status = 1)
  def return_to_queue!
    update!(status: 1, user_id: nil, user_status: nil)
  end

  def status_name
    return "Not Started" if status == 1
    return "In Progress" if status == 2
    "Complete"
  end

  private
    # Private: assigns status to 1 (unassigned)
    def default_values
      self.status ||= 1
      self.deadline ||= Date.today + 5
      self.user_status ||= "Not Started"
    end

    # Private: ensures that user_id is nil or valid
    def valid_or_nil_user_id
      errors[:user_id] << I18n.t('model.task.errors.invalid_user_id') unless User.exists?(id: user_id) || user_id.nil?
    end
end