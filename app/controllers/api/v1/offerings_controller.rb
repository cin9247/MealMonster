class Api::V1::OfferingsController < Api::V1::ApiController
  def index
    if params[:from] && params[:to]
      from_date = Date.parse params[:from]
      to_date = Date.parse params[:to]
      @offerings = organization.days(from_date..to_date).offerings
    elsif params[:date]
      date = Date.parse params[:date]
      @offerings = organization.day(date).offerings
    end

  rescue ArgumentError
    render json: {errors: [{message: "invalid date"}]}, status: 400
  end

  private
    def organization
      @organization ||= Organization.new
    end
end
