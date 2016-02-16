class UsersController < ApplicationController

  before_action :set_user, only: [:show]

  def show
    @q = q_params
    @histories = History.includes(:topic)
      .joins(:topic).merge(Topic.search(@q))
      .where(user_id: @user)
      .order(updated_at: :desc).page(params[:page])
  end

  private

  def set_user
    @user = User.find_by(account: params[:account])
  end

end
