class Api::V1::TagsController < ApplicationController

  def index
    @tags = Tag.where('`name` LIKE ?', "%#{params[:name]}%")
    render json: @tags
  end

end
