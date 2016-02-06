module TopicsHelper

  def tags_to_label(tags)
    labels = ""
    tags.split(",").each do |tag|
      labels += content_tag :span, tag, class: "label label-default topic-tag"
    end
    return raw labels
  end

  def link_to_source(topic)
    return link_to(topic.source.match(/(http|https):\/\/(.*?)(\.com)/)[2], topic.source)
  end

end
