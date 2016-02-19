class UsersController < ApplicationController

  before_action :set_user
  before_action :set_q, only: [:histories, :topics]

  def show
  end

  def histories
    @histories = History.includes(:topic)
      .joins(:topic).merge(Topic.search(@q))
      .where(user_id: @user.id)
      .order(updated_at: :desc).page(params[:page])
  end

  def topics
    @topics = Topic.search(@q).where(user_id: @user.id).page(params[:page])
  end

  private

  def set_user
    @user = User.find_by(account: params[:account])
    user_not_found if @user.nil?
  end

  def set_q
    @q = q_params
  end

  def user_not_found
    raise ActionController::RoutingError.new('User Not Found')
  end

end
