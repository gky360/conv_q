class ConvQController < AppController

  protect_from_forgery except: [:sp]

  def index
    @topic = Topic.rand_for_user(current_user).first
    @next_topic = Topic.rand_for_user(current_user).second
  end

  def sp
    path = params[:path] || "index"
    format = params[:format] || "html"
    file_str = File.read("#{Rails.root}/conv_q_sp/conv_q_sp/www/#{path}.#{format}")
    render text: file_str
  end

end
