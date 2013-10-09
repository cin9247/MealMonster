class Api::V1::OfferingsController < Api::V1::ApiController
  def index
    result = {}
    result[:offerings] = organization.day(params[:date]).offerings.map do |o|
      {
        id: o.id,
        meals: o.menu.meals.map { |m| {name: m.name} },
        date: o.date.strftime("%Y-%m-%d")
      }
    end
    render json: result
  end

  private
    def organization
      @organization ||= Organization.new
    end
end
