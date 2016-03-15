class HistoriesController < ApplicationController

  before_action :set_user

  def index
    @q = q_params
    @histories = History.includes(:topic)
      .joins(:topic).merge(Topic.search(@q))
      .where(user_id: @user.id)
      .order(updated_at: :desc).page(params[:page])
  end

end
