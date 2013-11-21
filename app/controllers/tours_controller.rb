class ToursController < ApplicationController
  def index
    @days = (Date.new(2013, 11, 11)..Date.new(2013, 11, 14)).map do |date|
      tours = Interactor::ListTours.new(date).run.object
      tours.each do |t|
        stations = Interactor::ListStations.new(t.id, date).run.object
        t.stations = stations
      end
      OpenStruct.new tours: tours, date: date
    end
  end
end
