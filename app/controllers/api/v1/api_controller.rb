class Api::V1::ApiController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken

  include Api::V1::CommonRecordParamsSetter
  include Api::V1::CommonRenderer
  include Api::V1::ExceptionHandler

  protect_from_forgery with: :exception
  rescue_from StandardError, with: :rescue_standard_error

  before_action :log_xsrf_token
  before_action :log_current_user

  def no_route_match
    raise ActionController::RoutingError.new("404 Not Found")
  end


  protected

  def log_xsrf_token
    logger.debug "cookies['XSRF-TOKEN']: #{cookies['XSRF-TOKEN']}"
  end

  def log_current_user
    logger.debug "current_user: #{user_signed_in? ? current_user.email : ''}"
  end

end
