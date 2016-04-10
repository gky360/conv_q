class HistoriesController < AppController

  before_action :set_user
  before_action :set_q_params, only: [:index]

  def index
    @histories = History.includes(:topic)
      .joins(:topic).merge(Topic.search(@q))
      .where(user_id: @user.id)
      .order(updated_at: :desc).page(params[:page])
  end

end
