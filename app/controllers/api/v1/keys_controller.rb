class Api::V1::KeysController < Api::V1::ApiController
  def index
   tour_id = params[:tour_id].to_i
   date = Date.parse params[:date]
   stations = Interactor::ListStations.new(tour_id, date).run.object
   @keys = stations.map do |t|
     t.customer.address.keys
   end.flatten
  end
end
