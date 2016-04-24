# 例外を補足した際の処理をまとめるモジュール
module Api::V1::ExceptionHandler

  include Api::V1::CommonRenderer

  def rescue_standard_error(e = nil)
    e = StandardError.new if e.nil?
    logger.info "!!RESCUE!! #{e.class}: #{e.message}\n  #{e.backtrace.join("\n  ")}"
    status = nil
    errors = []
    # TODO: IllegalAccessError
    # TODO: UnauthorizedError
    # TODO: ActiveRecord::RecordNotUnique
    if e.is_a?(ActiveRecord::RecordNotFound)
      status = :not_found
      errors << Hash[
        reason: "record_not_found",
        message: "指定されたデータが見つかりません。"
      ]
    elsif e.is_a?(ActionController::RoutingError)
      status = :not_found
      errors << Hash[
        reason: "routing_error",
        message: "指定された URL は見つかりません。"
      ]
    elsif e.is_a?(ActionController::ParameterMissing)
      status = :bad_request
      errors << Hash[
        reason: "parameter_missing",
        message: "指定されたパラメータが不適切です。"
      ]
    elsif e.is_a?(ActionController::InvalidAuthenticityToken)
      status = :unauthorized
      errors << Hash[
        reason: "invalid_xsrf_token",
        message: "Please set a valid xsrf token."
      ]
    else
      status = :internal_server_error
      errors << Hash[
        reason: "internal_server_error",
        message: "サーバー内で不明なエラーが発生しました。"
      ]
    end
    render_with_meta(nil, status, errors)
  end

end
