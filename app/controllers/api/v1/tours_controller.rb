class Api::V1::ToursController < Api::V1::ApiController
  def index
    date = Date.parse params[:date]
    @tours = Interactor::ListTours.new(date).run.object
  end
end
