class Api::V1::KeysController < Api::V1::ApiController
  def index
    tour_id = params[:tour_id].to_i
    date = Date.parse params[:date]
    request = OpenStruct.new(tour_id: tour_id, date: date)
    stations = Interactor::ListStations.new(request).run.object
    @keys = []
    stations.each do |s|
      s.customer.address.keys.each do |k|
        @keys << OpenStruct.new(id: k.id, name: k.name, customer_id: s.customer.id)
      end
    end
  end
end
