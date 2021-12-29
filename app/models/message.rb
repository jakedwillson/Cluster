class Message < ApplicationRecord
  belongs_to :conversation

  validates_presence_of :body, :conversation_id, :sender_id

  validate :validate_sender, :validate_conversation

  # Public: returns time of last interaction
  def message_time
    time = created_at.to_time.localtime
    span = Date.today - time.to_date
    return time.stamp("1:00 AM") if span < 1.days
    return time.stamp("Sunday at 1:00 AM") if span < 7.days
    time.strftime('12/31/99 at 1:00 AM')
  end

  # Public: returns message sender
  def sender
    User.find_by_id(sender_id)
  end

  private
    def validate_sender
      errors[:sender_id] << 'invalid sender id' unless sender.is_a?(User)
      errors[:sender_id] << 'sender not in conversation' unless conversation.try(:sender_id) == sender_id ||
          conversation.try(:recipient_id) == sender_id
    end
    
    def validate_conversation
      errors[:conversation_id] << 'invalid conversation id' unless conversation.is_a?(Conversation)
    end
end
