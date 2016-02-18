module TopicsHelper

  def tags_to_label(topic)
    labels = ""
    topic.tags.each do |tag|
      labels += content_tag :span, tag.name, class: "label label-success topic-tag"
    end
    if topic.source_url.present?
      labels += link_to(topic.source_url.match(/(http|https):\/\/(.*?)\//)[2], topic.source_url, class: "label label-default topic-tag")
    end
    return raw labels
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
