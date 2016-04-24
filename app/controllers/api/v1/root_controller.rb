class Api::V1::RootController < Api::V1::ApiController

  def index
    render_with_meta
  end

end
