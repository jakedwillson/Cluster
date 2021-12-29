class MessagesController < ApplicationController
  before_action :set_conversation

  def index
    @messages = @conversation.messages

    if @messages.length > 10
      @over_ten = true
      @messages = @messages[-10..-1]
    else
      @over_ten = false
      @messages = @conversation.messages
    end

    if @messages.last && @messages.last.sender_id != current_user.id
      @conversation.mark_all_unread_messages_read!
    end
    @message = @conversation.messages.new
  end

  def new
    @message = @conversation.messages.new
  end

  def create
    @message = @conversation.messages.new(message_params)
    if @message.save
      redirect_to conversation_messages_path(@conversation)
    else
      flash[:errors] = 'error'
      render 'new'
    end
  end

  private
    def set_conversation
      @conversation = Conversation.find_by_id(params[:conversation_id])
      redirect_to(root_url) unless @conversation && current_user
    end

    def message_params
      params.require(:message).permit(:body, :sender_id)
    end
end