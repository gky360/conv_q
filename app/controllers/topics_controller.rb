class TopicsController < ApplicationController

  before_action :set_topic, only: [:show]

  def index
    @topics = Topic.page(params[:page])
  end

  def show
  end


  private

  def set_topic
    @topic = Topic.find(params[:id])
  end

end
