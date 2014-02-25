class Api::V1::KeysController < Api::V1::ApiController
  def index
    tour_id = params[:tour_id].to_i
    date = Date.parse params[:date]

    @keys = KeyMapper.new.fetch_by_date_and_tour(date, tour_id)
  end
end
