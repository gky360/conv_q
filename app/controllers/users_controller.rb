class UsersController < ApplicationController

  before_action :set_user, only: [:show]

  def show
    @histories = History.includes(:topic).where(user_id: @user)
  end

  private

  def set_user
    @user = User.find_by(account: params[:account])
  end

end
