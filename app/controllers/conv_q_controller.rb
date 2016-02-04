class ConvQController < ApplicationController

  def index
    @topic = Topic.order("RAND()").first
  end

end
