class UsersController < AppController

  before_action :set_user
  before_action :set_histories_count, only: [:show]

  def show
  end


  private

  def set_user
    @user = User.find_by(account: params[:account])
    user_not_found! if @user.nil?
  end

  def set_histories_count
    @histories_count = {}
    if @user
      @histories_count[:total] = @user.histories.count
      @histories_count[:today] = @user.histories.where('updated_at >= ?', Date.today).count
    end
  end

end
