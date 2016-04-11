class TopicsController < AppController

  before_action :set_topic, only: [:show, :edit, :update, :destroy, :done_and_show]
  before_action :set_next_topic, only: [:show, :done_and_show]
  before_action :set_user_if_exists, only: [:index]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :authenticate_user_by_topic, only: [:edit, :update, :destroy]
  before_action :set_q_params, only: [:index]

  def index
    @topics = Topic.includes(:tags, :histories).search(@q).page(params[:page])
    if @user.present?
      @topics = @topics.where(user_id: @user.id)
    end
  end

  def show
  end

  def new
    @topic = Topic.new
  end

  def create
    @topic = Topic.new(topic_params)
    @topic.user_id = current_user.id
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

  def destroy
    if @topic.destroy
      redirect_to user_topics_path(current_user.account), notice: "Topic was successfully deleted."
    else
      redirect_to @topic, alert: "We are sorry, but something went wrong while deleting the topic."
    end
  end

  def done_and_show
    history = History.where(topic_id: params[:done_topic_id], user_id: current_user.id).first_or_initialize
    history.times = history.times + 1
    if params[:rating]
      history.rating = History.ratings[params[:rating].to_sym]
    end
    history.save
    set_histories_count
    histories_count_text = "Today: #{@histories_count[:today]} / Total: #{@histories_count[:total]}"
    redirect_to @topic, notice: "The topic was successfully checked as done. (#{histories_count_text})"
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

  def set_histories_count
    @histories_count = user_signed_in? ? current_user.histories_count : {}
  end

end
