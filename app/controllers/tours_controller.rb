class ToursController < ApplicationController
  def index
    from, to = parse_dates_or_default_to_this_week
    @days = (from..to).map do |date|
      tours = Interactor::ListTours.new(OpenStruct.new(date: date)).run.object
      tours.each do |t|
        request = OpenStruct.new(tour_id: t.id, date: date)
        stations = Interactor::ListStations.new(request).run.object
        t.stations = stations
      end
      OpenStruct.new tours: tours, date: date
    end
  end
end
