require "date_range"

class Api::V1::OrdersController < Api::V1::ApiController
  respond_to :json

  def create
    if valid_request? params
      date = OfferingMapper.new.find(params[:offering_id]).date
      request = OpenStruct.new(customer_id: params[:customer_id].to_i, offering_ids: [params[:offering_id].to_i], note: params[:note], date: date)
      @order = InteractorFactory.execute(:create_order, request, current_user).object

      respond_with @order, status: 201
    else
      render json: {errors: errors.map { |e| {message: e} }}, status: 400
    end
  end

  def index
    from = Date.parse params[:from]
    to = Date.parse params[:to]
    @orders = OrderMapper.new.find_by_customer_id_and_date_range params[:customer_id], DateRange.new(from, to)
  end

  def deliver
    interact_with :deliver, request_from_id
    head :no_content
  end

  def load
    interact_with :load, request_from_id
    head :no_content
  end

  def note
    request = request_from_id
    request.note = params[:note]
    interact_with :create_ticket_for_order, request
    head :no_content
  end

  def cancel
    interact_with :cancel_order, request_from_id
    head :created
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

    def request_from_id
      OpenStruct.new(order_id: params[:id])
    end
end
