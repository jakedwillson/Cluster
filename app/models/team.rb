class Team < ApplicationRecord
  has_many :team_users
  has_many :users, through: :team_users
  has_many :invites
  has_many :tasks

  validates :name, presence: true,
            length: { in: 1..60 }

  validates :description, allow_blank: true,
            length: { in: 1..1000 }

  validates :created_by, presence: true,
            numericality: true

  validate :is_valid_user

  # Public: adds user to team
  #
  # user - user being added
  #
  # creates entry in TeamUser data table
  # returns nothing or error
  def add_user(user)
    return I18n.t('model.user.errors.invalid_user_id') unless user.is_a?(User)
    return I18n.t('model.team.errors.user_already_added') if TeamUser.find_by(team_id: self.id, user_id: user.id)
    TeamUser.create!(team_id: self.id, user_id: user.id)
  end

  # Public: returns all tasks on a given team that are not assigned to a user
  def unassigned_tasks
    Task.where(team_id: id, status: 1)
  end

  # Public: returns all tasks on a given team that are not assigned to a user
  def finished_tasks
    Task.where(team_id: id, status: 3)
  end

  # Public: removes user to team by user_id
  #
  # user - user being added
  #
  # removes entry in TeamUser data table
  # returns nothing or error
  def remove_user(user)
    return I18n.t('model.user.errors.invalid_user_id') unless user.is_a?(User)
    return I18n.t('model.team.errors.user_not_on_team') unless TeamUser.find_by(team_id: self.id, user_id: user.id)
    TeamUser.find_by(team_id: self.id, user_id: user.id).delete
  end

  # Public: returns all tasks associated with a given team
  def tasks
    Task.where(team_id: id)
  end

  private
    def is_valid_user
      errors[:created_by] << I18n.t('model.team.errors.invalid_created_by_id') unless User.exists?(id: created_by.to_i)
    end
end
