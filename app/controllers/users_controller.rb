class UsersController < ApplicationController

  before_action :set_user

  def show
  end


  private

  def set_user
    @user = User.find_by(account: params[:account])
    user_not_found if @user.nil?
  end

end
