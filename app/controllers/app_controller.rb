class AppController < ApplicationController
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from ActionController::RoutingError, with: :render_404

  before_action :configure_permitted_parameters, if: :devise_controller?


  protected

  def render_404(e = nil)
    if e
      logger.info "Rendering 404 with exception:"
      logger.info "#{e.class}:#{e.message}"
    end
    render file: 'public/404.html', status: 404, layout: false
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up).push(:name, :account)
    devise_parameter_sanitizer.for(:account_update).push(:name)
  end

  def set_q_params
    @q = params.permit(:title, :tag_names)
  end

  def set_user
    @user = User.find_by(account: params[:user_account])
    user_not_found if @user.nil?
  end

  def set_user_if_exists
    if params[:user_account].present?
      set_user
    end
  end

  def user_not_found!
    raise ActionController::RoutingError.new('User Not Found')
  end

  def set_topic
    @topic = Topic.includes(:tags, :histories).find(params[:topic_id])
  end

  def set_topic_if_exists
    if params[:topic_id].present?
      set_topic
    end
  end

end
