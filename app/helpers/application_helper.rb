module ApplicationHelper
  def next_day
    date = Date.parse params[:date]
    (date + 1.day).iso8601
  end

  def previous_day
    date = Date.parse params[:date]
    (date - 1.day).iso8601
  end

  def money(price)
    return "-,--" if price.nil?
    ("%.2f" % (price.amount / 100.0) + " €").gsub(".", ",")
  end

  def long_time(time)
    l time.in_time_zone
  end
end
