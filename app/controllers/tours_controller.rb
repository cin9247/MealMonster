class ToursController < ApplicationController
  def index
    from, to = parse_dates_or_default_to_this_week
    @days = (from..to).map do |date|
      tours = Interactor::ListTours.new(date).run.object
      tours.each do |t|
        stations = Interactor::ListStations.new(t.id, date).run.object
        t.stations = stations
      end
      OpenStruct.new tours: tours, date: date
    end
  end
end
