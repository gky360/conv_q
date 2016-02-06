class TopicsController < ApplicationController

  before_action :set_topic, only: [:show, :done_and_show]
  before_action :set_next_topic, only: [:show, :done_and_show]
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @topics = Topic.page(params[:page])
  end

  def show
  end

  def done_and_show
    History.create({ topic_id: params[:done_topic_id], user_id: current_user.id })
    redirect_to @topic
  end


  private

  def set_topic
    @topic = Topic.find(params[:id])
  end

  def set_next_topic
    @next_topic = Topic.rand.first
  end

end
