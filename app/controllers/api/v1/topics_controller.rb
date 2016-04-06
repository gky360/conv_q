class Api::V1::TopicsController < Api::V1::ApiController

  MAX_LIMIT = 25
  PERMITTED_COLUMNS = Array[
    :id, :title, :source_url, :created_at, :updated_at, :user_id
  ]

  def index
    @q = q_params
    @limit = [(params[:limit] || MAX_LIMIT).to_i, MAX_LIMIT].min
    @offset = params[:offset].to_i
    @topics = Topic.search(@q)
        .offset(@offset)
        .limit(@limit)
        .fields_with_permit(params[:select], PERMITTED_COLUMNS)
        .sort_with_permit(params[:order], PERMITTED_COLUMNS)
    render json: @topics
  end

end
