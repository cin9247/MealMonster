class Api::V1::ToursController < Api::V1::ApiController
  def index
    @tours = Interactor::ListTours.new(OpenStruct.new(date: parsed_date)).run.object
  end

  def show
    tour_id = params[:id].to_i
    @tour = TourMapper.new.find tour_id
    request = OpenStruct.new(tour_id: tour_id, date: parsed_date)
    @stations = Interactor::ListStations.new(request).run.object
  end

  private
    def parsed_date
      Date.parse params[:date]
    end
end
