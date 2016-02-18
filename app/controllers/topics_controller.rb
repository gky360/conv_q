class TopicsController < ApplicationController

  before_action :set_topic, only: [:show, :edit, :update, :done_and_show]
  before_action :set_next_topic, only: [:show, :done_and_show]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :authenticate_user_by_topic, only: [:edit, :update]

  def index
    @q = q_params
    @topics = Topic.includes(:tags, :histories).search(@q).page(params[:page])
  end

  def show
  end

  def new
    @topic = Topic.new
  end

  def create
    @topic = Topic.new(topic_params)
    @topic.user_id = current_user.id
    # TODO: tags

    if @topic.save
      @topic.tags = Tag.all_with_names(params[:tag_names].to_s.split(","))
      redirect_to @topic, notice: "Topic was successfully created."
    else
      render action: "new"
    end
  end

  def edit
  end

  def update
    @topic.assign_attributes(topic_params)

    if @topic.save
      @topic.tags = Tag.all_with_names(params[:tag_names].to_s.split(","))
      redirect_to @topic, notice: "Topic was successfully updated."
    else
      render action: "edit"
    end
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

  def topic_params
    params.require(:topic).permit(:title, :source_url)
  end

  def authenticate_user_by_topic
    if !@topic.by_user?(current_user)
      redirect_to root_path, alert: 'Permission denied.'
    end
  end

end
