class Invite < ApplicationRecord
  belongs_to :team

  validates :team_id, presence: true
  validates :sender_id, presence: true, allow_blank: true # for now
  validates :email, presence: true
  validates :token, presence: true
  validates :user_id, presence: true, allow_blank: true

  before_validation :generate_token, :validate_team, :assign_user_id_if_possible

  private
    # Private: assigns user_id attribute to user id if email corresponds to active user
    def assign_user_id_if_possible
      self.user_id = User.find_by_email(email).id if User.exists?(email: email)
    end

    # Private: generates token for invitation
    def generate_token
      self.token = RandomToken.gen(40)
    end

    # Private: validates team_id attribute
    def validate_team
      errors[:team_id] << I18n.t('model.team.errors.invalid_team_id') unless Team.exists?(id: team_id.to_i)
    end
end
