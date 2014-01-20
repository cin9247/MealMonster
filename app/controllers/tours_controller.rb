class ToursController < ApplicationController
  def index
    from, to = parse_dates_or_default_to_this_week
    @days = (from..to).map do |date|
      tours = interact_with(:list_tours, OpenStruct.new(date: date)).object
      tours.each do |t|
        request = OpenStruct.new(tour_id: t.id, date: date)
        stations = interact_with :list_stations, request
        t.stations = stations
      end
      OpenStruct.new tours: tours, date: date
    end
  end
end
