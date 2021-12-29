class ConversationsController < ApplicationController
  before_action :check_current_user
  include ConversationsHelper

  def index
    if @user.conversations && @user.conversations.count > 0
      return redirect_to(conversations_show_path(id: newest_conversations_first(@user).first))
    else
      return redirect_to(no_conversations_path)
    end
  end

  def none
  end

  def find_or_create
    user = User.find_by_id(params[:id].to_i)
    conversation = Conversation.find_or_create!(user, current_user)
    raise Exception unless conversation
    return redirect_to(conversations_show_path(id: conversation))
  end

  def add_message
    @conversation = Conversation.find_by_id(params[:id].to_i)
    @conversation.add_message(@user, params[:body].to_s)
    redirect_to(conversations_show_path(id: @conversation))
  rescue
    redirect_to(conversations_show_path(id: @conversation))
  end

  def show
  end

  def new
    @conversation = Conversation.new
  end

  def create
    if Conversation.between(params[:sender_id],params[:recipient_id])
           .present?
      @conversation = Conversation.between(params[:sender_id],
                                           params[:recipient_id]).first
    else
      @conversation = Conversation.create!(conversation_params)
    end
    redirect_to conversation_messages_path(@conversation)
  end

  private
    def conversation_params
      params.permit(:sender_id, :recipient_id, :conversation_id, :id, :username)
    end

    def check_current_user
      redirect_to(root_url) unless current_user
      current_user.create_conversations_with_teammates!
      @user = current_user
      @conversation = Conversation.find_by_id(params[:id].to_i) if params[:id]
      @conversations = @user.conversations
      @conversation ||= @conversations.first if @conversations.count > 0
    end
end