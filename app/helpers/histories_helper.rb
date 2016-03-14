module HistoriesHelper

  def rating_to_iocn(history)
    class_str = ""
    case history.rating
    when "like"
      class_str = "glyphicon glyphicon-thumbs-up text-success"
    when "dislike"
      class_str = "glyphicon glyphicon-thumbs-down text-danger"
    end
    return content_tag :span, "", class: class_str
  end

end
