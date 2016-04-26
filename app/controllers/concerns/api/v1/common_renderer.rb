module Api::V1::CommonRenderer

  # データに status, errors の情報を付加して、render json する
  # [body_h] 返したいデータ本体のハッシュ
  # [status] HTTP ステータスコード。数値、もしくはシンボルで指定する。
  # [errors] エラー情報を示すハッシュの配列。各ハッシュは以下のキーを持つようにする。
  #   - reason: 理由を示す英数字のコード
  #   - message: 日本語のメッセージ
  # [others_h] その他の付加したいデータ
  def render_with_meta(body_h = nil, status = 200, errors = nil, others_h = nil)
    body_h = {} if body_h.nil?
    errors = [] if errors.nil?
    others_h = {} if others_h.nil?
    unless status.is_a? Integer
      status = Rack::Utils::SYMBOL_TO_STATUS_CODE[status]
    end
    errors.select! { |error_h| error_h[:reason].present? && error_h[:message].present? }

    data_h = {}
    data_h[:status] = status
    data_h[:errors] = errors if errors.present?
    data_h.merge!(others_h)
    data_h.merge!(body_h)
    render json: data_h, status: status
  end

  # resources に embeds で指定された関連モデル等を埋め込む
  # resources が単数の場合はハッシュ、複数の場合はハッシュの配列にして返す
  def embed_in(resources, embeds)
    if resources.is_a?(Topic::ActiveRecord_Relation) || resources.is_a?(Array)
      return resources.map { |resource| embed_in_each(resource, embeds) }
    else
      return embed_in_each(resources, embeds)
    end
  end

  # 単数の resource に、embeds で指定された関連モデル等を埋め込んで、ハッシュにして返す
  def embed_in_each(resource, embeds)
    resource_h = resource.attributes.symbolize_keys
    embeds.each do |embed|
      resource_h[embed] = resource.send(embed)
    end
    return resource_h
  end

  # バリデーションエラーをまとめて、render_with_meta の errors に指定できる形にする
  def format_validation_errors(resource)
    full_messages = resource.errors.full_messages
    errors = resource.errors.map.with_index do |kv, i|
      error = {}
      error[:reason] = "invalid_#{kv[0].to_sym}"
      error[:message] = full_messages[i]
      error
    end
    return errors
  end

  # ログインしていない場合は、status, errors をレスポンスとして返す
  def authenticate_user_with_meta!
    unless current_user
      render_with_meta(
        nil,
        401,
        [{ reason: "authorized_users_only", message: "Authorized users only." }]
      )
    end
  end

end
