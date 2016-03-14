module ReportsHelper

  def reasons_to_ul(report, is_verbose = false)
    content_tag :ul do
      report.reasons.each do |reason_value, reason_text|
        concat content_tag(:li, reason_text)
      end
    end
  end

end
