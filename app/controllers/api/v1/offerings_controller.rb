class Api::V1::OfferingsController < Api::V1::ApiController
  def index
    date = Date.parse params[:date]
    @offerings = organization.day(date).offerings
  rescue
    render json: {errors: [{message: "invalid date"}]}, status: 400
  end

  private
    def organization
      @organization ||= Organization.new
    end
end
