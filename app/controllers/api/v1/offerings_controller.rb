class Api::V1::OfferingsController < Api::V1::ApiController
  def index
    @offerings = organization.day(params[:date]).offerings
  end

  private
    def organization
      @organization ||= Organization.new
    end
end
