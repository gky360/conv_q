class Api::V1::ApiController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken

  protect_from_forgery with: :exception
  rescue_from ActionController::InvalidAuthenticityToken, with: :handle_invalid_csrf_token

  before_action :log_xsrf_token


  protected

  def log_xsrf_token
    logger.debug "cookies['XSRF-TOKEN']"
    logger.debug cookies['XSRF-TOKEN']
  end


  private

  def handle_invalid_csrf_token(e)
    logger.error "#{e.class}: #{e.message}"
    render json: { errors: ["invalid_auth_token"] }, status: :unauthorized
  end

end
