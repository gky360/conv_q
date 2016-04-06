class Api::V1::ApiController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken

  protect_from_forgery with: :exception
  rescue_from ActionController::InvalidAuthenticityToken, with: :handle_invalid_csrf_token

  before_action :log_xsrf_token
  before_action :log_current_user


  protected

  def log_xsrf_token
    logger.debug "cookies['XSRF-TOKEN']: #{cookies['XSRF-TOKEN']}"
  end

  def log_current_user
    logger.debug "current_user: #{current_user.inspect}"
  end

  def q_params
    params.permit(:title, :tag_names)
  end


  private

  def handle_invalid_csrf_token(e)
    logger.error "#{e.class}: #{e.message}"
    render json: { errors: ["invalid_auth_token"] }, status: :unauthorized
  end

end
