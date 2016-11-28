module HistoriesHelper

  def rating_to_iocn(history)
    classes = ["material-icons"]
    icon_text = ""
    case history.rating
    when "like"
      classes << "green-text text-lighten-1"
      icon_text = "thumb_up"
    when "dislike"
      classes << "red-text text-lighten-1"
      icon_text = "thumb_down"
    end
    return content_tag :i, icon_text, class: classes.join(" ")
  end

end
