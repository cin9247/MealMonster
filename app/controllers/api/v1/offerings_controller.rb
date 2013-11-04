class Api::V1::OfferingsController < Api::V1::ApiController
  def index
    from_date, to_date =
      if params[:from] && params[:to]
        from_date = Date.parse params[:from]
        to_date = Date.parse params[:to]
        [from_date, to_date]
      elsif params[:date]
        date = Date.parse params[:date]
        [date, date]
      else
        [Date.today, Date.today + 7.days]
      end

    @offerings = Interactor::ListOfferings.new(from_date, to_date).run.object

  rescue ArgumentError
    render json: {errors: [{message: "invalid date"}]}, status: 400
  end

  private
    def organization
      @organization ||= Organization.new
    end
end
