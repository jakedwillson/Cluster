class Conversation < ApplicationRecord
  belongs_to :sender, :foreign_key => :sender_id, class_name: 'User'
  belongs_to :recipient, :foreign_key => :recipient_id, class_name: 'User'
  has_many :messages, dependent: :destroy

  validates_uniqueness_of :sender_id, :scope => :recipient_id
  validate :sender_is_not_receiver

  # Public: returns time of last interaction
  def time_of_last_interaction
    return unless messages.count > 0
    last_time = messages.last.created_at.to_time.localtime
    span = Date.today - last_time.to_date
    return last_time.stamp("1:00 PM") if span < 1.days
    return last_time.stamp("Sunday at 1:00 AM") if span < 7.days
    last_time.strftime('12/31/99')
  end

  # Public: gets most recent update to conversation (last message or initial convo record)
  def most_recent_update
    messages.count > 0 ? messages.sort_by { |msg| [msg.id] }.reverse.first.created_at : created_at
  end

  # Public: returns the opposite person in the conversation
  def opposite_person(user)
    return unless user.is_a?(User) && (user == sender || user == recipient)
    return recipient if user == sender
    sender
  end

  # Public: must reload after invocation to update object 'read' field
  def mark_all_unread_messages_read!
    return unless messages.count > 0
    messages.each { |message| message.update!(read: true) unless message.read }
  end

  # Public: adds message to conversation and returns it
  def add_message(sender, message)
    raise Exception unless sender.is_a?(User) && message.present?
    Message.create!(conversation_id: id, body: message, sender_id: sender.id)
  end

  # Public: finds or creates and then returns a conversation
  # between both users
  def self.find_or_create!(user1,user2)
    return unless user1.is_a?(User) && user2.is_a?(User) && user1 != user2
    Conversation.find_by(sender_id: user1.id, recipient_id: user2.id) ||
        Conversation.find_or_create_by!(sender_id: user2.id, recipient_id: user1.id)
  end

  scope :between, -> (sender_id,recipient_id) do
    where("(conversations.sender_id = ? AND conversations.recipient_id =?) OR (conversations.sender_id = ? AND conversations.recipient_id =?)",
          sender_id,
          recipient_id,
          recipient_id,
          sender_id)
  end

  private
    # Private: validates that sender is not receiver
    def sender_is_not_receiver
      errors[:sender_id] << I18n.t('model.conversation.errors.sender_and_recipient_same') if sender_id == recipient_id
    end
end