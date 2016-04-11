class Api::V1::ApiController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken

  protect_from_forgery with: :exception
  rescue_from ActionController::InvalidAuthenticityToken, with: :handle_invalid_xsrf_token!

  before_action :log_xsrf_token
  before_action :log_current_user
  before_action :set_meta


  protected

  def render_with_meta!(body_h = {})
    logger.debug body_h
    unless @status.is_a? Integer
      @status = Rack::Utils::SYMBOL_TO_STATUS_CODE[@status]
    end
    data_h = {}
    data_h[:status] = @status
    data_h[:errors] = @errors if @errors.present?
    data_h.merge!(body_h)
    render json: data_h, status: @status
  end

  def log_xsrf_token
    logger.debug "cookies['XSRF-TOKEN']: #{cookies['XSRF-TOKEN']}"
  end

  def log_current_user
    logger.debug "current_user: #{user_signed_in? ? current_user.email : ''}"
  end

  def set_meta
    @status = :ok
    @errors = []
  end

  def set_q_params
    @q = params.permit(:title, :tag_names)
  end

  def set_limit_param_with_max(max_limit)
    @limit = params[:limit].present? ? params[:limit].to_i : max_limit
    @limit = @limit < 0 ? 0 : @limit
    @limit = @limit > max_limit ? max_limit : @limit
    return @limit
  end

  def set_offset_param
    @offset = params[:offset].to_i
  end

  # [ params[:select] ] fields you want, splitted by commas
  #   if not present, this scope returns all fields included in permitted_fields
  # [permitted_fields] array of syms of fields you permit clients to access
  #   if not present, this scope returns all fields of the model
  def set_select_params_with_permit(permitted_fields)
    fields_text = params[:select] || ""
    permitted_fields ||= []
    fields = fields_text.split(",")
        .map{ |field_text| field_text.strip.to_sym }
        .select{ |field| permitted_fields.include?(field) }
    if fields.empty?
      @select = permitted_fields
    else
      @select = fields
    end
    return @select
  end

  # [ params[:order] ] fields you want to use to sort records, splitted by commas
  #   example:
  #     "updated_at"  -> updated_at: :asc
  #     "-updated_at" -> updated_at: :desc
  # [permitted_fields] array of syms of fields you permit clients to access
  def set_order_params_with_permit(permitted_fields)
    fields_text = params[:order] || ""
    permitted_fields ||= []
    @order = {}
    fields_text.split(",").each do |field_text|
      field_match = field_text.strip.match(/\A(\-?)(\w+)\Z/)
      next if field_match.nil?
      attr_key = field_match[2].to_sym
      next unless permitted_fields.include?(attr_key)
      if field_match[1] === "-"
        @order[attr_key] = :desc
      else
        @order[attr_key] = :asc
      end
    end
    return @order
  end


  private

  def handle_invalid_xsrf_token!(e)
    logger.error "#{e.class}: #{e.message}"
    @status = :unauthorized
    @errors << Hash[
      reason: "invalid_xsrf_token",
      message: "Please set a valid xsrf token."
    ]
    render_with_meta!
  end

end
