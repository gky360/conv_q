class ConvQController < ApplicationController

  def index
    @topic = Topic.rand.first
    @next_topic = Topic.rand.second
  end

end
