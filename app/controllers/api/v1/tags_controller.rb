class Api::V1::TagsController < Api::V1::ApiController

  def index
    @tags = Tag.select(:id, :name)
    render_with_meta!(tags: @tags)
  end

end
