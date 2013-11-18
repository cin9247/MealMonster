class Api::V1::ToursController < Api::V1::ApiController
  def index
    @tours = Interactor::ListTours.new(parsed_date).run.object
  end

  def show
    tour_id = params[:id].to_i
    @tour = TourMapper.new.find tour_id
    @stations = Interactor::ListStations.new(tour_id, parsed_date).run.object
  end

  private
    def parsed_date
      Date.parse params[:date]
    end
end
