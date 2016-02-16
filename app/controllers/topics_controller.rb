class TopicsController < ApplicationController

  before_action :set_topic, only: [:show, :done_and_show]
  before_action :set_next_topic, only: [:show, :done_and_show]
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @q = Topic.new(q_params)
    @topics = Topic.includes(:tags, :histories)
      .where("`title` LIKE ?", "%#{@q.title}%")
      .page(params[:page])
  end

  def show
  end

  def done_and_show
    history = History.where(topic_id: params[:done_topic_id], user_id: current_user.id).first_or_initialize
    history.times = history.times + 1
    if params[:rating]
      history.rating = History.ratings[params[:rating].to_sym]
    end
    history.save
    redirect_to @topic
  end


  private

  def set_topic
    @topic = Topic.includes(:tags, :histories).find(params[:id])
  end

  def set_next_topic
    @next_topic = Topic.rand_for_user(current_user).first
  end

  def q_params
    params.permit(:title, :tag_ids)
  end

end
