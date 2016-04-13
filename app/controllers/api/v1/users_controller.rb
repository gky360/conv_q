class Api::V1::UsersController < Api::V1::ApiController

  PERMITTED_FIELDS = Array[
    :id, :name, :account, :status, :email, :created_at, :updated_at, :provider, :uid
  ]

  before_action -> { set_select_params_with_permit(PERMITTED_FIELDS) }
  before_action :set_user

  def show
    render_with_meta!(user: @user)
  end


  private

  def user_not_found!(user_name)
    @status = 404
    @errors << Hash[
      reason: "user_not_found",
      message: "Couldn't find user '#{user_name}'."
    ]
    render_with_meta!
  end

  def set_user
    @user = User.select(@select).find_by(account: params[:account])
    user_not_found!(params[:account]) if @user.nil?
  end

end
