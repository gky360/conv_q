module TopicsHelper

  def link_to_source(topic)
    return link_to(topic.source.match(/(http|https):\/\/([^\/]*)/)[2], topic.source)
  end

end
