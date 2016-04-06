class ConvQController < AppController

  def index
    @topic = Topic.rand_for_user(current_user).first
    @next_topic = Topic.rand_for_user(current_user).second
  end

end
