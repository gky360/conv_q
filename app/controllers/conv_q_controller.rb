class ConvQController < ApplicationController

  def index
    @topic = Topic.rand.first
  end

end
