module ApplicationHelper
  def next_day
    date = Date.parse params[:date]
    (date + 1.day).iso8601
  end

  def previous_day
    date = Date.parse params[:date]
    (date - 1.day).iso8601
  end
end
