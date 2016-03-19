class Api::V1::TagsController < Api::V1::ApiController

  def index
    @tags = Tag.all
    render json: @tags
  end

end
