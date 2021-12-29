require 'bcrypt'
class User < ApplicationRecord
  include BCrypt

  has_many :team_users
  has_many :teams, through: :team_users
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :encryptable, :invitable

  validates :first_name, presence: true,
            length: { in: 2..20 },
            format: { with: /\A[a-zA-Z]+\z/, message: "only allows letters" },
            allow_blank: true

  validates :last_name, presence: true,
            length: { in: 2..20 },
            format: { with: /\A[a-zA-Z]+\z/, message: "only allows letters" },
            allow_blank: true

  validates :username, presence: true,
            length: { in: 5..15 }, uniqueness: true

  validates :password, presence: true,
            length: { minimum: 8 }

  validates :email, presence: true,
            email: true,
            length: { in: 8..60 },
            format: { with: URI::MailTo::EMAIL_REGEXP },
            uniqueness: { case_sensitive: false }

  after_validation :capitalize_names
  after_create :activate_accepted_invites

  def password
    password_hash ? @password = Password.new(password_hash) : @password = nil
    @password
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

  # Public: returns task for (team-user) relation, if one exists
  # task must be assigned to user (status: 2)
  def task_assignment(team)
    return unless team.is_a?(Team) && TeamUser.find_by(team_id: team.id, user_id: id)
    Task.find_by(team_id: team.id, user_id: id, status: 2)
  end

  # Public: returns all conversations for user
  def conversations
    Conversation.where(sender_id: id) | Conversation.where(recipient_id: id)
  end

  # Public: updates database record by marking the user as activated
  #
  # returns nothing
  def email_activate
    self.update!(email_confirmed: true, confirmation_token: nil)
  end

  # Public: returns user's full name capitalized
  #
  # returns full name
  def full_name
    if first_name && last_name
      "#{first_name} #{last_name}"
    else
      "#{username}"
    end
  end

  # Public: creates team associations from all invites that have been accepted
  #
  # returns nothing
  def activate_accepted_invites
    invites = Invite.where(email: self.email, accepted: true)
    return unless invites.count > 0
    invites.each do |invite|
      TeamUser.find_or_create_by!(team_id: invite.team_id, user_id: self.id)
    end
  end

  # Public: returns all teams from a given user
  # after invoking above method
  #
  # returns nothing if no teams associated
  def all_associated_teams
    activate_accepted_invites # temporary
    teams = []
    TeamUser.where(user_id: self.id).each { |pair| teams << Team.find_by_id(pair.team_id) }
    teams
  end

  def create_conversations_with_teammates!
    return unless all_associated_teams && all_associated_teams.count > 0
    all_associated_teams.each do |team|
      team.users.each do |user|
        unless user == self
          Conversation.find_or_create!(user,self)
        end
      end
    end
  end

  private
    # Private: capitalizes names before saving to database
    #
    # returns nothing
    def capitalize_names
      self.first_name = self.first_name.try(:capitalize)
      self.last_name = self.last_name.try(:capitalize)
    end
end