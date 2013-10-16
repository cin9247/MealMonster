class Api::V1::OrdersController < Api::V1::ApiController
  respond_to :json

  def create
    if valid_request? params
      customer = organization.find_customer_by_id params[:customer_id].to_i
      offering = organization.find_offering_by_id params[:offering_id].to_i
      @order = organization.day(offering.date).new_order customer: customer, offering: offering, note: params[:note]
      @order.place!

      respond_with @order, status: 201
    else
      render json: {errors: errors.map { |e| {message: e} }}, status: 400
    end
  end

  private
    def valid_request?(params)
      require_param :offering_id
      require_param :customer_id
      errors.blank?
    end

    def require_param(key)
      errors << "#{key} is missing" unless params.has_key?(key)
    end

    def errors
      @errors ||= []
    end
end
