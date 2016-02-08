module ApplicationHelper

  def user_time_zone
   min = request.cookies["time_zone"].to_i
   return ActiveSupport::TimeZone[-min.minutes]
  end

end
