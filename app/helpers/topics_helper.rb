module TopicsHelper

  def title_with_icon(topic)
    html = topic.title
    html += link_to(content_tag(:i, "play_arrow", class: "material-icons topic-title-link"), topic)
    return raw html
  end

  def tags_to_label(topic)
    labels = ""
    topic.tags.each do |tag|
      labels += link_to(tag.name, topics_path(tag_names: tag.name), class: "label label-success topic-tag")
    end
    if topic.source_url.present?
      labels += link_to(topic.source_url.match(/(http|https):\/\/(.*?)\//)[2], topic.source_url, class: "label label-default topic-tag")
    end
    if topic.user.present?
      labels += link_to("@#{topic.user.account}", user_path(topic.user.account), class: "label label-default topic-tag")
    end
    return raw labels
  end

  def reports_to_count(topic)
    reports_count = topic.reports.count
    reports_count_text = (reports_count === 0) ? "" : reports_count.to_s
    text_color = (reports_count === 0) ? "text-muted" : "text-danger"
    content_tag :div, class: "right" do
      link_to topic_reports_path(topic), class: text_color do |variable|
        content_tag(:i, "report_problem", class: "material-icons") + content_tag(:span, reports_count_text, class: "reports_count")
      end
    end
  end

end
