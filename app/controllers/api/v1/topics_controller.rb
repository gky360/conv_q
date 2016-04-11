class Api::V1::TopicsController < Api::V1::ApiController

  MAX_LIMIT = 25
  PERMITTED_FIELDS = Array[
    :id, :title, :source_url, :created_at, :updated_at, :user_id
  ]

  before_action :set_q_params,
    only: [:index]
  before_action -> { set_limit_param_with_max(MAX_LIMIT) },
    only: [:index, :rand_for_user]
  before_action :set_offset_param,
    only: [:index]
  before_action -> { set_select_params_with_permit(PERMITTED_FIELDS) },
    only: [:index, :rand_for_user]
  before_action -> { set_order_params_with_permit(PERMITTED_FIELDS) },
    only: [:index]

  def index
    @topics = Topic.search(@q)
        .offset(@offset)
        .limit(@limit)
        .select(@select)
        .order(@order)
    render_with_meta!(topics: @topics)
  end

  def rand_for_user
    @topics = Topic.rand_for_user(current_user)
        .limit(@limit)
        .select(@select)
    render_with_meta!(topics: @topics)
  end

end
