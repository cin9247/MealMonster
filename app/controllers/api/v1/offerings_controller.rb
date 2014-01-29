require "date_range"

class Api::V1::OfferingsController < Api::V1::ApiController
  def index
    range =
      if params[:from] && params[:to]
        DateRange.parse params[:from], params[:to]
      elsif params[:date]
        DateRange.parse params[:date], params[:date]
      else
        DateRange.next_week
      end

    @offerings = interact_with(:list_offerings, range).object
  end
end
