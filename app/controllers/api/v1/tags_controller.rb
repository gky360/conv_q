class Api::V1::TagsController < Api::V1::ApiController

  MAX_LIMIT = 1000
  PERMITTED_FIELDS = Array[
    :id, :name, :created_at, :updated_at
  ]

  before_action -> { set_limit_param_with_max(MAX_LIMIT) },
    only: [:index]
  before_action :set_offset_param,
    only: [:index]
  before_action -> { set_select_params_with_permit(PERMITTED_FIELDS) },
    only: [:index]
  before_action -> { set_order_params_with_permit(PERMITTED_FIELDS) },
    only: [:index]

  def index
    @tags = Tag.all
        .offset(@offset)
        .limit(@limit)
        .select(@select)
        .order(@order)
    render_with_meta!(tags: @tags)
  end

end
