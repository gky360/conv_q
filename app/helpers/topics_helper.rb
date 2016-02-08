module TopicsHelper

  def tags_to_label(topic)
    labels = ""
    topic.tags.split(",").each do |tag|
      labels += content_tag :span, tag, class: "label label-default topic-tag"
    end
    return raw labels
  end

  def link_to_source(topic)
    return link_to(topic.source.match(/(http|https):\/\/(.*?)(\.com)/)[2], topic.source)
  end

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
